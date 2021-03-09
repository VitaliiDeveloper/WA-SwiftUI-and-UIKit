//
//  WeatherListViewController.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import SnapKit
import SwiftUI

typealias WeatherListSmallCardViewModel = SmallWeatherTableViewCellViewModel

protocol WeatherListViewControllerProtocol: UIViewController {
    func show(_ model: [WeatherListSmallCardViewModel])
}

final class WeatherListViewController: UIViewController,
                                       WeatherListViewControllerProtocol,
                                       UISearchBarDelegate{
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.estimatedRowHeight = 150
        return tableView
    }()

    private lazy var tableViewItemProvider: TableViewItemProvider = {
        let provider = TableViewItemProvider(tableView: tableView) { [weak self] (indexPath) in
            self?.presenter.openDetails(on: indexPath)
        }
        return provider
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(systemItem: .cancel)
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(self.rightBarButtonItem(_:))
        return rightBarButtonItem
    }()

    private let presenter: WeatherListPresenting
    init(presenter: WeatherListPresenting) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()

        self.navigationController?.delegate = self
        self.view.backgroundColor = .white
        self.navigationItem.titleView = searchBar
        self.tableViewItemProvider.show(sections: [])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        presenter.viewWillAppear()
    }

    private func configTableView() {
        tableView.separatorStyle = .none
        tableView.register(SmallWeatherTableViewCell.self, forCellReuseIdentifier: String(describing: SmallWeatherTableViewCell.self))
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    @objc private func rightBarButtonItem(_ sender: UIBarButtonItem) {
        UIApplication.shared.endEditing()
    }

    // MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
        UIApplication.shared.endEditing()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        UIApplication.shared.endEditing()

        self.presenter.searchWeather(in: searchBar.text ?? .empty, present: true, completed: nil)
    }

    // MARK: - WeatherListViewControllerProtocol
    func show(_ model: [WeatherListSmallCardViewModel]) {
        var sections = [SectionTableView]()
        let generalHost = model.map({
            GeneralHostTableViewCell<SmallWeatherTableViewCell>(model: $0,
                                                                parentController: self)
        })
        
        sections.append(SectionTableView(header: nil, rows: generalHost, footer: nil))
        tableViewItemProvider.show(sections: sections)
    }
}

// MARK: - UINavigationControllerDelegate
extension WeatherListViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransitioning(animationDuration: 0.4, animationType: operation == .push ? .present : .dismiss)
    }
}

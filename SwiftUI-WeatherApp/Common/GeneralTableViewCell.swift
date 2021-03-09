//
//  GeneralTableViewCell.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/27/21.
//

import UIKit

protocol TableViewCellDataSource: TableViewCell {
    associatedtype ViewModel
    func set(viewModel: ViewModel)
}

protocol TableViewRowDataDisplayConfiguration: TableViewRowDataConfiguration {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

protocol TableViewRowDataConfiguration {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class GeneralTableViewCell<T: UITableViewCell>: TableViewRowDataConfiguration, TableViewCell where T: TableViewCellDataSource {
    private let viewModel: T.ViewModel

    init(model: T.ViewModel) {
        self.viewModel = model
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath)
        (cell as? T)?.set(viewModel: viewModel)
        return cell
    }
}

class GeneralHostTableViewCell<T: UITableViewCell>: GeneralTableViewCell<T>, TableViewRowDataDisplayConfiguration where T: HostCellDataSource {
    private weak var parentController: UIViewController?

    init(model: T.ViewModel, parentController: UIViewController) {
        super.init(model: model)
        self.parentController = parentController
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let parentController = parentController {
            (cell as? T)?.set(parentController: parentController)
        } else {
            assertionFailure("Parent Controller must to be exist")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let parentController = parentController else { return }
        (cell as? T)?.set(parentController: parentController)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? T)?.removeFromParentController()
    }
}

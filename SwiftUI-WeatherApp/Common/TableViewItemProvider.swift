//
//  TableViewItemProvider.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/27/21.
//

import SwiftUI

protocol HeaderFooterTableViewCell {
}
protocol TableViewCell {
}

class SectionTableView {
    var header: HeaderFooterTableViewCell?
    var rows: [TableViewCell]
    var footer: HeaderFooterTableViewCell?

    init(header: HeaderFooterTableViewCell?, rows: [TableViewCell], footer: HeaderFooterTableViewCell?) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}

final class TableViewItemProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let didSelectRow:((IndexPath) -> ())?

    // trashSectionsTableView - varible for didEndDisplaying on cell updating
    private var trashBagSectionsTableView: [SectionTableView]?
    private var sectionsTableView = [SectionTableView]() {
        didSet {
            trashBagSectionsTableView = oldValue
        }
    }

    private let bgHostingController = UIHostingController<EmptyContentView>(rootView: EmptyContentView())

    private let tableView: UITableView
    init(tableView: UITableView, didSelectRow: ((IndexPath) -> ())?) {
        self.tableView = tableView
        self.didSelectRow = didSelectRow
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func showBackgroundView() {
        let viewController = self.getViewController(in: tableView.next)
        viewController?.addChild(bgHostingController)
        viewController?.didMove(toParent: bgHostingController)

        tableView.backgroundView = bgHostingController.view
    }

    private func hideBackgroundView() {
        bgHostingController.removeFromParent()
        bgHostingController.view.removeFromSuperview()

        tableView.backgroundView = nil
    }

    private func getViewController(in responder: UIResponder?) -> UIViewController? {
        guard let responder = responder else {
            assertionFailure("Not found")
            return nil
        }

        if responder is UIViewController {
            return responder as? UIViewController
        } else {
            return self.getViewController(in: responder.next)
        }
    }

    func show(sections: [SectionTableView]) {
        self.sectionsTableView = sections

        if sections.count == 0 {
            self.showBackgroundView()
        } else {
            self.hideBackgroundView()
        }

        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsTableView.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsTableView[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sectionsTableView[indexPath.section].rows[indexPath.row] as? TableViewRowDataConfiguration
        return row?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = sectionsTableView[indexPath.section].rows[indexPath.row] as? TableViewRowDataDisplayConfiguration
        row?.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (trashBagSectionsTableView?.count ?? 0) > 0 {
            self.didEndDisplaying(at: trashBagSectionsTableView ?? [], indexPath: indexPath, cell: cell)
            trashBagSectionsTableView?[indexPath.section].rows.remove(at: indexPath.row)
        } else {
            didEndDisplaying(at: sectionsTableView, indexPath: indexPath, cell: cell)
        }
    }

    private func didEndDisplaying(at sections: [SectionTableView], indexPath: IndexPath, cell: UITableViewCell) {
        let row = sections[indexPath.section].rows[indexPath.row] as? TableViewRowDataDisplayConfiguration
        row?.tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
}

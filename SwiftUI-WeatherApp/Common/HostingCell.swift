//
//  HostingCell.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/27/21.
//

import SwiftUI

protocol HostCellDataSource: HostingCellDataSource, TableViewCellDataSource { }
protocol HostingCellDataSource {
    func set(parentController: UIViewController)
    func removeFromParentController()
}

class HostingCell<Content: View>: UITableViewCell, HostingCellDataSource {
    private lazy var hostingController = UIHostingController<Content?>(rootView: self.getRootView())
    var rootView: Content? {
        return hostingController.rootView
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(parentController: UIViewController) {
        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChild(hostingController)
        }

        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.snp.makeConstraints { (make) in
                make.edges.equalTo(contentView)
            }
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }

        self.hostingController.view.invalidateIntrinsicContentSize()
    }

    func removeFromParentController() {
        hostingController.removeFromParent()
    }

    func getRootView() -> Content? {
        assertionFailure("Need to be implemented")
        return nil
    }
}

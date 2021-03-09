//
//  AppRouter.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import UIKit

protocol Routing {
    func push(_ module: Module)
    func present(_ module: Module, completion: (() -> Void)?)
    func popToRoot()
}

protocol Router {
    var routing: Routing { get }

    init(routing: Routing)
    func startRouting()
}

final class AppRouter: Routing {
    private let navController: UINavigationController

    init(navController: UINavigationController) {
        self.navController = navController
    }

    func startRouting() {
        let weatherList = WeatherListRouter(routing: self)
        weatherList.startRouting()
    }

    func push(_ module: Module) {
        navController.pushViewController(module, animated: true)
    }

    func present(_ module: Module, completion: (() -> Void)?) {
        navController.present(module, animated: true, completion: completion)

    }

    func popToRoot() {
        navController.popToRootViewController(animated: true)
    }
}

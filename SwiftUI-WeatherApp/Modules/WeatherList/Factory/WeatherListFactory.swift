//
//  WeatherListFactory.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import Foundation

final class WeatherListFactory: ModuleCreator {
    func createModule(with router: WeatherListRouting) -> Module {
        let presenter = WeatherListPresenter(router: router)
        let controller = WeatherListViewController(presenter: presenter)

        presenter.view = controller

        return controller
    }
}

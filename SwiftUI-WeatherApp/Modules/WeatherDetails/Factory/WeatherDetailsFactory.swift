//
//  WeatherDetailsFactory.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/8/21.
//

import Foundation

final class WeatherDetailsFactory: ModuleCreator {
    private let weatherModel: WeatherViewModel
    init(weatherModel: WeatherViewModel) {
        self.weatherModel = weatherModel
    }

    func createModule(with router: WeatherDetailsRouting) -> Module {
        let presenter = WeatherDetailsPresenter(router: router, weatherModel: weatherModel)
        let controller = WeatherDetailsViewController(presenter: presenter)

        presenter.view = controller

        return controller
    }
}

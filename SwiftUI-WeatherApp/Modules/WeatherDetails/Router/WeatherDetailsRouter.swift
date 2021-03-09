//
//  WeatherDetailsRouter.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/8/21.
//

import Foundation

protocol WeatherDetailsRouting {
    func openWeatherList()
}

final class WeatherDetailsRouter: Router, WeatherDetailsRouting {
    var routing: Routing

    private var weatherModel: WeatherViewModel?
    convenience init(routing: Routing, weatherModel: WeatherViewModel) {
        self.init(routing: routing)
        self.weatherModel = weatherModel
    }

    init(routing: Routing) {
        self.routing = routing
    }

    func startRouting() {
        guard let weatherModel = weatherModel else {
            assertionFailure("You need to setup weatherModel")
            return
        }

        let module = WeatherDetailsFactory(weatherModel: weatherModel).createModule(with: self)
        routing.push(module)
    }

    func openWeatherList() {
        routing.popToRoot()
    }
}

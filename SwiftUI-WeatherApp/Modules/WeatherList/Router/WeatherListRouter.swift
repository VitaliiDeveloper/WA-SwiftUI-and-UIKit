//
//  WeatherListRouter.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import Foundation

protocol WeatherListRouting {
    func openWeatherDetails(with model: WeatherViewModel)
}

final class WeatherListRouter: Router, WeatherListRouting {
    var routing: Routing

    init(routing: Routing) {
        self.routing = routing
    }

    func startRouting() {
        let factory = WeatherListFactory()
        let module = factory.createModule(with: self)

        routing.push(module)
    }

    func openWeatherDetails(with model: WeatherViewModel) {
        let router = WeatherDetailsRouter(routing: routing, weatherModel: model)
        router.startRouting()
    }
}

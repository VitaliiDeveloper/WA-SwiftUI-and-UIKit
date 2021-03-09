//
//  WeatherDetailsPresenter.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/7/21.
//

import Foundation

protocol WeatherDetailsPresenting: ViewPresenting {
    func openWeatherList()
}

final class WeatherDetailsPresenter: WeatherDetailsPresenting {
    weak var view: WeatherDetailsViewControllerProtocol?

    private let weatherModel: WeatherViewModel
    private let router: WeatherDetailsRouting
    init(router: WeatherDetailsRouting, weatherModel: WeatherViewModel) {
        self.router = router
        self.weatherModel = weatherModel
    }

    func viewWillAppear() {
        let weatherList = weatherModel.list?.map({ (time: $0.timeString ?? .empty, temp: Int($0.main?.temp?.rounded() ?? 0)) })
        let detail = weatherModel.list?.first
        let details: [WeatherDetailsContentViewModel.Details] = [WeatherDetailsContentViewModel.Details(title1: "Clouds", value1: detail?.clouds?.all?.description ?? .empty,
                                                                                                        title2: "Wind", value2: detail?.wind?.speed?.description ?? .empty)]

        view?.show(with: WeatherDetailsContentViewModel(city: weatherModel.city?.name ?? .empty,
                                                        country: weatherModel.city?.country ?? .empty,
                                                        date: weatherModel.list?.first?.date ?? Date(),
                                                        weatherList: weatherList ?? [],
                                                        details: details))
    }

    func openWeatherList() {
        router.openWeatherList()
    }
}

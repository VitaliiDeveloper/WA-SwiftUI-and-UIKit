//
//  WeatherListPresenter.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import Foundation

protocol WeatherListPresenting: ViewPresenting {
    func searchWeather(in city: String, present: Bool, completed: (() -> ())?)
    func openDetails(on indexPath: IndexPath)
}

final class WeatherListPresenter: WeatherListPresenting {
    weak var view: WeatherListViewControllerProtocol?
    private var weatherRequest = WeatherRequest()
    private var weatherViewModels = [WeatherViewModel]()

    private var searchedCities = Set<String>()
    private var lastSearchDate:Date?

    private let router: WeatherListRouting
    init(router: WeatherListRouting) {
        self.router = router
    }

    func searchWeather(in city: String, present: Bool, completed: (() -> ())?) {
        self.loadWeatherRequest(city: city, complited: { [weak self] model in
            guard let self = self else { return }
            guard let model = model else { return }

            self.searchedCities.insert(city)
            self.weatherViewModels.append(model)
            self.lastSearchDate = Date()

            self.view?.show(self.generateModels(from: self.weatherViewModels))

            if present {
                self.router.openWeatherDetails(with: model)
            }
            completed?()
        })
    }

    func openDetails(on indexPath: IndexPath) {
        let model = weatherViewModels[indexPath.row]
        self.router.openWeatherDetails(with: model)
    }

    func viewWillAppear() {
        guard let lastSearch = self.lastSearchDate else { return }
        let sinceOneHourFromPrevDate = Date(timeInterval: 3600, since: lastSearch)
        if sinceOneHourFromPrevDate.compare(Date()) == ComparisonResult.orderedAscending {
            view?.show([])
            updatingWeatherViewModels()
        }
    }

    private func loadWeatherRequest(city: String, complited: @escaping ((WeatherViewModel?)->())) {
        do
        {
            try weatherRequest.request(city: city) { (model) in
                complited(model)
            }
        }
        catch
        {
            let error = error as? LocalizedError
            print(error?.errorDescription as Any)
        }
    }

    private func generateModels(from weather: [WeatherViewModel]) -> [WeatherListSmallCardViewModel] {
        let models = weather.map({ self.generateModel(from: $0) })
        return models
    }

    private func generateModel(from weather: WeatherViewModel) -> WeatherListSmallCardViewModel {
        let city: String = weather.city?.name ?? .empty
        var temp: Float = .zero
        var temp_min: Float = .zero
        var temp_max: Float = .zero
        let timeString: String = weather.list?.first?.timeString ?? .empty

        weather.list?.forEach({ (model) in
            temp = model.main?.temp ?? .zero

            let newMinTemp = model.main?.temp_min ?? .zero
            temp_min = newMinTemp > temp_min ? temp_min : newMinTemp

            let newMaxTemp = model.main?.temp_max ?? .zero
            temp_max = newMaxTemp < temp_max ? temp_max : newMaxTemp
        })

        return WeatherListSmallCardViewModel(city: city, temp: temp, tempMin: temp_min, tempMax: temp_max, timeString: timeString)
    }

    private func updatingWeatherViewModels() {
        let dispatchGroup = DispatchGroup()
        var newWeatherViewModels = [WeatherViewModel]()

        searchedCities.forEach { (city) in
            dispatchGroup.enter()

            self.loadWeatherRequest(city: city) { (model) in
                guard let model = model else { return }
                newWeatherViewModels.append(model)

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            self.weatherViewModels = newWeatherViewModels
            self.view?.show(self.generateModels(from: self.weatherViewModels))
        }
    }
}

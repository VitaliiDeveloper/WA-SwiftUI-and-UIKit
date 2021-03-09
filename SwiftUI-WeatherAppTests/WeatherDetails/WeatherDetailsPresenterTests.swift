//
//  WeatherDetailsPresenterTests.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/9/21.
//

import XCTest
@testable import SwiftUI_WeatherApp

final class WeatherDetailsPresenterTests: XCTestCase {
    func testOpenWeatherList() {
        let router = WeatherDetailsRouterMock()
        let presenter = makeInstance(router: router)
        presenter.openWeatherList()
        router.verifyCalled(.openWeatherList)
    }


    private func makeInstance(router: WeatherDetailsRouting,
                              view: WeatherDetailsViewControllerProtocol = WeatherDetailsViewDummy()) -> WeatherDetailsPresenter {
        let presenter = WeatherDetailsPresenter(router: router, weatherModel: WeatherViewModel(list: nil,
                                                                                               city: nil))
        presenter.view = view
        return presenter
    }
}

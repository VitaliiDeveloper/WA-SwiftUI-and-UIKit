//
//  WeatherListPresenterTests.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/8/21.
//

import XCTest
@testable import SwiftUI_WeatherApp

final class WeatherListPresenterTests: XCTestCase {
    func testOpenWeatherDetailsFromSearchPresented() {
        let (router, _) = self.presenterSearchWeatherDetails(present: true)
        router.verifyCalled(.openWeatherDetails)
    }

    func testOpenWeatherDetailsFromSearchNotPresented() {
        let (router, _) = self.presenterSearchWeatherDetails(present: false)
        router.verifyNotCalled(.openWeatherDetails)
    }

    func testOpenWeatherDetailsFirst() {
        let (router, presenter) = self.presenterSearchWeatherDetails(present: false)
        presenter.openDetails(on: IndexPath(row: 0, section: 0))
        router.verifyCalled(.openWeatherDetails)
    }

    private func presenterSearchWeatherDetails(present: Bool) -> (WeatherListRouterMock, WeatherListPresenter) {
        let router = WeatherListRouterMock()
        let presenter = makeInstance(router: router)
        let expectation = self.expectation(description: #function)

        presenter.searchWeather(in: "New York", present: present, completed: {
            expectation.fulfill()
        })

        waitForExpectations(timeout: 10)
        return (router, presenter)
    }

    private func makeInstance(router: WeatherListRouting,
                              view: WeatherListViewControllerProtocol = WeatherListViewDummy()) -> WeatherListPresenter {
        let presenter = WeatherListPresenter(router: router)
        presenter.view = view
        return presenter
    }
}

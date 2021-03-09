//
//  WeatherListRouterMock.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/8/21.
//

import XCTest
@testable import SwiftUI_WeatherApp

final class WeatherListRouterMock: WeatherListRouterDummy {
    private var log: [Action] = []

    convenience init() {
        self.init(routing: AppRoutingDummy())
    }

    override func openWeatherDetails(with model: WeatherViewModel) {
        log.append(.openWeatherDetails)
    }

    func verifyCalled(_ action: Action) {
        XCTAssertEqual([action], log)
    }

    func verifyNotCalled(_ action: Action) {
        XCTAssertNotEqual([action], log)
    }

    enum Action {
        case openWeatherDetails
    }
}

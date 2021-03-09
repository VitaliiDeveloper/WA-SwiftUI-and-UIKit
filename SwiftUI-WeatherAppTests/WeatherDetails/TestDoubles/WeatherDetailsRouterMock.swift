//
//  WeatherDetailsRouterMock.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/9/21.
//

import XCTest
@testable import SwiftUI_WeatherApp

final class WeatherDetailsRouterMock: WeatherDetailsRouterDummy {
    private var log: [Action] = []

    convenience init() {
        self.init(routing: AppRoutingDummy())
    }

    override func openWeatherList() {
        log.append(.openWeatherList)
    }

    func verifyCalled(_ action: Action) {
        XCTAssertEqual([action], log)
    }

    enum Action {
        case openWeatherList
    }
}

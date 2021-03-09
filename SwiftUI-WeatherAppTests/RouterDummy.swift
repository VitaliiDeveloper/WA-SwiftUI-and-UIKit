//
//  RouterDummy.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/8/21.
//

import Foundation
@testable import SwiftUI_WeatherApp

class RouterDummy: Router {
    var routing: Routing

    required init(routing: Routing) {
        self.routing = routing
    }
    func startRouting() { }
}

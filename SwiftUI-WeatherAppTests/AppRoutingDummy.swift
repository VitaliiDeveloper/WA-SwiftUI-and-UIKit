//
//  AppRoutingDummy.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/8/21.
//

import Foundation
@testable import SwiftUI_WeatherApp

class AppRoutingDummy: Routing {
    func push(_ module: Module) { }
    func present(_ module: Module, completion: (() -> Void)?) { }
    func popToRoot() { }
}

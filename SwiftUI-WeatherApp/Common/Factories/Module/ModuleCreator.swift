//
//  ModuleCreator.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import UIKit

typealias Module = UIViewController

protocol ModuleCreator {
    associatedtype Routing
    func createModule(with router: Routing) -> Module
}

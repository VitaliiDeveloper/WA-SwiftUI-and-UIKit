//
//  WeatherListViewDummy.swift
//  SwiftUI-WeatherAppTests
//
//  Created by Vitalii Lavreniuk on 3/8/21.
//

import UIKit
@testable import SwiftUI_WeatherApp

class WeatherListViewDummy: UIViewController, WeatherListViewControllerProtocol {
    func show(_ model: [WeatherListSmallCardViewModel]) { }
}

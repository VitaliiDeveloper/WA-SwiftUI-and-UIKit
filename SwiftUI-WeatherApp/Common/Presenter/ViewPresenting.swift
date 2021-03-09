//
//  ViewPresenting.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import UIKit

protocol ViewPresenting: AnyObject {
    func viewLoaded()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

extension ViewPresenting {

    func viewLoaded() { }

    func viewWillAppear() { }

    func viewDidAppear() { }

    func viewWillDisappear() { }

    func viewDidDisappear() { }

}

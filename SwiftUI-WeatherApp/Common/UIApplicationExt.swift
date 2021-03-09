//
//  UIApplicationExt.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/26/21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

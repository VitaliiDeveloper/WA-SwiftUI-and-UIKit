//
//  StringExt.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/25/21.
//

import Foundation

extension String {
    @inline(__always)
    static var empty: String {
        return ""
    }

    @inline(__always)
    var isEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).count == 0
    }
}

//
//  AppDelegate.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/23/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appRouter: AppRouter?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let navController = UINavigationController()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        appRouter = AppRouter(navController: navController)
        appRouter?.startRouting()

        return true
    }
}


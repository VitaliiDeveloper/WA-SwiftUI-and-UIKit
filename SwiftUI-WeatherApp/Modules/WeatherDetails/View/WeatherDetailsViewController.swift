//
//  WeatherDetailsViewController.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/7/21.
//

import Combine
import SwiftUI

protocol WeatherDetailsViewControllerProtocol: UIViewController {
    func show(with model: WeatherDetailsContentViewModel)
}

final class WeatherDetailsViewController: UIHostingController<WeatherDetailsContentView>, WeatherDetailsViewControllerProtocol {
    private let presenter: WeatherDetailsPresenting
    init(presenter: WeatherDetailsPresenting) {
        self.presenter = presenter

        super.init(rootView: WeatherDetailsContentView(viewModel: WeatherDetailsContentViewModel(city: .empty,country: .empty, date: Date(), weatherList: [], details: []))
        {
            presenter.openWeatherList()
        })
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter.viewWillAppear()
    }

    func show(with model: WeatherDetailsContentViewModel) {
        rootView.viewModel = model
    }
}

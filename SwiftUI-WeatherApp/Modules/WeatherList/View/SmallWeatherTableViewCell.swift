//
//  SmallWeatherTableViewCell.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/27/21.
//

import UIKit

struct SmallWeatherTableViewCellViewModel {
    let city: String
    let temp: Float
    let tempMin: Float
    let tempMax: Float
    let timeString: String
}

final class SmallWeatherTableViewCell: HostingCell<SmallWeatherContentView>, HostCellDataSource {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setupUI()
    }

    private func setupUI() {
        self.selectedBackgroundView = UIView()
    }

    func set(viewModel: SmallWeatherTableViewCellViewModel) {
        rootView?.viewModel.city = viewModel.city
        rootView?.viewModel.time = viewModel.timeString
        rootView?.viewModel.temp = viewModel.temp
        rootView?.viewModel.minTemp = viewModel.tempMin
        rootView?.viewModel.maxTemp = viewModel.tempMax
    }

    override func getRootView() -> SmallWeatherContentView? {
        SmallWeatherContentView(viewModel: SmallWeatherViewModel())
    }
}

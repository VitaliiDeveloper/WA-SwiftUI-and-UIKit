//
//  WeatherDetailsContentView.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/7/21.
//

import Combine
import SwiftUI

// MARK: - ViewModels
final class WeatherDetailsContentViewModel: ObservableObject {
    typealias WeatherList = (time: String, temp: Int)

    class Details: ObservableObject {
        @Published var title1: String
        @Published var value1: String

        @Published var title2: String
        @Published var value2: String

        init(title1: String,
             value1: String,
             title2: String,
             value2: String) {

            self.title1 = title1
            self.value1 = value1
            self.title2 = title2
            self.value2 = value2
        }
    }

    @Published var city: String
    @Published var country: String
    @Published var date: Date
    @Published var weatherList:[WeatherList]
    @Published var details: [Details]

    init(city: String, country: String, date: Date, weatherList:[WeatherList],  details: [Details]) {
        self.city = city
        self.country = country
        self.date = date
        self.weatherList = weatherList
        self.details = details
    }
}

private class WeatherDetailViewModel: ObservableObject {
    @Published var details: [WeatherDetailsContentViewModel.Details]
    init(details: [WeatherDetailsContentViewModel.Details]) {
        self.details = details
    }
}

private struct WeatherMainInfoViewModel {
    func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd MMM"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Views
private struct Separator: View {
    var body: some View {
        Rectangle()
            .frame(height: 1, alignment: .leading)
            .foregroundColor(.gray)
    }
}

private struct WeatherMainInfoView: View {
    private let viewModel = WeatherMainInfoViewModel()

    @State var size: CGSize
    @State var city: String
    @State var country: String
    @State var date: Date
    @State var temp: String
    @State var weatherList: [WeatherDetailsContentViewModel.WeatherList]

    let burgerMenuAction: (() -> ())?

    var body: some View {
        // MARK: - Main information
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            Image("starSky")
                .resizable()
                .frame(width: size.width)
                .offset(x: 0, y: -1)

            // MARK: - Burger menu
            VStack(spacing: 4) {
                ForEach(1..<4) { index in
                    Rectangle()
                        .frame(height: 3, alignment: .center)
                        .cornerRadius(2)
                }
            }
            .padding(EdgeInsets(top: 75, leading: 0, bottom: 0, trailing: 30))
            .foregroundColor(.white)
            .frame(width: 50, height: 30, alignment: .trailing)
            .onTapGesture {
                burgerMenuAction?()
            }

            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    Text(city)
                        .bold()
                    Text(", ")
                    Text(country)
                }
                .font(.title2)

                VStack(spacing: 3) {
                    Text("Today")
                        .font(.title)
                        .bold()

                    Text(viewModel.getDateString(from: date))
                        .font(.system(size: 11))
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))

                HStack(alignment: .top, spacing: 5) {
                    Text(temp)
                        .font(.system(size: 50))
                    Text("℃")
                        .font(.system(size: 20))
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))

                VStack(alignment: .leading) {
                    Text("Today")
                        .font(.system(size: 15, weight: Font.Weight.medium))
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                    Separator()
                }
                .frame(width: size.width, alignment: .leading)

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(0..<weatherList.count) { index in
                            VStack(spacing: 5) {
                                Text(weatherList[index].time)
                                    .font(.system(size: 13, weight: Font.Weight.medium))

                                ZStack {
                                    Capsule()
                                        .opacity(0.2)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white, lineWidth: 1.0)
                                                .opacity(0.5)
                                        )

                                    HStack(spacing: 0) {
                                        Text(weatherList[index].temp.description)
                                            .font(.system(size: 15, weight: Font.Weight.medium))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.4)

                                        Text("℃")
                                            .font(.system(size: 10))
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                                }
                                .foregroundColor(.white)
                                .frame(width: 40, height: 65, alignment: .center)
                            }
                        }

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 0))
                    .frame(minWidth: size.width, alignment: .leading)
                }

                Spacer()
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            .frame(height: size.height - 350)
        }
    }
}

private struct WeatherDetailView: View {
    @State var size: CGSize
    @State var viewModel: WeatherDetailViewModel

    var body: some View {
        // MARK: - Details
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<viewModel.details.count) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.details[index].title1)
                                .font(.system(size: 12, weight: Font.Weight.regular))
                                .foregroundColor(.gray)
                            Text(viewModel.details[index].value1)
                                .font(.system(size: 30, weight: Font.Weight.medium))
                                .foregroundColor(.black)
                        }
                        .frame(minWidth: 0, maxWidth: size.width / 2, alignment: .leading)

                        VStack(alignment: .leading) {
                            Text(viewModel.details[index].title2)
                                .font(.system(size: 12, weight: Font.Weight.regular))
                                .foregroundColor(.gray)
                            Text(viewModel.details[index].value2)
                                .font(.system(size: 30, weight: Font.Weight.medium))
                                .foregroundColor(.black)
                        }
                        .frame(minWidth: 0, maxWidth: size.width / 2, alignment: .leading)
                    }
                    .frame(height: 100)
                    Separator()
                }
            }
            .frame(width: size.width - CGFloat(50), alignment: .center)
        }
        .frame(minWidth: size.width, minHeight: 300, alignment: .top)
        .foregroundColor(.white)
        .background(Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .fixedSize(horizontal: false, vertical: false)
        .shadow(color: .white, radius: 7)
    }
}

struct WeatherDetailsContentView: View {
    @ObservedObject var viewModel: WeatherDetailsContentViewModel

    let burgerMenuAction: (() -> ())?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                WeatherMainInfoView(size: UIScreen.main.bounds.size,
                                    city: viewModel.city,
                                    country: viewModel.country,
                                    date: viewModel.date,
                                    temp: viewModel.weatherList.first?.temp.description ?? .empty,
                                    weatherList: viewModel.weatherList,
                                    burgerMenuAction: burgerMenuAction)
                WeatherDetailView(size: UIScreen.main.bounds.size,
                                  viewModel: WeatherDetailViewModel(details: viewModel.details))
            }
            .background(Color.black)
        }
        .foregroundColor(Color.white)
        .ignoresSafeArea()
    }
}

struct WeatherDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsContentView(viewModel: WeatherDetailsContentViewModel(city: "Vinnitsa",
                                                                            country: "Ukraine",
                                                                            date: Date(),
                                                                            weatherList: [(time: "00:00", temp: -10), (time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10),(time: "00:00", temp: -10), (time: "03:00", temp: 5)],
                                                                            details: [WeatherDetailsContentViewModel.Details(title1: "Sunrise",
                                                                                                                             value1: "7:28",
                                                                                                                             title2: "Sunset",
                                                                                                                             value2: "3:55")]), burgerMenuAction: nil)
        //            .ignoresSafeArea()
        //            .previewLayout(PreviewLayout.sizeThatFits)
        //            .frame(width: UIScreen.main.bounds.width,
        //                   height: 800, alignment: .center)
    }
}

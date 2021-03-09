//
//  WeatherRequest.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/25/21.
//

import Combine
import Foundation

struct WeatherListViewModel: Decodable, Identifiable {
    struct WeatherListMain: Decodable {
        let temp: Float?
        let temp_min: Float?
        let temp_max: Float?
    }

    struct Clouds: Decodable {
        let all: Int?
    }

    struct Wind: Decodable {
        let speed: Double?
        let deg: Int?
    }

    enum CodingKeys: String, CodingKey {
        case main
        case visibility
        case clouds
        case wind
        case dt_txt
    }

    let id = UUID()
    let main: WeatherListMain?
    let dt_txt: String?
    let visibility: Int?
    let clouds: Clouds?
    let wind: Wind?
    var date: Date?
    var timeString: String?
    var dateString: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        main = try? container.decode(WeatherListMain.self, forKey: CodingKeys.main)
        visibility = try? container.decode(Int.self, forKey: .visibility)
        wind = try? container.decode(Wind.self, forKey: .wind)
        clouds = try? container.decode(Clouds.self, forKey: .clouds)
        dt_txt = try? container.decode(String.self, forKey: CodingKeys.dt_txt)

        if let dt_txt = dt_txt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            if let date = dateFormatter.date(from: dt_txt) {
                self.date = date

                let calendar = Calendar.current
                let hour = addZeroOnBeginningIfLessTwoChars(value: calendar.component(.hour, from: date).description)
                let minutes = addZeroOnBeginningIfLessTwoChars(value: calendar.component(.minute, from: date).description)

                let day = addZeroOnBeginningIfLessTwoChars(value: calendar.component(.day, from: date).description)
                let month = addZeroOnBeginningIfLessTwoChars(value: calendar.component(.month, from: date).description)
                let year = addZeroOnBeginningIfLessTwoChars(value: calendar.component(.year, from: date).description)

                timeString = "\(hour):\(minutes)"
                dateString = "\(year)/\(month)/\(day)"
            }
        }
    }

    private func addZeroOnBeginningIfLessTwoChars(value: String) -> String {
        return (value.count >= 2) ? value : "0\(value)"
    }
}

struct WeatherCityListViewModel: Decodable {
    let name: String?
    let country: String?
    let timezone: Int?
}

struct WeatherViewModel: Decodable {
    let list: [WeatherListViewModel]?
    let city: WeatherCityListViewModel?
}

struct WeatherRequest {
    typealias Completed = ((WeatherViewModel?) -> ())
    private var anyCancellable = Set<AnyCancellable>()

    /// Tread safe
    mutating func request(city: String, completed: @escaping Completed) throws {
        let cityPercentEncoding = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? .empty
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityPercentEncoding)&appid=886705b4c1182eb1c69f28eb8c520e20&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherRequestError.urlNotValid
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, res) in
                guard let httpRes = res as? HTTPURLResponse,
                      httpRes.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherViewModel.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { result in
                if case .failure( _) = result {
                    print(result)
                    completed(nil)
                }
            }) { (weatherViewModel) in
                completed(weatherViewModel)
            }
            .store(in: &anyCancellable)
    }
}

extension WeatherRequest {
    enum WeatherRequestError: LocalizedError {
        case urlNotValid

        var errorDescription: String? {
            return "URL not valid"
        }
    }
}

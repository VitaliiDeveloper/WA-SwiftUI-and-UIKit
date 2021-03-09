//
//  SmallWeatherView.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/24/21.
//

import SwiftUI

class SmallWeatherViewModel: ObservableObject {
    @Published var city: String
    @Published var time: String
    @Published var temp: Float
    @Published var minTemp: Float
    @Published var maxTemp: Float

    init(city: String = .empty,
         time: String = .empty,
         temp: Float = 0,
         minTemp: Float = 0,
         maxTemp: Float = 0) {
        self.city = city
        self.time = time
        self.temp = temp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
}

struct SmallWeatherContentView: View {
    @ObservedObject var viewModel: SmallWeatherViewModel

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.city)
                    .font(.system(size: 26, weight: .bold))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.black)

                Spacer()

                Text(viewModel.time)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)

                ZStack {
                    ShapeBG()
                        .foregroundColor(.orange)
                        .padding(EdgeInsets(top: 0,
                                            leading: -25,
                                            bottom: 0,
                                            trailing: 0))
                    HStack {
                        Text("\(viewModel.temp.description)℃")
                            .foregroundColor(.white)
                            .font(.system(size: 26))
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)

                        VStack(alignment: .trailing) {
                            Text("мин: \(viewModel.minTemp.description)℃")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)

                            Text("мaкс: \(viewModel.maxTemp.description)℃")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                //.fixedSize(horizontal: true, vertical: false)
            }
            .background(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)
            .frame(minHeight: 75)
            .padding(EdgeInsets(top: 20, leading: 3, bottom: 20, trailing: 3))
        }
    }
}

struct ShapeBG: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX + 30, y: rect.minY), control: CGPoint(x: rect.minX + 30, y: rect.midY + 10))
        }
    }
}

struct SmallWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWeatherContentView(viewModel: SmallWeatherViewModel(city: "Moskov",
                                                                time: "8:20",
                                                                temp: 6,
                                                                minTemp: 3,
                                                                maxTemp: 16.4))
            .previewLayout(PreviewLayout.sizeThatFits)
            .frame(width: UIScreen.main.bounds.width,
                   height: 155, alignment: .center)
    }
}

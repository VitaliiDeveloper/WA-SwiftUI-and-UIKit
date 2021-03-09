//
//  EmptyView.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 1/28/21.
//

//https://medium.com/apple-developer-academy-federico-ii/drawings-and-animations-in-swiftui-3a2da460e492
import SwiftUI
import Combine

private class RoundRectViewModel: ObservableObject {
    @Published var opacity: Double = Constants.minOpacity
    private let updatingOpacityEvery: Double
    private var anyCancalable: AnyCancellable?

    init(updatingOpacityEvery: Double) {
        self.updatingOpacityEvery = updatingOpacityEvery
        self.loadTimerOpacityUpdating()
    }

    private func loadTimerOpacityUpdating() {
        anyCancalable = Timer.publish(every: updatingOpacityEvery,
                                      on: RunLoop.main,
                                      in: .default)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] (output) in
                guard let opacity = self?.opacity else { return }
                self?.opacity = (opacity == Constants.maxOpacity) ?  Constants.minOpacity : Constants.maxOpacity
            }
    }

    private struct Constants {
        static let minOpacity: Double = 0.55
        static let maxOpacity: Double = 0.75
    }
}

private struct RoundRectView: View {
    @StateObject var viewModel: RoundRectViewModel

    var body: some View {
        Capsule()
            .offset(y: 38)
            .frame(width: 50, height: 70)
            .opacity(viewModel.opacity)
    }
}

struct EmptyContentView: View {
    private var colors:[Color] = [.purple, .pink, .red, .orange, .green, .purple, .yellow, .blue]

    var body: some View {
        ZStack {
            Circle()
                .stroke()
                .frame(width: 75, height: 75)
                .opacity(0)

            ForEach(1..<9) { index in
                RoundRectView(viewModel: RoundRectViewModel(updatingOpacityEvery: 0.6 * Double(index)))
                    .foregroundColor(colors[index - 1])
                    .rotationEffect(.degrees(Double(index * 45)))
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyContentView()
    }
}

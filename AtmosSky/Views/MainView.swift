//
//  MainView.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView(sunsetTime: viewModel.getSunsetTime(), sunriseTime: viewModel.getSunriseTime(), currentWeatherCode: viewModel.getCurrentWeatherCode(), isNight: viewModel.getIsNight())
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
//                
                WeatherInfoRow(
                    title: "Ciudad",
                    value: viewModel.weatherInformation?.cityName ?? "-",
                    systemImage: "location.fill"
                )
//                
//                WeatherInfoRow(
//                    title: "Temperatura",
//                    value: "\(viewModel.weatherInformation?.temperature ?? 0, default: "%.1f")°C",
//                    systemImage: "thermometer"
//                )
//                
//                WeatherInfoRow(
//                    title: "Humedad",
//                    value: "\(Int(viewModel.weatherInformation?.humidity ?? 0))%",
//                    systemImage: "humidity.fill"
//                )
//                
//                WeatherInfoRow(
//                    title: "Viento",
//                    value: "\(Int(viewModel.weatherInformation?.windSpeed ?? 0)) km/h",
//                    systemImage: "wind"
//                )
//                
                Button {
                    viewModel.refreshLocation()
                } label: {
                    Text("Refresh")
                }
            }
            .padding()
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}

extension MainView {
    var textResult: some View {
        HStack {
            Text(viewModel.weatherInformation?.cityName ?? "")
            Text("\(viewModel.weatherInformation?.temperature ?? 0, specifier: "%.1f")°")
        }
    }
}


#Preview {
    MainView()
}

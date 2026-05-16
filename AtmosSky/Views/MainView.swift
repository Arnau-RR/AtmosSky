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
            
            ScrollView {
                VStack(spacing: 12) {
                    
                    HeaderWithTemperatureView(city: viewModel.weatherInformation?.cityName ?? "-", temperature: viewModel.getCurrentTemperature(), currentDate: viewModel.getCurrentDate(), sunrise: viewModel.getSunriseTime() ?? Date(), sunset: viewModel.getSunsetTime() ?? Date(), weatherDescription: viewModel.getWeatherDescription(), maxTemperature: viewModel.getWeatherMax(), minTemperature: viewModel.getWeatherMin())
                        .padding()
                    
                    GlassCardComponent {
                        informationWeatherRectangle
                    }
                    
                    GlassCardComponent {
                        informationHourlyRectangle
                    }
                    
                    Spacer()
                    //
                    //                WeatherInfoRow(
                    //                    title: "Ciudad",
                    //                    value: viewModel.weatherInformation?.cityName ?? "-",
                    //                    systemImage: "location.fill"
                    //                )
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
        }
        //.ignoresSafeArea()
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}

extension MainView {
    
    var informationWeatherRectangle: some View {
        HStack {
            WeatherInfoCard(
                icon: "thermometer.variable",
                title: "Sensación",
                value: "\(viewModel.getWeatherSensationTemperature())°",
                //subtitle: "Actual: \(viewModel.getWeatherSensationTemperature())°"
            )
            
            WeatherInfoCard(
                icon: "drop.degreesign",
                title: "Humedad",
                value: "\(viewModel.getWeatherHumidity())%"
            )
            
            WeatherInfoCard(
                icon: "wind",
                title: "Viento",
                value: "\(viewModel.getWeatherWind()) km/h"
            )
        }
    }
    
    var informationHourlyRectangle: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.getHourlyComplete24HoursDay(), id: \.id) { hourlyObject in
                    HourlyWeatherCardView(
                        value: "\(Int(hourlyObject.temperature))°",
                        weatherCode: hourlyObject.weatherCode,
                        time: hourlyObject.date.formatted(
                            .dateTime
                                .hour(.twoDigits(amPM: .omitted))
                                .minute(.twoDigits)
                        )
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
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

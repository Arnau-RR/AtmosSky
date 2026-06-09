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
            BackgroundView(
                sunsetTime: viewModel.getSunsetTime(),
                sunriseTime: viewModel.getSunriseTime(),
                currentWeatherCode: viewModel.getCurrentWeatherCode(),
                isNight: viewModel.getIsNight()
            )
            .ignoresSafeArea()

            // Loading inicial (solo la primera vez al abrir la app)
            if viewModel.getInitialLoading() {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)

                        Text("Cargando el tiempo...")
                            .font(.headline)
                    }
                    .padding(30)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .transition(.opacity)
            }

            ScrollView {
                VStack(spacing: 12) {

                    HeaderWithTemperatureView(
                        city: viewModel.weatherInformation?.cityName ?? "-",
                        temperature: viewModel.getCurrentTemperature(),
                        currentDate: viewModel.getCurrentDate(),
                        sunrise: viewModel.getSunriseTime() ?? Date(),
                        sunset: viewModel.getSunsetTime() ?? Date(),
                        weatherDescription: viewModel.getWeatherDescription(),
                        maxTemperature: viewModel.getWeatherMax(),
                        minTemperature: viewModel.getWeatherMin()
                    )
                    .padding()

                    GlassCardComponent {
                        informationWeatherRectangle
                    }

                    GlassCardComponent {
                        informationHourlyRectangle
                    }

                    GlassCardComponent {
                        informationDailyRectangle
                    }

                    Spacer()
                }
                .padding()
                .opacity(viewModel.getInitialLoading() ? 0.3 : 1.0)
            }
        }
        .refreshable {
            await refreshWeather()
        }
        .onAppear {
            viewModel.requestLocationPermission()
        }
        .onChange(of: viewModel.weatherInformation != nil) { _, hasWeather in
            if hasWeather && viewModel.getInitialLoading() {
                withAnimation(.easeOut(duration: 0.3)) {
                    viewModel.setInitialLoadingState(false)
                }
            }
        }
    }
}

extension MainView {

    @MainActor
    private func refreshWeather() async {
        viewModel.refreshLocation()

        while viewModel.getLoadingState() == true {
            try? await Task.sleep(for: .milliseconds(100))
        }
    }

    var informationWeatherRectangle: some View {
        HStack {
            WeatherInfoCard(
                icon: "thermometer.variable",
                title: "Sensación",
                value: "\(viewModel.getWeatherSensationTemperature())°",
                iconColor: Color(red: 0.88, green: 0.55, blue: 0.96)
            )

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 1, height: 80)
                .foregroundColor(.white.opacity(0.4))

            WeatherInfoCard(
                icon: "drop.degreesign",
                title: "Humedad",
                value: "\(viewModel.getWeatherHumidity())%",
                iconColor: Color(red: 0.45, green: 0.75, blue: 1.00)
            )

            RoundedRectangle(cornerRadius: 10)
                .frame(width: 1, height: 80)
                .foregroundColor(.white.opacity(0.4))

            WeatherInfoCard(
                icon: "wind",
                title: "Viento",
                value: "\(viewModel.getWeatherWind()) km/h",
                iconColor: Color(red: 0.45, green: 0.90, blue: 0.95)
            )
        }
    }

    // FIX: DateFormatter con la TimeZone de la ubicación consultada
    // en lugar de la zona horaria del dispositivo
    var informationHourlyRectangle: some View {
        let formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            f.timeZone = viewModel.getLocationTimeZone() // ✅ hora correcta de la ubicación
            return f
        }()

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.getHourlyComplete24HoursDay(), id: \.id) { hourlyObject in
                    HourlyWeatherCardView(
                        value: "\(Int(hourlyObject.temperature))°",
                        weatherCode: hourlyObject.weatherCode,
                        time: formatter.string(from: hourlyObject.date), // ✅
                        isNight: viewModel.isNight(for: hourlyObject.date)
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    var informationDailyRectangle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Próximos días")
                .textCase(.uppercase)
                .foregroundStyle(.white)
                .font(.caption)
                .padding(.bottom, 2)

            ForEach(viewModel.getDailyInformation(), id: \.id) { dayObject in
                DailyWeatherRowView(
                    day: viewModel.formattedDay(from: dayObject.date, index: 0),
                    weatherCode: dayObject.weatherCode,
                    minTemp: dayObject.minTemperature,
                    maxTemp: dayObject.maxTemperature,
                    weekMin: viewModel.getWeekMinTemperature(),
                    weekMax: viewModel.getWeekMaxTemperature()
                )
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

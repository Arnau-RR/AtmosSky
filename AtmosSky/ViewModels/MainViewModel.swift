//
//  MainViewModel.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class MainViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var latitude: Double?
    @Published private(set) var longitude: Double?
    @Published private(set) var weatherInformation: WeatherData?
    @Published private(set) var isLoading: Bool = false
    @Published private var isInitialLoading = true
    @Published private(set) var hasFinishedInitialLoad: Bool = false

    // MARK: - Dependencies

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    private let reverseGeocodingService: ReverseGeocodingServiceProtocol


    // MARK: - Initialization

    init(locationService: LocationService? = nil) {
        isInitialLoading = true
        self.locationService = locationService ?? LocationService()
        weatherService = WeatherService()
        reverseGeocodingService = ReverseGeocodingService()
        bindLocationService()
    }

    // MARK: - Public API

    func requestLocationPermission() {
        guard !isLoading else { return }

        isLoading = true
        locationService.requestPermission()
    }

    func refreshLocation() {
        guard !isLoading else { return }

        isLoading = true
        locationService.requestLocation()
    }

    func callWeatherAPI() async {

        guard let latitudeSecure = latitude,
              let longitudeSecure = longitude else {
            isLoading = false
            return
        }

        do {
            let cityName = try await reverseGeocodingService.reverseGeocoding(latitude: latitudeSecure, longitude: longitudeSecure)
            weatherInformation = try await weatherService.fetchWeather(latitude: latitudeSecure, longitude: longitudeSecure)
            weatherInformation?.cityName = cityName

        } catch let error {
            print(error)
        }

        isLoading = false
    }

    // MARK: - Getters

    func getSunsetTime() -> Date? {
        return weatherInformation?.dailyForecast?.first?.sunset
    }

    func getSunriseTime() -> Date? {
        return weatherInformation?.dailyForecast?.first?.sunrise
    }

    func getCurrentWeatherCode() -> Int {
        return weatherInformation?.currentWeatherCode ?? 0
    }

    func getIsNight() -> Bool {
        return weatherInformation?.isNight ?? false
    }

    func getCurrentDate() -> Date {
        return weatherInformation?.localDate ?? Date()
    }

    func getCurrentTemperature() -> Int {
        return Int(weatherInformation?.temperature ?? 0)
    }

    func getWeatherDescription() -> String {
        return weatherInformation?.currentWeatherDescription ?? ""
    }

    func getWeatherSensationTemperature() -> Int {
        return Int(weatherInformation?.apparentTemperature ?? 0)
    }

    func getWeatherHumidity() -> Int {
        return Int(weatherInformation?.humidity ?? 0)
    }

    func getWeatherWind() -> Int {
        return Int(weatherInformation?.windSpeed ?? 0)
    }

    func getWeatherMax() -> Int {
        return Int(weatherInformation?.maxTemperature ?? 0)
    }

    func getWeatherMin() -> Int {
        return Int(weatherInformation?.minTemperature ?? 0)
    }

    func getWeatherHourly() -> [HourlyForecast] {
        return weatherInformation?.hourlyForecast ?? []
    }

    func getWeatherDaily() -> [DailyForecast] {
        return weatherInformation?.dailyForecast ?? []
    }

    func getLoadingState() -> Bool {
        return isLoading
    }

    func getInitialLoading() -> Bool {
        return isInitialLoading
    }

    func setInitialLoadingState(_ state: Bool) {
        self.isInitialLoading = state
    }

    func getHasFinishedInitialLoad() -> Bool {
        return hasFinishedInitialLoad
    }

    func getWeekMinTemperature() -> Double {
        return weatherInformation?.dailyForecast?
            .map(\.minTemperature)
            .min() ?? 0
    }

    func getWeekMaxTemperature() -> Double {
        return weatherInformation?.dailyForecast?
            .map(\.maxTemperature)
            .max() ?? 1
    }

    // FIX: Usa la TimeZone de la ubicación consultada en vez de la del dispositivo
    func getLocationTimeZone() -> TimeZone {
        return weatherInformation?.timeZone ?? .current
    }

    // FIX: Calendar con la zona horaria de la ubicación para comparar horas correctamente
    func getHourlyComplete24HoursDay() -> [HourlyForecast] {
        let hourly = getWeatherHourly()

        var calendar = Calendar.current
        calendar.timeZone = getLocationTimeZone() // ✅ zona de la ubicación, no del dispositivo

        let localDate = weatherInformation?.localDate ?? Date()

        guard let startIndex = hourly.firstIndex(where: { forecast in
            calendar.isDate(forecast.date, inSameDayAs: localDate) &&
            calendar.component(.hour, from: forecast.date) ==
            calendar.component(.hour, from: localDate)
        }) else {
            return []
        }

        let endIndex = min(startIndex + 24, hourly.count)
        return Array(hourly[startIndex..<endIndex])
    }

    // FIX: Calendar con la zona horaria de la ubicación para que "Hoy" sea correcto allí
    func getDailyInformation() -> [DailyForecast] {
        let daily = getWeatherDaily()

        var calendar = Calendar.current
        calendar.timeZone = getLocationTimeZone() // ✅ zona de la ubicación, no del dispositivo

        let localDate = weatherInformation?.localDate ?? Date()

        guard let startIndex = daily.firstIndex(where: { forecast in
            calendar.isDate(forecast.date, inSameDayAs: localDate)
        }) else {
            return []
        }

        return Array(daily[startIndex...])
    }

    // FIX: Calendar con la zona horaria de la ubicación para que "Hoy"/"Mañana" sean correctos allí
    func formattedDay(from date: Date, index: Int) -> String {
        var calendar = Calendar.current
        calendar.timeZone = getLocationTimeZone() // ✅ zona de la ubicación, no del dispositivo

        if calendar.isDateInToday(date) {
            return "Hoy"
        }

        if calendar.isDateInTomorrow(date) {
            return "Mañana"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.timeZone = getLocationTimeZone() // ✅
        formatter.dateFormat = "EEEE"

        return formatter.string(from: date).capitalized
    }

    // MARK: - Private Methods

    private func bindLocationService() {
        locationService.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }

                self.currentLocation = location
                self.latitude = location?.coordinate.latitude
                self.longitude = location?.coordinate.longitude

                if location != nil {
                    Task {
                        await self.callWeatherAPI()
                    }
                }
            }
            .store(in: &cancellables)

        locationService.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
            }
            .store(in: &cancellables)
    }

    func checkIfIsNight(date: Date, sunrise: Date?, sunset: Date?) -> Bool {
        return false
    }
    
    func isNight(for date: Date) -> Bool {
        guard let dailyForecasts = weatherInformation?.dailyForecast else {
            return weatherInformation?.isNight ?? false
        }

        // date ya es UTC, sunrise/sunset también son UTC → comparar directo
        guard let dayForecast = dailyForecasts.first(where: { forecast in
            guard let sunrise = forecast.sunrise,
                  let sunset = forecast.sunset else { return false }
            return date >= sunrise && date < sunset
        }),
        let sunrise = dayForecast.sunrise,
        let sunset = dayForecast.sunset else {
            return true
        }

        return !(date >= sunrise && date < sunset)
    }
    
//    func isNight(for date: Date) -> Bool {
//        guard let dailyForecasts = weatherInformation?.dailyForecast else {
//            return weatherInformation?.isNight ?? false
//        }
//
//        var calendar = Calendar.current
//        calendar.timeZone = getLocationTimeZone()
//
//        // Buscar el DailyForecast cuyo día coincida con la fecha de la hora
//        guard let dayForecast = dailyForecasts.first(where: {
//            calendar.isDate($0.date, inSameDayAs: date)
//        }),
//        let sunrise = dayForecast.sunrise,
//        let sunset = dayForecast.sunset else {
//            return weatherInformation?.isNight ?? false
//        }
//
//        // Es de noche si la hora está antes del amanecer o después del atardecer
//        return !(date >= sunrise && date < sunset)
//    }
}

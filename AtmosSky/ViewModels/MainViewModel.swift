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

    // MARK: - Private Methods
    
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
    
    func getHourlyComplete24HoursDay() -> [HourlyForecast] {
        let hourly = getWeatherHourly()
        let calendar = Calendar.current
        let now = Date()
        
        // Buscar el índice donde la fecha sea hoy y la hora coincida con la hora actual
        guard let startIndex = hourly.firstIndex(where: { forecast in
            calendar.isDate(forecast.date, inSameDayAs: now) &&
            calendar.component(.hour, from: forecast.date) ==
            calendar.component(.hour, from: now)
        }) else {
            return []
        }
        
        // Devolver exactamente 24 horas desde ese punto
        let endIndex = min(startIndex + 24, hourly.count)
        return Array(hourly[startIndex..<endIndex])
    }
    
    func getDailyInformation() {
        
    }

    private func bindLocationService() {
        locationService.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }

                self.currentLocation = location
                self.latitude = location?.coordinate.latitude
                self.longitude = location?.coordinate.longitude

                // Cuando ya tenemos ubicación válida, llamamos al API
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
    
    private func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let currentTime = "\(hour):\(minutes)"
        return currentTime
    }
}

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

    // MARK: - Dependencies

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    private let reverseGeocodingService: ReverseGeocodingServiceProtocol


    // MARK: - Initialization

    init(locationService: LocationService? = nil) {
        self.locationService = locationService ?? LocationService()
        weatherService = WeatherService()
        reverseGeocodingService = ReverseGeocodingService()
        bindLocationService()
    }

    // MARK: - Public API

    func requestLocationPermission() {
        locationService.requestPermission()
    }

    func refreshLocation() {
        locationService.requestLocation()
    }
    
    func callWeatherAPI() async {
        guard let latitudeSecure = latitude,
              let longitudeSecure = longitude else { return }
        do {
            let cityName = try await reverseGeocodingService.reverseGeocoding(latitude: latitudeSecure, longitude: longitudeSecure)
            weatherInformation = try await weatherService.fetchWeather(latitude: latitudeSecure, longitude: longitudeSecure)
            weatherInformation?.cityName = cityName
            
        } catch let error {
            print(error)
        }
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
}

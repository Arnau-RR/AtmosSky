//
//  FavouriteListModel.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//


import Foundation
import CoreLocation
import Combine
import SwiftData

@MainActor
final class FavouriteListModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isFavorite = false
    @Published var favorites: [FavoriteCity] = []
    @Published var favoriteCitiesWeather: [FavoriteCityWeather] = []
    
    // MARK: - Dependencies
    
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationService
    private var modelContext: ModelContext?
    
    
    // MARK: - Initialization
    
    init(locationService: LocationService? = nil) {
        self.locationService = locationService ?? LocationService()
        self.weatherService = WeatherService()
    }
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadFavorites() async {
        guard let modelContext else { return }

        do {
            favorites = try modelContext.fetch(
                FetchDescriptor<FavoriteCity>()
            )
        } catch {
            print(error)
        }
    }
    
    func loadWeatherForFavorites() async {

        await withTaskGroup(of: FavoriteCityWeather?.self) { group in

            for favorite in favorites {

                group.addTask { [weatherService] in

                    do {

                        let weather = try await weatherService.fetchWeather(
                            latitude: favorite.latitude,
                            longitude: favorite.longitude
                        )

                        return FavoriteCityWeather(
                            cityName: favorite.cityName,
                            latitude: favorite.latitude,
                            longitude: favorite.longitude,
                            temperature: Int(weather.temperature ?? 0.0),
                            minTemperature: Int(weather.minTemperature ?? 0.0),
                            maxTemperature: Int(weather.maxTemperature ?? 0.0),
                            weatherCode: weather.currentWeatherCode,
                            weatherDescription: weather.currentWeatherDescription
                            
                        )

                    } catch {
                        print("Error cargando \(favorite.cityName)")
                        return nil
                    }
                }
            }

            var result: [FavoriteCityWeather] = []

            for await city in group {
                if let city {
                    result.append(city)
                }
            }

            favoriteCitiesWeather = result
        }
    }
}


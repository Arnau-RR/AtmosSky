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
    @Published var searchResults: [CitySearchResult] = []
    @Published var isSearching = false

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

    // MARK: - Favorites

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

    // MARK: - Search

    func searchCities(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        isSearching = true

        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.geocodeAddressString(query)

            searchResults = placemarks.compactMap { placemark in
                guard let location = placemark.location else { return nil }

                let cityName = placemark.locality
                    ?? placemark.administrativeArea
                    ?? query

                let country = placemark.country ?? ""

                return CitySearchResult(
                    name: cityName,
                    country: country,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
        } catch {
            print("Error buscando ciudades: \(error)")
            searchResults = []
        }

        isSearching = false
    }

    func clearSearch() {
        searchResults = []
        isSearching = false
    }

    func addToFavorites(_ result: CitySearchResult) async {
        guard let modelContext else { return }

        let alreadyExists = favorites.contains {
            abs($0.latitude - result.latitude) < 0.01 &&
            abs($0.longitude - result.longitude) < 0.01
        }

        guard !alreadyExists else { return }

        let newFavorite = FavoriteCity(
            cityName: result.name,
            latitude: result.latitude,
            longitude: result.longitude
        )

        modelContext.insert(newFavorite)

        do {
            try modelContext.save()
        } catch {
            print("Error guardando favorito: \(error)")
        }

        await loadFavorites()
        await loadWeatherForFavorites()
    }
}

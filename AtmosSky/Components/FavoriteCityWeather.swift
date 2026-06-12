//
//  FavoriteCityWeather.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import Foundation

struct FavoriteCityWeather: Identifiable {

    let id = UUID()

    let cityName: String
    let latitude: Double
    let longitude: Double

    let temperature: Int

    let minTemperature: Int
    let maxTemperature: Int

    let weatherCode: Int
    let weatherDescription: String
}

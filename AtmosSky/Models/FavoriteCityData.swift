//
//  FavoriteCity.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//


import SwiftData

@Model
final class FavoriteCity {
    var cityName: String
    var latitude: Double
    var longitude: Double

    init(cityName: String, latitude: Double, longitude: Double) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
    }
}

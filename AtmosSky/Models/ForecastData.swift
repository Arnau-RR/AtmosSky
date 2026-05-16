//
//  ForecastData.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import Foundation

struct DailyForecast {
    let date: Date
    let maxTemperature: Double
    let minTemperature: Double
    let weatherCode: Int
    let sunrise: Date?
    let sunset: Date?
    let daylightHours: Double?
}

struct HourlyForecast {
    let id = UUID()
    let date: Date
    let temperature: Double
    let precipitationProbability: Double
    let weatherCode: Int
}

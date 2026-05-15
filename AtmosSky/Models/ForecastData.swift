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
}

struct HourlyForecast {
    let date: Date
    let temperature: Double
    let precipitationProbability: Double
    let weatherCode: Int
}

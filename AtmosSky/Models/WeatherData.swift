//
//  WeatherData.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import Foundation

struct WeatherData {
    var cityName: String?
    let temperature: Double?
    let maxTemperature: Double?
    let minTemperature: Double?
    let apparentTemperature: Double?
    let humidity: Double?
    let windSpeed: Double?
    let currentWeatherCode: Int
    let currentWeatherDescription: String
    let timeZone: TimeZone
    let localDate: Date
    let isNight: Bool
    let hourly: Hourly?
    let dailyForecast: [DailyForecast]?
    let hourlyForecast: [HourlyForecast]?

    struct Hourly {
        let time: [Date]
        let showers: [Float]
        let snowfall: [Float]
        let snowDepth: [Float]
        let cloudCover: [Float]
        let cloudCoverLow: [Float]
        let cloudCoverMid: [Float]
        let cloudCoverHigh: [Float]
        let visibility: [Float]
        let evapotranspiration: [Float]
        let et0FaoEvapotranspiration: [Float]
        let vapourPressureDeficit: [Float]
        let windSpeed10m: [Float]
        let windSpeed80m: [Float]
        let windSpeed120m: [Float]
        let windSpeed180m: [Float]
        let windDirection10m: [Float]
        let windDirection80m: [Float]
        let temperature80m: [Float]
        let temperature120m: [Float]
        let temperature180m: [Float]
        let windDirection120m: [Float]
        let windDirection180m: [Float]
        let windGusts10m: [Float]
        let soilTemperature0cm: [Float]
        let soilTemperature6cm: [Float]
        let soilTemperature18cm: [Float]
        let soilTemperature54cm: [Float]
        let soilMoisture0To1cm: [Float]
        let soilMoisture1To3cm: [Float]
        let soilMoisture3To9cm: [Float]
        let soilMoisture9To27cm: [Float]
        let soilMoisture27To81cm: [Float]
        let temperature2m: [Float]
    }
}


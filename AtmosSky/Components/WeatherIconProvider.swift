//
//  WeatherIconProvider.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//


import Foundation

enum WeatherIconProvider {

    static func icon(for code: Int, isNight: Bool = false) -> String {
        switch code {

        case 0:
            return isNight ? "moon.stars.fill" : "sun.max.fill"

        case 1:
            return isNight ? "moon.stars.fill" : "sun.max.fill"

        case 2:
            return isNight ? "cloud.moon.fill" : "cloud.sun.fill"

        case 3:
            return "cloud.fill"

        case 45, 48:
            return "cloud.fog.fill"

        case 51, 53, 55:
            return "cloud.drizzle.fill"

        case 61, 63, 65:
            return "cloud.rain.fill"

        case 66, 67:
            return "cloud.sleet.fill"

        case 71, 73, 75, 77:
            return "cloud.snow.fill"

        case 80, 81, 82:
            return "cloud.rain.fill"

        case 85, 86:
            return "cloud.snow.fill"

        case 95, 96, 99:
            return "cloud.bolt.rain.fill"

        default:
            return "questionmark.circle.fill"
        }
    }
}
//
//  SkyCondition.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import Foundation
import SwiftUI

/// Estados atmosféricos utilizados para determinar la apariencia visual del cielo.
enum SkyCondition {
    case clear           // Despejado
    case partlyCloudy    // Parcialmente nublado
    case cloudy          // Muy nublado
    case fog             // Niebla
    case lightRain       // Lluvia débil
    case heavyRain       // Lluvia intensa
    case storm           // Tormenta
    case snow            // Nieve
    case drizzle
    case moderateRain
}

extension SkyCondition {
    
    /// Convierte un código WMO de Open-Meteo en un `SkyCondition`.
    static func from(weatherCode code: Int) -> SkyCondition {
        switch code {
            
        // MARK: - Clear sky
        case 0:
            return .clear
            
        // MARK: - Partly cloudy
        case 1, 2:
            return .partlyCloudy
            
        // MARK: - Cloudy / Overcast
        case 3:
            return .cloudy
            
        // MARK: - Fog
        case 45, 48:
            return .fog
            
        // MARK: - Drizzle / Light rain
        case 51, 53, 55,
             56, 57,      // llovizna helada
             61, 63,
             80, 81:
            return .lightRain
            
        // MARK: - Heavy rain
        case 65,
             66, 67,      // lluvia helada
             82:
            return .heavyRain
            
        // MARK: - Snow
        case 71, 73, 75,
             77,
             85, 86:
            return .snow
            
        // MARK: - Thunderstorm
        case 95, 96, 99:
            return .storm
            
        // MARK: - Default fallback
        default:
            return .cloudy
        }
    }
}

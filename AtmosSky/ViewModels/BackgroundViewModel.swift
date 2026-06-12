//
//  BackgroundViewModel.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class BackgroundViewModel: ObservableObject {
    @Published var currentTime = ""
    @Published var sunsetTime: Date?
    @Published var sunriseTime: Date?
    @Published var solarProgress: Double = 0.0
    @Published var currentWeatherCode: Int?
    
    func update(
        sunsetTime: Date?,
        sunriseTime: Date?,
        currentWeatherCode: Int?
    ) {
        self.currentWeatherCode = currentWeatherCode
        solarProgress = calculateSolarProgress(
            current: Date(),
            sunrise: sunriseTime,
            sunset: sunsetTime
        )
    }
    
    /// Condición atmosférica derivada del código WMO
    private var skyCondition: SkyCondition {
        SkyCondition.from(weatherCode: currentWeatherCode ?? 0)
    }
    
    /// Intensidad de lluvia según la condición actual
    var rainIntensity: RainIntensity {
        switch skyCondition {
        case .lightRain:
            return .light
            
        case .heavyRain:
            return .medium
            
        case .storm:
            return .heavy   // o .heavy si no existe `.torrential`
            
        default:
            return .medium
        }
    }
    
    /// Indica si debe mostrarse lluvia
    var shouldShowRain: Bool {
        switch skyCondition {
        case .lightRain, .heavyRain, .storm:
            return true
        default:
            return false
        }
    }
    
    /// Indica si deben mostrarse relámpagos
    /// - heavyRain: lluvia intensa (tipo tormenta)
    /// - storm: tormenta explícita
    var shouldShowLightning: Bool {
        switch skyCondition {
        case .heavyRain, .storm:
            return true
        default:
            return false
        }
    }
    
    /// Frecuencia de relámpagos según la intensidad
    var lightningFrequency: Double {
        switch skyCondition {
        case .heavyRain:
            return 0.02   // aproximadamente cada 50 segundos
            
        case .storm:
            return 0.08   // aproximadamente cada 12 segundos
            
        default:
            return 0.0
        }
    }
    
    private func calculateSolarProgress(
        current: Date = Date(),
        sunrise: Date?,
        sunset: Date?
    ) -> Double {
        
        guard let sunrise, let sunset else {
            return 0.0
        }
        
        let currentTime = current.timeIntervalSince1970
        let sunriseTime = sunrise.timeIntervalSince1970
        let sunsetTime = sunset.timeIntervalSince1970
        
        let progress = (currentTime - sunriseTime) / (sunsetTime - sunriseTime)
        
        return min(max(progress, 0.0), 1.0)
    }
    
    //    func getCurrentTime() -> String {
    //        let date = Date()
    //        let calendar = Calendar.current
    //        let hour = calendar.component(.hour, from: date)
    //        let minutes = calendar.component(.minute, from: date)
    //        let currentTime = "\(hour):\(minutes)"
    //        return currentTime
    //    }
    
    func solarProgress(current: Date = Date(),
                       sunrise: Date?,
                       sunset: Date?) -> Double {
        
        guard let secureSunrise = sunrise,
              let secureSunset = sunset else { return 0.0}
        
        let currentTime = current.timeIntervalSince1970
        let sunriseTime = secureSunrise.timeIntervalSince1970
        let sunsetTime = secureSunset.timeIntervalSince1970
        
        let progress = (currentTime - sunriseTime) / (sunsetTime - sunriseTime)
        
        // Limitar entre 0 y 1
        return min(max(progress, 0.0), 1.0)
    }
    
//    func sunPosition(progress p: Double) -> CGPoint {
//        let x = p
//        let maxHeight = 0.8
//        
//        let y = -4 * maxHeight * pow(x - 0.5, 2) + maxHeight
//        
//        return CGPoint(x: x, y: y)
//    }
    
//    func sunScreenPosition(
//        progress: Double,
//        size: CGSize
//    ) -> CGPoint {
//        
//        let normalized = sunPosition(progress: progress)
//        
//        let screenX = normalized.x * size.width
//        
//        // En iOS el eje Y crece hacia abajo.
//        let horizonY = size.height * 0.75
//        let arcHeight = size.height * 0.45
//        
//        let screenY = horizonY - normalized.y * arcHeight
//        
//        return CGPoint(x: screenX, y: screenY)
//    }
    
    
//    func isNight(
//        current: Date = Date()
//    ) -> Bool {
//        guard let sunriseSecure = self.sunriseTime,
//              let sunsetSecure = self.sunsetTime else {
//            return false
//        }
//
//        return current < sunriseSecure || current > sunsetSecure
//    }
}

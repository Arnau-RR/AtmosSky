//
//  SkyGradientView.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//


import SwiftUI

struct SkyGradientView: View {
    /// Valor entre 0 y 1 que representa la posición del sol.
    /// 0.0 = amanecer, 0.5 = mediodía, 1.0 = atardecer.
    let solarProgress: Double
    
    /// Indica si es noche astronómica.
    let isNight: Bool
    
    /// Estado meteorológico actual.
    let condition: SkyCondition
    
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Main Gradient Logic
    
//    private var gradientColors: [Color] {
//        switch condition {
//        case .clear:
//            return clearSkyColors
//
//        case .partlyCloudy:
//            return blend(clearSkyColors, with: partlyCloudyOverlay, amount: 0.20)
//
//        case .cloudy:
//            return blend(clearSkyColors, with: cloudyOverlay, amount: 0.55)
//
//        case .fog:
//            return blend(clearSkyColors, with: fogOverlay, amount: 0.78)
//
//        case .drizzle:
//            return blend(clearSkyColors, with: drizzleOverlay, amount: 0.55)
//
//        case .lightRain:
//            return blend(clearSkyColors, with: lightRainOverlay, amount: 0.70)
//
//        case .moderateRain:
//            return blend(clearSkyColors, with: moderateRainOverlay, amount: 0.82)
//
//        case .heavyRain:
//            return blend(clearSkyColors, with: heavyRainOverlay, amount: 0.92)
//
//        case .storm:
//            return stormColors
//
//        case .snow:
//            return blend(clearSkyColors, with: snowOverlay, amount: 0.65)
//        }
//    }
    
    // Sustituye tu implementación actual de `gradientColors` por esta versión.
    // Ahora la noche también responde a la condición meteorológica, igual que durante el día.

    private var gradientColors: [Color] {
        let baseColors = baseSkyColors

        switch condition {
        case .clear:
            return baseColors

        case .partlyCloudy:
            return blend(baseColors, with: partlyCloudyOverlay, amount: isNight ? 0.28 : 0.20)

        case .cloudy:
            return blend(baseColors, with: cloudyOverlay, amount: isNight ? 0.65 : 0.55)

        case .fog:
            return blend(baseColors, with: fogOverlay, amount: isNight ? 0.85 : 0.78)

        case .drizzle:
            return blend(baseColors, with: drizzleOverlay, amount: isNight ? 0.70 : 0.55)

        case .lightRain:
            return blend(baseColors, with: lightRainOverlay, amount: isNight ? 0.82 : 0.70)

        case .moderateRain:
            return blend(baseColors, with: moderateRainOverlay, amount: isNight ? 0.90 : 0.82)

        case .heavyRain:
            return blend(baseColors, with: heavyRainOverlay, amount: isNight ? 0.96 : 0.92)

        case .storm:
            return isNight ? nightStormColors : stormColors

        case .snow:
            return blend(baseColors, with: snowOverlay, amount: isNight ? 0.75 : 0.65)
        }
    }

    // MARK: - Base Sky (clear sky depending on time)

    private var baseSkyColors: [Color] {
        if isNight {
            return nightSkyColors
        }

        switch solarProgress {
        case 0.00..<0.08: // Pre-amanecer
            return [
                Color(red: 0.02, green: 0.03, blue: 0.10),
                Color(red: 0.10, green: 0.06, blue: 0.22),
                Color(red: 0.25, green: 0.10, blue: 0.30),
                Color(red: 0.55, green: 0.22, blue: 0.28)
            ]

        case 0.08..<0.18: // Amanecer
            return [
                Color(red: 0.12, green: 0.18, blue: 0.45),
                Color(red: 0.45, green: 0.22, blue: 0.55),
                Color(red: 0.95, green: 0.45, blue: 0.35),
                Color(red: 1.00, green: 0.78, blue: 0.45)
            ]

        case 0.18..<0.35: // Mañana
            return [
                Color(red: 0.20, green: 0.35, blue: 0.75),
                Color(red: 0.45, green: 0.65, blue: 0.95),
                Color(red: 0.78, green: 0.90, blue: 1.00),
                Color(red: 0.95, green: 0.98, blue: 1.00)
            ]

        case 0.35..<0.65: // Mediodía
            return [
                Color(red: 0.10, green: 0.45, blue: 0.95),
                Color(red: 0.35, green: 0.65, blue: 1.00),
                Color(red: 0.65, green: 0.85, blue: 1.00),
                Color(red: 0.92, green: 0.98, blue: 1.00)
            ]

        case 0.65..<0.80: // Tarde
            return [
                Color(red: 0.18, green: 0.42, blue: 0.88),
                Color(red: 0.42, green: 0.62, blue: 0.98),
                Color(red: 0.95, green: 0.82, blue: 0.55),
                Color(red: 1.00, green: 0.92, blue: 0.72)
            ]

        case 0.80..<0.92: // Atardecer
            return [
                Color(red: 0.10, green: 0.12, blue: 0.40),
                Color(red: 0.45, green: 0.12, blue: 0.55),
                Color(red: 0.95, green: 0.35, blue: 0.28),
                Color(red: 1.00, green: 0.68, blue: 0.22)
            ]

        default: // Crepúsculo
            return [
                Color(red: 0.03, green: 0.05, blue: 0.18),
                Color(red: 0.15, green: 0.08, blue: 0.30),
                Color(red: 0.35, green: 0.12, blue: 0.32),
                Color(red: 0.60, green: 0.25, blue: 0.28)
            ]
        }
    }

    // MARK: - Night Variations

    private var nightSkyColors: [Color] {
        switch solarProgress {
        case 0.80..<0.92:
            // Poco después del atardecer (22:00 aprox. en verano)
            return [
                Color(red: 0.02, green: 0.03, blue: 0.10),
                Color(red: 0.06, green: 0.05, blue: 0.18),
                Color(red: 0.18, green: 0.08, blue: 0.28),
                Color(red: 0.35, green: 0.14, blue: 0.24)
            ]

        case 0.92..<1.00:
            // Crepúsculo nocturno
            return [
                Color(red: 0.01, green: 0.02, blue: 0.08),
                Color(red: 0.03, green: 0.04, blue: 0.14),
                Color(red: 0.08, green: 0.06, blue: 0.20),
                Color(red: 0.18, green: 0.08, blue: 0.22)
            ]

        case 0.00..<0.08:
            // Antes del amanecer
            return [
                Color(red: 0.01, green: 0.02, blue: 0.08),
                Color(red: 0.05, green: 0.04, blue: 0.16),
                Color(red: 0.15, green: 0.06, blue: 0.22),
                Color(red: 0.30, green: 0.10, blue: 0.20)
            ]

        default:
            // Medianoche profunda
            return [
                Color(red: 0.005, green: 0.01, blue: 0.04),
                Color(red: 0.015, green: 0.03, blue: 0.08),
                Color(red: 0.04, green: 0.07, blue: 0.14),
                Color(red: 0.08, green: 0.10, blue: 0.18)
            ]
        }
    }

    // MARK: - Night Storm

    private var nightStormColors: [Color] {
        [
            Color(red: 0.00, green: 0.00, blue: 0.02),
            Color(red: 0.01, green: 0.02, blue: 0.05),
            Color(red: 0.03, green: 0.04, blue: 0.08),
            Color(red: 0.06, green: 0.07, blue: 0.12)
        ]
    }
    
    // MARK: - Clear Sky (depends on time of day)
    
    private var partlyCloudyOverlay: [Color] {
        [
            // Nubes suaves con bastante luminosidad.
            // Mantiene el azul del cielo, pero añade un velo gris-azulado.
            Color(red: 0.72, green: 0.76, blue: 0.82),
            Color(red: 0.80, green: 0.84, blue: 0.88),
            Color(red: 0.88, green: 0.91, blue: 0.94),
            Color(red: 0.96, green: 0.97, blue: 0.99)
        ]
    }
    
    private var drizzleOverlay: [Color] {
        [
            // Llovizna: cielo gris azulado, húmedo pero todavía relativamente luminoso
            Color(red: 0.22, green: 0.28, blue: 0.38),
            Color(red: 0.35, green: 0.42, blue: 0.52),
            Color(red: 0.48, green: 0.56, blue: 0.66),
            Color(red: 0.62, green: 0.68, blue: 0.76)
        ]
    }

    private var lightRainOverlay: [Color] {
        [
            // Lluvia débil: cielo claramente más oscuro y frío
            Color(red: 0.06, green: 0.10, blue: 0.18),
            Color(red: 0.12, green: 0.18, blue: 0.28),
            Color(red: 0.22, green: 0.30, blue: 0.42),
            Color(red: 0.34, green: 0.42, blue: 0.54)
        ]
    }

    private var moderateRainOverlay: [Color] {
        [
            // Lluvia moderada: ambiente húmedo, denso y con poca luz
            Color(red: 0.03, green: 0.06, blue: 0.12),
            Color(red: 0.08, green: 0.12, blue: 0.20),
            Color(red: 0.16, green: 0.22, blue: 0.32),
            Color(red: 0.26, green: 0.32, blue: 0.42)
        ]
    }

    private var heavyRainOverlay: [Color] {
        [
            // Lluvia intensa: tonos muy oscuros y dramáticos
            Color(red: 0.01, green: 0.03, blue: 0.08),
            Color(red: 0.04, green: 0.07, blue: 0.12),
            Color(red: 0.10, green: 0.14, blue: 0.22),
            Color(red: 0.18, green: 0.22, blue: 0.30)
        ]
    }
    
    private var clearSkyColors: [Color] {
        if isNight {
            return [
                Color(red: 0.01, green: 0.02, blue: 0.08),
                Color(red: 0.03, green: 0.06, blue: 0.18),
                Color(red: 0.08, green: 0.12, blue: 0.28),
                Color(red: 0.15, green: 0.18, blue: 0.35)
            ]
        }
        
        switch solarProgress {
        case 0.00..<0.08: // Pre-amanecer
            return [
                Color(red: 0.02, green: 0.03, blue: 0.10),
                Color(red: 0.10, green: 0.06, blue: 0.22),
                Color(red: 0.25, green: 0.10, blue: 0.30),
                Color(red: 0.55, green: 0.22, blue: 0.28)
            ]
            
        case 0.08..<0.18: // Amanecer
            return [
                Color(red: 0.12, green: 0.18, blue: 0.45),
                Color(red: 0.45, green: 0.22, blue: 0.55),
                Color(red: 0.95, green: 0.45, blue: 0.35),
                Color(red: 1.00, green: 0.78, blue: 0.45)
            ]
            
        case 0.18..<0.35: // Mañana
            return [
                Color(red: 0.20, green: 0.35, blue: 0.75),
                Color(red: 0.45, green: 0.65, blue: 0.95),
                Color(red: 0.78, green: 0.90, blue: 1.00),
                Color(red: 0.95, green: 0.98, blue: 1.00)
            ]
            
        case 0.35..<0.65: // Mediodía
            return [
                Color(red: 0.10, green: 0.45, blue: 0.95),
                Color(red: 0.35, green: 0.65, blue: 1.00),
                Color(red: 0.65, green: 0.85, blue: 1.00),
                Color(red: 0.92, green: 0.98, blue: 1.00)
            ]
            
        case 0.65..<0.80: // Tarde
            return [
                Color(red: 0.18, green: 0.42, blue: 0.88),
                Color(red: 0.42, green: 0.62, blue: 0.98),
                Color(red: 0.95, green: 0.82, blue: 0.55),
                Color(red: 1.00, green: 0.92, blue: 0.72)
            ]
            
        case 0.80..<0.92: // Atardecer
            return [
                Color(red: 0.10, green: 0.12, blue: 0.40),
                Color(red: 0.45, green: 0.12, blue: 0.55),
                Color(red: 0.95, green: 0.35, blue: 0.28),
                Color(red: 1.00, green: 0.68, blue: 0.22)
            ]
            
        default: // Crepúsculo
            return [
                Color(red: 0.03, green: 0.05, blue: 0.18),
                Color(red: 0.15, green: 0.08, blue: 0.30),
                Color(red: 0.35, green: 0.12, blue: 0.32),
                Color(red: 0.60, green: 0.25, blue: 0.28)
            ]
        }
    }
    
    // MARK: - Atmospheric Overlays
    
    private var cloudyOverlay: [Color] {
        [
            Color(red: 0.30, green: 0.35, blue: 0.42),
            Color(red: 0.48, green: 0.52, blue: 0.58),
            Color(red: 0.65, green: 0.68, blue: 0.72),
            Color(red: 0.78, green: 0.80, blue: 0.82)
        ]
    }
    
    private var fogOverlay: [Color] {
        [
            Color(red: 0.60, green: 0.62, blue: 0.66),
            Color(red: 0.72, green: 0.74, blue: 0.76),
            Color(red: 0.84, green: 0.85, blue: 0.86),
            Color(red: 0.94, green: 0.95, blue: 0.96)
        ]
    }
    
    private var rainOverlay: [Color] {
        [
            Color(red: 0.08, green: 0.12, blue: 0.22),
            Color(red: 0.16, green: 0.22, blue: 0.34),
            Color(red: 0.28, green: 0.34, blue: 0.45),
            Color(red: 0.42, green: 0.48, blue: 0.58)
        ]
    }
    
    private var snowOverlay: [Color] {
        [
            Color(red: 0.72, green: 0.78, blue: 0.86),
            Color(red: 0.82, green: 0.87, blue: 0.93),
            Color(red: 0.90, green: 0.94, blue: 0.98),
            Color(red: 0.98, green: 0.99, blue: 1.00)
        ]
    }
    
    private var stormColors: [Color] {
        [
            Color(red: 0.01, green: 0.02, blue: 0.06),
            Color(red: 0.05, green: 0.07, blue: 0.12),
            Color(red: 0.12, green: 0.14, blue: 0.20),
            Color(red: 0.22, green: 0.24, blue: 0.30)
        ]
    }
    
    // MARK: - Color Blending
    
    private func blend(
        _ base: [Color],
        with overlay: [Color],
        amount: Double
    ) -> [Color] {
        zip(base, overlay).map { baseColor, overlayColor in
            baseColor.interpolate(to: overlayColor, fraction: amount)
        }
    }
}

// MARK: - Color Interpolation Helper

private extension Color {
    func interpolate(to color: Color, fraction: Double) -> Color {
        #if canImport(UIKit)
        let from = UIColor(self)
        let to = UIColor(color)
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return Color(
            red: Double(r1 + (r2 - r1) * fraction),
            green: Double(g1 + (g2 - g1) * fraction),
            blue: Double(b1 + (b2 - b1) * fraction),
            opacity: Double(a1 + (a2 - a1) * fraction)
        )
        #else
        return self
        #endif
    }
}

////
////  SkyGradientView.swift
////  AtmosSky
////
////  Created by Arnau on 15/05/2026.
////
//
//import SwiftUI
//
//struct SkyGradientView: View {
//    /// Valor entre 0 y 1 que representa la posición del sol en el cielo.
//    /// 0.0 = salida del sol, 0.5 = mediodía, 1.0 = puesta del sol.
//    let solarProgress: Double
//    
//    /// Indica si es noche astronómica.
//    let isNight: Bool
//    
//    var body: some View {
//        LinearGradient(
//            colors: gradientColors,
//            startPoint: .top,
//            endPoint: .bottom
//        )
//        .ignoresSafeArea()
//    }
//    
//    // MARK: - Gradientes
//    
//    private var gradientColors: [Color] {
//        if isNight {
//            return nightGradient
//        }
//        
//        switch solarProgress {
//        case 0.00..<0.08:
//            // Amanecer profundo (antes de salir el sol)
//            return preDawnGradient
//            
//        case 0.08..<0.18:
//            // Amanecer dorado
//            return sunriseGradient
//            
//        case 0.18..<0.35:
//            // Mañana temprana
//            return earlyMorningGradient
//            
//        case 0.35..<0.65:
//            // Mediodía / cielo intenso
//            return middayGradient
//            
//        case 0.65..<0.80:
//            // Tarde cálida
//            return afternoonGradient
//            
//        case 0.80..<0.92:
//            // Atardecer vibrante
//            return sunsetGradient
//            
//        case 0.92..<1.00:
//            // Crepúsculo
//            return twilightGradient
//            
//        default:
//            return middayGradient
//        }
//    }
//    
//    // MARK: - Night
//    
//    private var nightGradient: [Color] {
//        [
//            Color(red: 0.01, green: 0.02, blue: 0.08), // azul casi negro
//            Color(red: 0.03, green: 0.06, blue: 0.18), // azul profundo
//            Color(red: 0.08, green: 0.12, blue: 0.28), // azul nocturno
//            Color(red: 0.15, green: 0.18, blue: 0.35)  // horizonte tenue
//        ]
//    }
//    
//    // MARK: - Pre Dawn
//    
//    private var preDawnGradient: [Color] {
//        [
//            Color(red: 0.02, green: 0.03, blue: 0.10),
//            Color(red: 0.10, green: 0.06, blue: 0.22),
//            Color(red: 0.25, green: 0.10, blue: 0.30),
//            Color(red: 0.55, green: 0.22, blue: 0.28)
//        ]
//    }
//    
//    // MARK: - Sunrise
//    
//    private var sunriseGradient: [Color] {
//        [
//            Color(red: 0.12, green: 0.18, blue: 0.45), // azul profundo
//            Color(red: 0.45, green: 0.22, blue: 0.55), // violeta
//            Color(red: 0.95, green: 0.45, blue: 0.35), // coral
//            Color(red: 1.00, green: 0.78, blue: 0.45)  // dorado
//        ]
//    }
//    
//    // MARK: - Early Morning
//    
//    private var earlyMorningGradient: [Color] {
//        [
//            Color(red: 0.20, green: 0.35, blue: 0.75),
//            Color(red: 0.45, green: 0.65, blue: 0.95),
//            Color(red: 0.78, green: 0.90, blue: 1.00),
//            Color(red: 0.95, green: 0.98, blue: 1.00)
//        ]
//    }
//    
//    // MARK: - Midday
//    
//    private var middayGradient: [Color] {
//        [
//            Color(red: 0.10, green: 0.45, blue: 0.95), // azul intenso
//            Color(red: 0.35, green: 0.65, blue: 1.00), // azul brillante
//            Color(red: 0.65, green: 0.85, blue: 1.00), // azul claro
//            Color(red: 0.92, green: 0.98, blue: 1.00)  // casi blanco
//        ]
//    }
//    
//    // MARK: - Afternoon
//    
//    private var afternoonGradient: [Color] {
//        [
//            Color(red: 0.18, green: 0.42, blue: 0.88),
//            Color(red: 0.42, green: 0.62, blue: 0.98),
//            Color(red: 0.95, green: 0.82, blue: 0.55),
//            Color(red: 1.00, green: 0.92, blue: 0.72)
//        ]
//    }
//    
//    // MARK: - Sunset
//    
//    private var sunsetGradient: [Color] {
//        [
//            Color(red: 0.10, green: 0.12, blue: 0.40), // azul profundo
//            Color(red: 0.45, green: 0.12, blue: 0.55), // púrpura
//            Color(red: 0.95, green: 0.35, blue: 0.28), // rojo anaranjado
//            Color(red: 1.00, green: 0.68, blue: 0.22)  // naranja dorado
//        ]
//    }
//    
//    // MARK: - Twilight
//    
//    private var twilightGradient: [Color] {
//        [
//            Color(red: 0.03, green: 0.05, blue: 0.18),
//            Color(red: 0.15, green: 0.08, blue: 0.30),
//            Color(red: 0.35, green: 0.12, blue: 0.32),
//            Color(red: 0.60, green: 0.25, blue: 0.28)
//        ]
//    }
//}
//
////struct SkyGradientView: View {
////    let solarProgress: Double
////    let isNight: Bool
////    
////    var body: some View {
////        LinearGradient(
////            colors: gradientColors,
////            startPoint: .top,
////            endPoint: .bottom
////        )
////        .ignoresSafeArea()
////    }
////    
////    private var gradientColors: [Color] {
////        if isNight {
////            return [
////                Color(red: 0.02, green: 0.05, blue: 0.20),
////                Color(red: 0.10, green: 0.15, blue: 0.35)
////            ]
////        }
////        
////        switch solarProgress {
////        case 0.0..<0.15:
////            // Amanecer
////            return [
////                Color.orange,
////                Color.pink
////            ]
////            
////        case 0.15..<0.75:
////            // Día
////            return [
////                Color(red: 0.20, green: 0.55, blue: 1.00),
////                Color(red: 0.65, green: 0.85, blue: 1.00)
////            ]
////            
////        case 0.75..<1.0:
////            // Atardecer
////            return [
////                Color.purple,
////                Color.orange
////            ]
////            
////        default:
////            return [
////                Color.blue,
////                Color.cyan
////            ]
////        }
////    }
////}

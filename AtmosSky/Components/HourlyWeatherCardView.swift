//
//  HourlyWeatherCardView.swift
//  AtmosSky
//
//  Created by Arnau on 16/05/2026.
//

import SwiftUI

// MARK: - Componente Reutilizable
struct HourlyWeatherCardView: View {
    let icon: String?
    let value: String
    let subtitle: String?
    let weatherCode: Int?
    let time: String?
    let isNight: Bool
    
    init(icon: String? = nil, value: String, subtitle: String? = nil, weatherCode: Int? = nil, time: String? = nil, isNight: Bool) {
        self.icon = icon
        self.value = value
        self.subtitle = subtitle
        self.weatherCode = weatherCode
        self.time = time
        self.isNight = isNight
    }
    
    // MARK: - Mapeo de Weather Code a SF Symbols
    
//    private func weatherIcon(for code: Int) -> String {
//        switch code {
//
//        // Cielo despejado
//        case 0:
//            return isNight ? "moon.stars.fill" : "sun.max.fill"
//
//        // Mayormente despejado
//        case 1:
//            return isNight ? "moon.stars.fill" : "sun.max.fill"
//
//        // Parcialmente nublado
//        case 2:
//            return isNight ? "cloud.moon.fill" : "cloud.sun.fill"
//
//        // Nublado
//        case 3:
//            return "cloud.fill"
//
//        // Niebla
//        case 45, 48:
//            return "cloud.fog.fill"
//
//        // Llovizna
//        case 51, 53, 55:
//            return "cloud.drizzle.fill"
//
//        // Lluvia
//        case 61, 63, 65:
//            return "cloud.rain.fill"
//
//        // Lluvia helada
//        case 66, 67:
//            return "cloud.sleet.fill"
//
//        // Nieve
//        case 71, 73, 75, 77:
//            return "cloud.snow.fill"
//
//        // Chubascos
//        case 80, 81, 82:
//            return "cloud.rain.fill"
//
//        // Nevadas
//        case 85, 86:
//            return "cloud.snow.fill"
//
//        // Tormenta
//        case 95, 96, 99:
//            return "cloud.bolt.rain.fill"
//
//        default:
//            return "questionmark.circle.fill"
//        }
//    }
//    private func weatherIcon(for code: Int) -> String {
//        switch code {
//        // Cielo despejado
//        case 0:
//            return "sun.max.fill"
//        // Mayormente despejado
//        case 1:
//            return "sun.max.fill"
//        // Parcialmente nublado
//        case 2:
//            return "cloud.sun.fill"
//        // Nublado
//        case 3:
//            return "cloud.fill"
//        // Niebla
//        case 45, 48:
//            return "cloud.fog.fill"
//        // Llovizna
//        case 51, 53, 55:
//            return "cloud.drizzle.fill"
//        // Lluvia
//        case 61, 63, 65:
//            return "cloud.rain.fill"
//        // Lluvia helada
//        case 66, 67:
//            return "cloud.sleet.fill"
//        // Nieve
//        case 71, 73, 75, 77:
//            return "cloud.snow.fill"
//        // Chubascos
//        case 80, 81, 82:
//            return "cloud.rain.fill"
//        // Nevadas
//        case 85, 86:
//            return "cloud.snow.fill"
//        // Tormenta
//        case 95, 96, 99:
//            return "cloud.bolt.rain.fill"
//        default:
//            return "questionmark.circle.fill"
//        }
//    }
    
    private func weatherDescription(for code: Int) -> String {
        switch code {
        case 0:
            return "Cielo despejado"
        case 1:
            return "Mayormente despejado"
        case 2:
            return "Parcialmente nublado"
        case 3:
            return "Nublado"
        case 45, 48:
            return "Niebla"
        case 51:
            return "Llovizna débil"
        case 53:
            return "Llovizna moderada"
        case 55:
            return "Llovizna intensa"
        case 61:
            return "Lluvia débil"
        case 63:
            return "Lluvia moderada"
        case 65:
            return "Lluvia fuerte"
        case 66, 67:
            return "Lluvia helada"
        case 71:
            return "Nieve débil"
        case 73:
            return "Nieve moderada"
        case 75:
            return "Nieve intensa"
        case 77:
            return "Granos de nieve"
        case 80:
            return "Chubascos débiles"
        case 81:
            return "Chubascos moderados"
        case 82:
            return "Chubascos violentos"
        case 85:
            return "Nevadas débiles"
        case 86:
            return "Nevadas intensas"
        case 95:
            return "Tormenta"
        case 96:
            return "Tormenta con granizo débil"
        case 99:
            return "Tormenta con granizo fuerte"
        default:
            return "Condición desconocida"
        }
    }
    
    // MARK: - Obtener el icono a mostrar
    
    private var displayIcon: String {
        if let weatherCode = weatherCode {
            return WeatherIconProvider.icon(for: weatherCode)
        } else if let icon = icon {
            return icon
        }
        return "questionmark.circle.fill"
    }
    
    // MARK: - Obtener el título a mostrar
    
//    private var displayTitle: String {
//        if let weatherCode = weatherCode {
//            return weatherDescription(for: weatherCode)
//        }
//        return title
//    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Hora (opcional)
            if let time = time {
                Text(time)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Icono
            Image(systemName: displayIcon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
                .frame(height: 30)
            
            // Descripción del clima (si hay weatherCode)
//            if weatherCode != nil {
//                Text(displayTitle)
//                    .font(.system(size: 11, weight: .light))
//                    .foregroundColor(.white.opacity(0.7))
//                    .lineLimit(2)
//                    .multilineTextAlignment(.center)
//            } else {
//                // Título (si no hay weatherCode)
//                Text(title)
//                    .font(.system(size: 12, weight: .light))
//                    .foregroundColor(.white)
//            }
            
            // Valor (temperatura)
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            
            // Subtítulo (opcional)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Vista previa

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            // Ejemplo con weatherCode (lluvia)
            HourlyWeatherCardView(
                value: "15°C",
                weatherCode: 63,
                time: "14:00",
                isNight: false
            )
            
            // Ejemplo con weatherCode (nublado)
            HourlyWeatherCardView(
                value: "18°C",
                weatherCode: 3,
                time: "15:00",
                isNight: false
            )
            
            // Ejemplo con weatherCode (tormenta)
            HourlyWeatherCardView(
                value: "12°C",
                weatherCode: 95,
                time: "16:00",
                isNight: false
            )
        }
        
    }
    .padding()
    .background(Color.black)
}

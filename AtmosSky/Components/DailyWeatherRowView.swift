//
//  DailyWeatherRowView.swift
//  AtmosSky
//
//  Created by Arnau on 17/05/2026.
//


//  Fila diaria con:
//  - Día de la semana
//  - Icono del tiempo
//  - Temperatura mínima
//  - Barra horizontal con degradado azul → rojo
//  - Temperatura máxima
//
//  El degradado SIEMPRE empieza en azul y termina en rojo.
//  La barra se rellena según la posición relativa del día dentro
//  del rango semanal (mínima global -> máxima global).
//

import SwiftUI

struct DailyWeatherRowView: View {
    let day: String
    let weatherCode: Int
    let minTemp: Double
    let maxTemp: Double

    /// Rango global de toda la semana
    let weekMin: Double
    let weekMax: Double

    // MARK: - Icono según código meteorológico
    private func weatherIcon(for code: Int) -> String {
        switch code {
        case 0:
            return "sun.max.fill"
        case 1:
            return "sun.max.fill"
        case 2:
            return "cloud.sun.fill"
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

    // MARK: - Posición relativa dentro del rango semanal
    private var startFraction: CGFloat {
        guard weekMax > weekMin else { return 0 }
        return CGFloat((minTemp - weekMin) / (weekMax - weekMin))
    }

    private var endFraction: CGFloat {
        guard weekMax > weekMin else { return 1 }
        return CGFloat((maxTemp - weekMin) / (weekMax - weekMin))
    }

    var body: some View {
        HStack(spacing: 12) {

            // Día
            Text(day)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 90, alignment: .leading)

            // Icono
            Image(systemName: weatherIcon(for: weatherCode))
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 24)

            // Temperatura mínima
            Text("\(Int(round(minTemp)))°")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.65))
                .frame(width: 32, alignment: .trailing)

            // Barra de temperaturas
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let startX = totalWidth * startFraction
                let barWidth = max(4, totalWidth * (endFraction - startFraction))

                ZStack(alignment: .leading) {
                    // Fondo
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 6)

                    // Relleno con degradado azul -> rojo
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue,
                                    Color.cyan,
                                    Color.green,
                                    Color.yellow,
                                    Color.orange,
                                    Color.red
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: barWidth, height: 6)
                        .offset(x: startX)
                }
            }
            .frame(height: 6)

            // Temperatura máxima
            Text("\(Int(round(maxTemp)))°")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, alignment: .leading)
        }
        .frame(height: 32)
    }
}

// MARK: - Preview
#Preview {
    let data: [(String, Int, Double, Double)] = [
        ("Hoy", 3, 19, 27),
        ("Mañana", 0, 18, 26),
        ("Miércoles", 3, 17, 24),
        ("Jueves", 2, 16, 23),
        ("Viernes", 63, 16, 22),
        ("Sábado", 2, 17, 24),
        ("Domingo", 0, 18, 25)
    ]

    let weekMin = data.map { $0.2 }.min() ?? 0
    let weekMax = data.map { $0.3 }.max() ?? 1

    VStack(spacing: 14) {
        ForEach(data, id: \.0) { item in
            DailyWeatherRowView(
                day: item.0,
                weatherCode: item.1,
                minTemp: item.2,
                maxTemp: item.3,
                weekMin: weekMin,
                weekMax: weekMax
            )
        }
    }
    .padding()
    .background(
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.15, blue: 0.35),
                Color(red: 0.03, green: 0.08, blue: 0.20)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}

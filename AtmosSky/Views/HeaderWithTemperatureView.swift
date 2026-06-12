//
//  HeaderWithTemperatureView.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

struct HeaderWithTemperatureView: View {
    let city: String
    let temperature: Int
    let currentDate: Date
    let sunrise: Date
    let sunset: Date
    let weatherDescription: String
    let maxTemperature: Int
    let minTemperature: Int
    
    var body: some View {
        VStack(spacing: 12) {
            
            ZStack {
                // Contenido centrado dentro del semicírculo
                
                Text("\(temperature)°")
                    .font(.system(size: 100, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .offset(y: 32)
                    .offset(x: 5)

                
                // Arco solar por encima o por debajo según prefieras
                SunMoonArcView(
                    currentDate: currentDate,
                    sunrise: sunrise,
                    sunset: sunset
                )
            }
            .frame(width: 320, height: 180)
            
            Text(weatherDescription)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .tracking(0.5)
                .offset(y: -5)
            
            HStack {
                    Text("Máx.")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(0.5)
                    
                    Text("\(maxTemperature)°")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(0.5)
                
                
                    Text("Min.")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(0.5)
                    
                    Text("\(minTemperature)°")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(0.5)
                
                
            }
            .offset(y: -5)
        }
    }
}

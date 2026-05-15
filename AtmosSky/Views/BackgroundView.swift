//
//  BackgroundView.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI
import SwiftData

@MainActor
struct BackgroundView: View {
    let sunsetTime: Date?
    let sunriseTime: Date?
    let currentWeatherCode: Int?
    let isNight: Bool?
    
    @StateObject private var viewModel = BackgroundViewModel()
    
    var body: some View {
        ZStack {
            SkyGradientView(solarProgress: viewModel.solarProgress, isNight: isNight ?? false, condition: SkyCondition.from(weatherCode: currentWeatherCode ?? 0))
                .ignoresSafeArea()
            
            // Lluvia (solo si corresponde)
            if viewModel.shouldShowRain {
                RainView(intensity: viewModel.rainIntensity)
                    .ignoresSafeArea()
            }
            
            // Relámpagos (lluvia fuerte o tormenta)
            if viewModel.shouldShowLightning {
                LightningView(
                    flashesPerSecond: viewModel.lightningFrequency,
                    maxOpacity: 1.0
                )
                .ignoresSafeArea()
            }
            
            StarsView(isNight: isNight ?? false)
            
            
        }
        .animation(.easeInOut(duration: 2), value: isNight)
        .animation(.easeInOut(duration: 2), value: viewModel.solarProgress)
        .ignoresSafeArea()
        
        .onAppear {
            updateViewModel()
        }
        .onChange(of: sunsetTime) { _, _ in
            updateViewModel()
        }
        .onChange(of: sunriseTime) { _, _ in
            updateViewModel()
        }
    }
    
    private func updateViewModel() {
        viewModel.update(
            sunsetTime: sunsetTime,
            sunriseTime: sunriseTime,
            currentWeatherCode: currentWeatherCode
        )
    }
}

#Preview {
    BackgroundView(sunsetTime: nil, sunriseTime: nil, currentWeatherCode: 0, isNight: false)
}

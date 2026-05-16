//
//  WeatherInfoCard.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

// MARK: - Componente Reutilizable
struct WeatherInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    
    init(icon: String, title: String, value: String, subtitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // Icono
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .frame(height: 25)
            
            // Título
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
            
            // Valor
            Text(value)
                .font(.system(size: 17, weight: .semibold))
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

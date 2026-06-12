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
    let iconColor: Color
    
    init(icon: String, title: String, value: String, subtitle: String? = nil, iconColor: Color = .white) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.iconColor = iconColor
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Icono
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(iconColor.opacity(0.7))
                .frame(height: 30)
            
            // Título
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
            
            // Valor
            Text(value)
                .font(.system(size: 18, weight: .semibold))
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

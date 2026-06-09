//
//  FavouriteListCell.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import SwiftUI

struct FavouriteListCell: View {

    let cityName: String
    let cityGlobal: String
    let weatherCode: Int
    let temperatureDegree: String
    let maxTemperature: String
    let minTemperature: String

    let onTap: (() -> Void)?

    @State private var isPressed = false

    init(
        cityName: String,
        cityGlobal: String,
        weatherCode: Int,
        temperatureDegree: String,
        maxTemperature: String,
        minTemperature: String,
        onTap: (() -> Void)? = nil
    ) {
        self.cityName = cityName
        self.cityGlobal = cityGlobal
        self.weatherCode = weatherCode
        self.temperatureDegree = temperatureDegree
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.onTap = onTap
    }

    var body: some View {

        Button {
            onTap?()
        } label: {

            GlassCardComponent {

                HStack(spacing: 16) {

                    leftContent

                    Spacer()

                    rightContent
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .scaleEffect(isPressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(duration: 0.15)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(duration: 0.2)) {
                        isPressed = false
                    }
                }
        )
    }
}

// MARK: - Sections

private extension FavouriteListCell {

    var leftContent: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(cityName)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(cityGlobal.capitalized)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
        }
    }

    var rightContent: some View {

        VStack(alignment: .trailing, spacing: 8) {

            Image(systemName: WeatherIconProvider.icon(for: weatherCode))
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .frame(height: 30)

            Text(temperatureDegree)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            HStack(spacing: 8) {

                temperatureChip(
                    icon: "arrow.up",
                    value: maxTemperature
                )

                temperatureChip(
                    icon: "arrow.down",
                    value: minTemperature
                )
            }
        }
    }

    func temperatureChip(
        icon: String,
        value: String
    ) -> some View {

        HStack(spacing: 4) {

            Image(systemName: icon)
                .font(.caption2)

            Text(value)
                .font(.caption.bold())
        }
        .foregroundStyle(.white.opacity(0.9))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.white.opacity(0.12))
        .clipShape(Capsule())
    }
}

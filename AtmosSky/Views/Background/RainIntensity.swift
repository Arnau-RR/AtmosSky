//
//  RainView.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

/// Intensidad de la lluvia.
enum RainIntensity {
    case light
    case medium
    case heavy

    var dropCount: Int {
        switch self {
        case .light:  return 80
        case .medium: return 180
        case .heavy:  return 350
        }
    }

    var durationRange: ClosedRange<Double> {
        switch self {
        case .light:  return 1.4...2.2
        case .medium: return 0.8...1.5
        case .heavy:  return 0.4...0.9
        }
    }

    var lengthRange: ClosedRange<CGFloat> {
        switch self {
        case .light:  return 10...18
        case .medium: return 16...28
        case .heavy:  return 24...40
        }
    }

    var opacityRange: ClosedRange<Double> {
        switch self {
        case .light:  return 0.20...0.45
        case .medium: return 0.30...0.65
        case .heavy:  return 0.45...0.85
        }
    }

    /// Desplazamiento horizontal fijo (viento).
    /// Si quieres lluvia completamente vertical, usa 0.
    var horizontalDrift: CGFloat {
        switch self {
        case .light:  return 2
        case .medium: return 4
        case .heavy:  return 6
        }
    }

    var lineWidthRange: ClosedRange<CGFloat> {
        switch self {
        case .light:  return 0.25...0.55
        case .medium: return 0.35...0.75
        case .heavy:  return 0.45...0.95
        }
    }
}

struct RainView: View {
    let intensity: RainIntensity

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate

                    for index in 0..<intensity.dropCount {
                        let seed = Double(index) * 97.13

                        // Posición horizontal fija para cada gota
                        let x = pseudoRandom(seed + 1) * size.width

                        // Propiedades deterministas
                        let duration = interpolate(
                            pseudoRandom(seed + 2),
                            in: intensity.durationRange
                        )

                        let length = interpolate(
                            pseudoRandom(seed + 3),
                            in: intensity.lengthRange
                        )

                        let opacity = interpolate(
                            pseudoRandom(seed + 4),
                            in: intensity.opacityRange
                        )

                        let lineWidth = interpolate(
                            pseudoRandom(seed + 5),
                            in: intensity.lineWidthRange
                        )

                        // Fase independiente por gota
                        let phase = (time / duration + pseudoRandom(seed + 6))
                            .truncatingRemainder(dividingBy: 1.0)

                        // Movimiento vertical puro
                        let y = CGFloat(phase) * (size.height + length) - length

                        // Path completamente recto
                        var path = Path()
                        path.move(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x, y: y + length))

                        // Gradiente de transparencia
                        let gradient = Gradient(colors: [
                            Color.white.opacity(0.0),
                            Color.white.opacity(opacity * 0.35),
                            Color.white.opacity(opacity)
                        ])

                        context.stroke(
                            path,
                            with: .linearGradient(
                                gradient,
                                startPoint: CGPoint(x: x, y: y),
                                endPoint: CGPoint(x: x, y: y + length)
                            ),
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round
                            )
                        )
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

// MARK: - Helpers

private func pseudoRandom(_ value: Double) -> CGFloat {
    let x = sin(value * 12_989.8) * 43_758.5453
    return CGFloat(x - floor(x))
}

private func interpolate(
    _ t: CGFloat,
    in range: ClosedRange<CGFloat>
) -> CGFloat {
    range.lowerBound + (range.upperBound - range.lowerBound) * t
}

private func interpolate(
    _ t: CGFloat,
    in range: ClosedRange<Double>
) -> Double {
    range.lowerBound + (range.upperBound - range.lowerBound) * Double(t)
}

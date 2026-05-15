//
// LightningView.swift
// AtmosSky
//
// Relámpagos visibles con una forma de rayo + destello global.
//

import SwiftUI

struct LightningView: View {
    /// Probabilidad media de relámpago por segundo.
    /// 0.03 ≈ un relámpago cada ~30 s.
    var flashesPerSecond: Double = 0.03

    /// Intensidad máxima del destello.
    var maxOpacity: Double = 1.0

    @State private var flashOpacity: Double = 0.0
    @State private var boltOpacity: Double = 0.0
    @State private var boltPath = Path()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Destello general del cielo
                Color.white
                    .opacity(flashOpacity)
                    .blendMode(.screen)
                    .ignoresSafeArea()

                // Trazo del rayo
                boltPath
                    .stroke(
                        Color.white,
                        style: StrokeStyle(
                            lineWidth: 3,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .shadow(color: .white.opacity(0.9), radius: 12)
                    .opacity(boltOpacity)
            }
            .allowsHitTesting(false)
            .ignoresSafeArea()
            .onAppear {
                scheduleNextFlash(in: geometry.size)
            }
        }
    }

    // MARK: - Scheduling

    private func scheduleNextFlash(in size: CGSize) {
        let meanInterval = 1.0 / max(flashesPerSecond, 0.001)
        let delay = Double.random(
            in: meanInterval * 0.4 ... meanInterval * 1.8
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            createBolt(in: size)
            performFlashSequence(in: size)
        }
    }

    // MARK: - Bolt Generation

    private func createBolt(in size: CGSize) {
        var path = Path()

        let startX = CGFloat.random(
            in: size.width * 0.2 ... size.width * 0.8
        )

        var current = CGPoint(x: startX, y: -20)
        path.move(to: current)

        let segmentCount = Int.random(in: 6...10)

        for _ in 0..<segmentCount {
            let next = CGPoint(
                x: current.x + CGFloat.random(in: -40...40),
                y: current.y + CGFloat.random(in: 40...80)
            )

            path.addLine(to: next)
            current = next

            // Ocasional ramificación
            if Bool.random() && current.y < size.height * 0.6 {
                let branch = CGPoint(
                    x: current.x + CGFloat.random(in: -60...60),
                    y: current.y + CGFloat.random(in: 30...70)
                )

                path.move(to: current)
                path.addLine(to: branch)
                path.move(to: current)
            }

            if current.y > size.height * 0.75 {
                break
            }
        }

        boltPath = path
    }

    // MARK: - Flash Animation

    private func performFlashSequence(in size: CGSize) {
        let pulseCount = Int.random(in: 1...3)
        performPulse(index: 0, total: pulseCount, size: size)
    }

    private func performPulse(
        index: Int,
        total: Int,
        size: CGSize
    ) {
        let intensity = Double.random(
            in: maxOpacity * 0.6 ... maxOpacity
        )

        // Aparición instantánea
        withAnimation(.linear(duration: 0.02)) {
            flashOpacity = intensity * 0.35
            boltOpacity = intensity
        }

        // Desvanecimiento
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            withAnimation(.easeOut(duration: 0.20)) {
                flashOpacity = 0.0
                boltOpacity = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                if index + 1 < total {
                    performPulse(
                        index: index + 1,
                        total: total,
                        size: size
                    )
                } else {
                    scheduleNextFlash(in: size)
                }
            }
        }
    }
}

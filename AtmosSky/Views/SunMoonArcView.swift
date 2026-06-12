//
//  SunMoonArcView.swift
//  AtmosSky
//

import SwiftUI

struct SunMoonArcView: View {
    let currentDate: Date
    let sunrise: Date
    let sunset: Date

    // MARK: - Estado de animación
    @State private var animatedProgress: Double = 0
    @State private var targetProgress: Double = 0

    /// Controla la visibilidad del sol/luna.
    @State private var astroOpacity: Double = 1.0

    init(currentDate: Date, sunrise: Date, sunset: Date) {
        self.currentDate = currentDate
        self.sunrise = sunrise
        self.sunset = sunset
    }

    // MARK: - Estado actual

    /// Es de noche si estamos antes del amanecer o después del atardecer.
    private var isNight: Bool {
        currentDate < sunrise || currentDate >= sunset
    }

    // MARK: - Colores dinámicos según progreso en la noche/día

    private var astroGradient: LinearGradient {
        let nightProgress = calculateNightProgress()

        if isNight {
            let t = nightProgress

            let startColor = Color(
                red: 1.0,
                green: 0.6 - 0.2 * t,
                blue: 0.0 + 0.3 * t
            )
            let endColor = Color(
                red: 1.0 - 0.3 * t,
                green: 1.0 - 0.4 * t,
                blue: 1.0 - 0.2 * t
            )

            return LinearGradient(
                colors: [startColor, endColor],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                colors: [.yellow, .orange],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var glowColor: Color {
        let nightProgress = calculateNightProgress()

        if isNight {
            return Color(
                red: 1.0,
                green: 1.0 - 0.5 * nightProgress,
                blue: 0.3 + 0.7 * nightProgress
            )
            .opacity(0.4)
        } else {
            return Color.yellow.opacity(0.6)
        }
    }

    // MARK: - Progreso continuo en 24 horas

    /// Calcula el progreso del día (sunrise -> sunset) como 0...1
    private func calculateDayProgress() -> Double {
        if isNight { return 0 }

        let total = sunset.timeIntervalSince(sunrise)
        let elapsed = currentDate.timeIntervalSince(sunrise)

        return min(max(elapsed / total, 0), 1)
    }

    /// Calcula el progreso de la noche (sunset -> siguiente sunrise) como 0...1
    private func calculateNightProgress() -> Double {
        if !isNight { return 0 }

        let calendar = Calendar.current
        let nextSunrise = calendar.date(byAdding: .day, value: 1, to: sunrise)!
        let total = nextSunrise.timeIntervalSince(sunset)

        let adjustedCurrentDate: Date
        if currentDate < sunrise {
            adjustedCurrentDate = calendar.date(
                byAdding: .day,
                value: 1,
                to: currentDate
            )!
        } else {
            adjustedCurrentDate = currentDate
        }

        let elapsed = adjustedCurrentDate.timeIntervalSince(sunset)

        return min(max(elapsed / total, 0), 1)
    }

    /// Progreso normalizado a 0...1 para dibujar el arco
    private var normalizedArcProgress: Double {
        if isNight {
            return calculateNightProgress()
        } else {
            return calculateDayProgress()
        }
    }

    // MARK: - Vista

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            let center = CGPoint(x: width / 2, y: height)
            let radius = width / 2

            let angle = Double.pi * (1.0 - animatedProgress)

            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y - CGFloat(sin(angle)) * radius

            ZStack {
                // 1. Media circunferencia completa en gris (fondo)
                Path { path in
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(0),
                        clockwise: false
                    )
                }
                .stroke(
                    Color.white.opacity(0.15),
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        dash: [6, 6]
                    )
                )

                // 2. Parte recorrida hasta la posición del astro
                Path { path in
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(0),
                        clockwise: false
                    )
                }
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    astroGradient,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        dash: [6, 6]
                    )
                )

                // 3. Sol o Luna (solo hace fade, no se mueve visualmente)
                let iconName = isNight ? "moon.fill" : "sun.max.fill"

                Image(systemName: iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(astroGradient)
                    .shadow(
                        color: glowColor,
                        radius: 12
                    )
                    .position(x: x, y: y)
                    .opacity(astroOpacity)
            }
        }
        .onAppear {
            let progress = normalizedArcProgress
            animatedProgress = progress
            targetProgress = progress
            astroOpacity = 1.0
        }
        .onChange(of: sunrise) { _, _ in
            updateProgress()
        }
        .onChange(of: sunset) { _, _ in
            updateProgress()
        }
        .onChange(of: currentDate) { _, _ in
            updateProgress()
        }
    }

    // MARK: - Secuencia de animación
    //
    // 1. Fade out del sol/luna
    // 2. Animación del arco
    // 3. Recolocar el sol/luna en la posición final
    // 4. Fade in del sol/luna

    private func updateProgress() {
        let newProgress = normalizedArcProgress
        let currentProgress = animatedProgress

        // Evitar animaciones innecesarias si prácticamente no hay cambio.
        guard abs(newProgress - currentProgress) > 0.0001 else { return }

        targetProgress = newProgress

        // Duraciones
        let fadeOutDuration = 0.35
        let arcDuration = 2.0
        let fadeInDuration = 0.35

        // 1. Fade out del sol/luna
        withAnimation(.easeInOut(duration: fadeOutDuration)) {
            astroOpacity = 0.0
        }

        // 2. Cuando termina el fade out, animar el arco desde el valor actual
        //    hasta el nuevo valor.
        //
        //    - Si newProgress > currentProgress, el arco se rellenará.
        //    - Si newProgress < currentProgress, el arco se vaciará.
        //
        //    No reiniciamos a 0, por lo que la transición es continua.
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
            withAnimation(.easeInOut(duration: arcDuration)) {
                animatedProgress = newProgress
            }

            // 3. Al terminar la animación del arco, fijar el valor final exacto
            //    y hacer fade in del astro en su nueva posición.
            DispatchQueue.main.asyncAfter(deadline: .now() + arcDuration) {
                var transaction = Transaction()
                transaction.animation = nil

                withTransaction(transaction) {
                    animatedProgress = newProgress
                }

                // 4. Fade in del sol/luna ya en la posición correcta
                withAnimation(.easeInOut(duration: fadeInDuration)) {
                    astroOpacity = 1.0
                }
            }
        }
    }
}

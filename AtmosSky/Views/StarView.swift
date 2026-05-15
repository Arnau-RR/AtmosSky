//
//  Star.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

struct StarsView: View {
    let isNight: Bool

    // Generamos las estrellas una sola vez
    private let stars: [StarData] = (0..<120).map { _ in
        StarData(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),   // Ahora pueden aparecer en toda la pantalla
            size: CGFloat.random(in: 1...3),
            opacity: Double.random(in: 0.4...1.0)
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(stars) { star in
                    Circle()
                        .fill(.white)
                        .frame(
                            width: star.size,
                            height: star.size
                        )
                        .opacity(isNight ? star.opacity : 0)
                        .position(
                            x: star.x * geometry.size.width,
                            y: star.y * geometry.size.height
                        )
                        .blur(radius: 0.3)
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 3), value: isNight)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.05, blue: 0.20),
                Color(red: 0.10, green: 0.15, blue: 0.35)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        StarsView(isNight: true)
    }
}

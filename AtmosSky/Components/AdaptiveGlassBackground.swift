//
//  AdaptiveGlassBackground.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import SwiftUI

struct AdaptiveGlassBackground: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular,
                    in: RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                )
        } else {
            let shape = RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )

            content
                .background {
                    ZStack {
                        shape
                            .fill(.ultraThinMaterial)
                            .opacity(0.20)

                        shape
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.08),
                                        .purple.opacity(0.04),
                                        .blue.opacity(0.02)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        shape
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.12),
                                        .white.opacity(0.02)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    }
                }
                .shadow(
                    color: .black.opacity(0.12),
                    radius: 16,
                    x: 0,
                    y: 8
                )
        }
    }
}

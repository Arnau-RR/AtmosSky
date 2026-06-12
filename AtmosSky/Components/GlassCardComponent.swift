//
//  GlassCardComponent.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

struct GlassCardComponent<Content: View>: View {
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: Content

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 28,
        padding: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )

        content
            .padding(padding)
            .frame(width: width, height: height)
            .background {
                ZStack {
                    shape
                        .fill(.ultraThinMaterial)
                        .opacity(0.20)

                    shape
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.purple.opacity(0.04),
                                    Color.blue.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    shape
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.12),
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )

                    shape
                        .stroke(
                            Color.white.opacity(0.02),
                            lineWidth: 2
                        )
                        .blur(radius: 3)
                        .clipShape(shape)
                }
            }
            .shadow(
                color: Color.black.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.08, blue: 0.2),
                Color(red: 0.1, green: 0.05, blue: 0.15)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 16) {
            GlassCardComponent(
                width: 300,
                height: 120,
                cornerRadius: 24
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Sensación")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("6°")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Humedad")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("73%")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Viento")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text("4 km/h")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            GlassCardComponent(
                width: 300,
                height: 100,
                cornerRadius: 24
            ) {
                VStack(alignment: .leading) {
                    Text("Mañana")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("13°")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("27°")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
    }
}

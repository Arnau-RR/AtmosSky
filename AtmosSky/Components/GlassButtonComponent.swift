//
//  GlassButtonComponent.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import SwiftUI

import SwiftUI

struct GlassButtonComponent<Content: View>: View {
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let padding: CGFloat
    let action: () -> Void

    @ViewBuilder let content: Content

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 28,
        padding: CGFloat = 20,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.action = action
        self.content = content()
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                content
                    .padding(padding)
                    .frame(width: width, height: height)
            }
            .buttonStyle(.glass)
        } else {
            Button(action: action) {
                content
                    .padding(padding)
                    .frame(width: width, height: height)
            }
            .buttonStyle(ManualGlassButtonStyle(cornerRadius: cornerRadius))
        }
    }
}

// MARK: - Manual Glass Style (iOS < 26)

struct ManualGlassButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                ZStack {
                    // Frosted base
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    // Subtle top highlight
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.18),
                                    Color.white.opacity(0.04)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    // Border
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(red: 0.1, green: 0.05, blue: 0.2), Color(red: 0.05, green: 0.1, blue: 0.25)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            GlassButtonComponent(action: {}) {
                Label("Continuar", systemImage: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }

            GlassButtonComponent(cornerRadius: 16, action: {}) {
                Text("Cancelar")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.75))
            }
        }
        .padding()
    }
}


//struct GlassButtonComponent<Content: View>: View {
//    let width: CGFloat?
//    let height: CGFloat?
//    let cornerRadius: CGFloat
//    let padding: CGFloat
//    let action: () -> Void
//
//    @ViewBuilder let content: Content
//
//    init(
//        width: CGFloat? = nil,
//        height: CGFloat? = nil,
//        cornerRadius: CGFloat = 28,
//        padding: CGFloat = 20,
//        action: @escaping () -> Void,
//        @ViewBuilder content: () -> Content
//    ) {
//        self.width = width
//        self.height = height
//        self.cornerRadius = cornerRadius
//        self.padding = padding
//        self.action = action
//        self.content = content()
//    }
//
//    var body: some View {
//        Button(action: action) {
//            content
//                .padding(padding)
//                .frame(width: width, height: height)
//        }
//        .buttonStyle(.glass)
//    }
//}

//
//  GlassButtonComponent.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

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
        Button(action: action) {
            content
                .padding(padding)
                .frame(width: width, height: height)
        }
        .buttonStyle(.glass)
    }
}

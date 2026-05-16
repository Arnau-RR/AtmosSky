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
    let spacing: CGFloat
    @ViewBuilder let content: Content
    
    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 20,
        spacing: CGFloat = 15,
        @ViewBuilder content: () -> Content
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(18)
            .frame(width: width, height: height, alignment: .center)
            .foregroundColor(.gray.opacity(0.1))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

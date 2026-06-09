//
//  GlassButtonComponent.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import SwiftUI

struct GlassButtonComponent: View {
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let padding: CGFloat

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 28,
        padding: CGFloat = 20,
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.padding = padding
    }

    var body: some View {
        Button {

        } label: {
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
        }
        .buttonStyle(.glassProminent)
    }
}

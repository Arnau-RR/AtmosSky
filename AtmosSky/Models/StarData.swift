//
//  StarData.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import Foundation

struct StarData: Identifiable {
    let id = UUID()
    let x: CGFloat      // Posición horizontal normalizada (0...1)
    let y: CGFloat      // Posición vertical normalizada (0...1)
    let size: CGFloat   // Tamaño de la estrella
    let opacity: Double // Brillo base
}


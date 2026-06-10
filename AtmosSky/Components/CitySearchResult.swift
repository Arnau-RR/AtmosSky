//
//  CitySearchResult.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//


//
//  CitySearchResult.swift
//  AtmosSky
//
//  Created by Arnau on 09/06/2026.
//

import Foundation

struct CitySearchResult: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
}
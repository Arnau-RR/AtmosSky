//
//  ReverseGeocodingService.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import Foundation
import MapKit
import CoreLocation

enum ReverseGeocodingError: Error {
    case invalidLocation
    case cityNotFound
}

protocol ReverseGeocodingServiceProtocol {
    func reverseGeocoding(latitude: Double, longitude: Double) async throws -> String
}

final class ReverseGeocodingService: ReverseGeocodingServiceProtocol {
    func reverseGeocoding(latitude: Double, longitude: Double) async throws -> String {
        let location = CLLocation(
            latitude: latitude,
            longitude: longitude
        )

        guard let request = MKReverseGeocodingRequest(location: location) else {
            throw ReverseGeocodingError.invalidLocation
        }

        let mapItems = try await request.mapItems

        guard let cityAndCountryName = mapItems.first?
            .addressRepresentations?.cityWithContext,
        
         let cityName = mapItems.first?
            .addressRepresentations?
            .cityName else {
            throw ReverseGeocodingError.cityNotFound
        }
        
        print(cityAndCountryName)

        return cityAndCountryName
    }
}
    
    

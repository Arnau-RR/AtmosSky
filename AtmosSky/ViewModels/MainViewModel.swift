//
//  MainViewModel.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class MainViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var latitude: Double?
    @Published private(set) var longitude: Double?

    // MARK: - Dependencies

    private let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(locationService: LocationService? = nil) {
        self.locationService = locationService ?? LocationService()
        bindLocationService()
    }

    // MARK: - Public API

    func requestLocationPermission() {
        locationService.requestPermission()
    }

    func refreshLocation() {
        locationService.requestLocation()
    }

    // MARK: - Private Methods

    private func bindLocationService() {
        locationService.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }

                self.currentLocation = location
                self.latitude = location?.coordinate.latitude
                self.longitude = location?.coordinate.longitude
            }
            .store(in: &cancellables)

        locationService.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
            }
            .store(in: &cancellables)
    }
}

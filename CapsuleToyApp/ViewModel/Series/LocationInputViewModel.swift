//
//  LocationInputViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//

import SwiftUI
import RealmSwift
import MapKit
import Combine

final class LocationInputViewModel: ObservableObject {
    
    private let locationRepository: LocationRepositoryProtocol
    
    @Published var region: MapCameraPosition = .region(LocationRepository.defultRegion)
    @Published var adress: String = ""
    
    @Published var showValidationErrorAlert: Bool = false
    
    @Published private(set) var errorMsg: String = ""
    private var errors: [ValidationError] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    public func onAppear() { }
    
    public func onDisappear() { }
}

// MARK: - Public Method
extension LocationInputViewModel {
    
    @MainActor
    public func observeUserLocation() {
        Task {
            await locationRepository.observeUserLocation()
        }
        
        locationRepository.region
            .removeDuplicates { old, new in
                // 緯度 / 経度に変化がないならストリームに流さない
                old.center.latitude == new.center.latitude && old.center.longitude == new.center.longitude
            }.sink { [weak self] region in
                guard let self else { return }
                self.region = .region(region)
            }.store(in: &cancellables)
        
        locationRepository.address
            .sink { [weak self] address in
                guard let self else { return }
                self.adress = adress
            }.store(in: &cancellables)
    }
    
    public func clearObserveUserLocation() {
        cancellables.forEach { $0.cancel() }
    }
    
    
    public func createLocation(
        coordinate: CLLocationCoordinate2D?,
        name: String
    ) -> Location? {
       
        clearErrorMsg()
        
        if name.isEmpty {
            errors.append(.emptyLocationName)
        }
        guard errors.isEmpty else {
            showValidationAlert()
            return nil
        }
        
        let location = Location()
        location.name = name
        location.latitude = coordinate?.latitude
        location.longitude = coordinate?.longitude
        return location
    }
}

// MARK: - Private Method
extension LocationInputViewModel {
    
    private func clearErrorMsg() {
        errors = []
        errorMsg = ""
        showValidationErrorAlert = false
    }
    
    private func showValidationAlert() {
        errorMsg = errors.map { $0.message }.joined(separator: "\n")
        showValidationErrorAlert = true
    }
}

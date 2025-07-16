//
//  LocationRepositoryProtocol.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/11.
//

import MapKit
import Combine

protocol LocationRepositoryProtocol {
    var region: AnyPublisher<MKCoordinateRegion, Never> { get }
    var address: AnyPublisher<String, Never> { get }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus?, Never> { get }
    @MainActor
    func geocode(addressKey: String) async throws
    @MainActor
    func requestWhenInUseAuthorization()
    @MainActor
    func observeUserLocation() async
}

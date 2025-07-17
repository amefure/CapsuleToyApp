//
//  SeriesEntryViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI
import RealmSwift
import MapKit
import Combine

final class SeriesEntryViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol
    private let locationRepository: LocationRepositoryProtocol
    
    @Published private(set) var locationDic: [String: Location] = [:]
    
    @Published var region: MapCameraPosition = .region(LocationRepository.defultRegion)
    @Published var adress: String = ""
    
    @Published var showEntrySuccessAlert: Bool = false
    @Published var showUpdateSuccessAlert: Bool = false
    @Published var showValidationErrorAlert: Bool = false
    
    @Published private(set) var errorMsg: String = ""
    private var messages: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        seriesRepository: SeriesRepositoryProtocol,
        locationRepository: LocationRepositoryProtocol
    ) {
        self.seriesRepository = seriesRepository
        self.locationRepository = locationRepository
    }
    
    public func onAppear() { }
    
    public func onDisappear() { }
}

// MARK: - Public Method
extension SeriesEntryViewModel {
    
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
    
    
    public func updateLocationDic(locations: RealmSwift.List<Location>) {
        locationDic = Dictionary(uniqueKeysWithValues: locations.map { ($0.id.stringValue, $0) })
    }
    
    public func deleteLocationDic(_ location: Location) {
        locationDic.removeValue(forKey: location.id.stringValue)
    }
    
    /// 新規作成 or 更新処理
    public func createOrUpdateSeries(
        id: ObjectId?,
        name: String,
        count: Int,
        amount: Int,
        memo: String,
        locations: [Location]
    ) {
        let realmLocations = RealmSwift.List<Location>()
        realmLocations.append(objectsIn: locations)
        if let id {
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.amount = amount
                series.memo = memo
                series.locations = realmLocations
                series.createdAt = Date()
                series.updatedAt = Date()
                showUpdateSuccessAlert = true
            }
        } else {
            let series = Series()
            series.name = name
            series.count = count
            series.amount = amount
            series.memo = memo
            series.locations = realmLocations
            series.createdAt = Date()
            series.updatedAt = Date()
            seriesRepository.addSeries(series)
            showEntrySuccessAlert = true
        }
    }
    
    
    public func addLocation(
        coordinate: CLLocationCoordinate2D?,
        name: String,
        location: Location
    ) -> Bool {
       
        clearErrorMsg()
        
        if name.isEmpty {
            messages.append("・場所名を入力してください。")
        }
        guard messages.isEmpty else {
            showValidationAlert()
            return false
        }
       
        location.name = name
        location.latitude = coordinate?.latitude
        location.longitude = coordinate?.longitude
        locationDic.updateValue(location, forKey: location.id.stringValue)
        return true
    }
    
}

// MARK: - Private Method
extension SeriesEntryViewModel {
    
    private func clearErrorMsg() {
        messages = []
        errorMsg = ""
    }
    
    private func showValidationAlert() {
        errorMsg = messages.joined(separator: "\n")
        showValidationErrorAlert = true
    }
}

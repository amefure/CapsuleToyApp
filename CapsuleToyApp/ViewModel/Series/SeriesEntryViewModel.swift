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
    private var errors: [ValidationError] = []
    
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
        locations: [Location],
        image: UIImage?
    ) {
        let realmLocations = RealmSwift.List<Location>()
        realmLocations.append(objectsIn: locations)
        if let id {
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: id.stringValue, image: image)
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.amount = amount
                series.memo = memo
                series.locations = realmLocations
                series.imagePath = path
                series.createdAt = Date()
                series.updatedAt = Date()
                showUpdateSuccessAlert = true
            }
        } else {
            let series = Series()
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: series.id.stringValue, image: image)
            series.name = name
            series.count = count
            series.amount = amount
            series.memo = memo
            series.locations = realmLocations
            series.imagePath = path
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
            errors.append(.emptySeriesName)
        }
        guard errors.isEmpty else {
            showValidationAlert()
            return false
        }
       
        location.name = name
        location.latitude = coordinate?.latitude
        location.longitude = coordinate?.longitude
        locationDic.updateValue(location, forKey: location.id.stringValue)
        return true
    }
    
    /// 画像を取得する
    public func fecthImage(id: String) -> UIImage? {
        let imageFileManager = ImageFileManager()
        return imageFileManager.loadImage(id)
    }
    
}

// MARK: - Private Method
extension SeriesEntryViewModel {
    
    private func clearErrorMsg() {
        errors = []
        errorMsg = ""
        showValidationErrorAlert = false
    }
    
    private func showValidationAlert() {
        errorMsg = errors.map { $0.message }.joined(separator: "\n")
        showValidationErrorAlert = true
    }
    
    /// 画像をローカルへ保存する処理
    private func saveImageForLocal(id: String, image: UIImage?) -> String? {
        guard let image else { return nil }
        // 画像をローカルへ保存処理
        let imageFileManager = ImageFileManager()
        let path: String? = try? imageFileManager.saveImage(name: id, image: image)
        return path
    }
}

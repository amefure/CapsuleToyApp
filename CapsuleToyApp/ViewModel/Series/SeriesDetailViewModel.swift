//
//  SeriesDetailViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/08.
//

import SwiftUI
import RealmSwift
import MapKit
import Combine

final class SeriesDetailViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol
    private let locationRepository: LocationRepositoryProtocol
    
    @Published private(set) var series: Series?
    
    @Published var region: MapCameraPosition = .region(LocationRepository.defultRegion)
    @Published var showConfirmDeleteAlert: Bool = false
    @Published var showSuccessDeleteAlert: Bool = false
    @Published var showFaieldDeleteAlert: Bool = false
    @Published var presentEntryToyScreen: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        seriesRepository: SeriesRepositoryProtocol,
        locationRepository: LocationRepositoryProtocol
    ) {
        self.seriesRepository = seriesRepository
        self.locationRepository = locationRepository
    }
    
    @MainActor
    public func onAppear(id: ObjectId) {
        fetchSeries(id: id)
        
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
        
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
    
    /// 一件取得
    public func fetchSeries(id: ObjectId) {
        series = seriesRepository.fetchSeries(by: id)
    }
    
    /// 削除処理
    public func deleteSeries() {
        guard let series else {
            showFaieldDeleteAlert = true
            return
        }
        let imageFileManager = ImageFileManager()
        series.capsuleToys.forEach { toy in
            // 登録してあるコレクションの画像を明示的に削除する
            try? imageFileManager.deleteImage(name: toy.id.stringValue)
        }
        // 登録してあるシリーズの画像を明示的に削除する
        try? imageFileManager.deleteImage(name: series.id.stringValue)
        seriesRepository.deleteSeries([series])
        showSuccessDeleteAlert = true
    }
}

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
    
    @Published var region: MKCoordinateRegion = LocationRepository.defultRegion
    @Published var adress: String = ""
    // ユーザートラッキングモードを追従モードにするための変数を定義
    @Published var trackingMode = MapUserTrackingMode.follow
    
    @Published var showEntrySuccessAlert: Bool = false
    @Published var showUpdateSuccessAlert: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        seriesRepository: SeriesRepositoryProtocol,
        locationRepository: LocationRepositoryProtocol
    ) {
        self.seriesRepository = seriesRepository
        self.locationRepository = locationRepository
    }
    
    
    public func onAppear() {
        locationRepository.region
            .sink { [weak self] region in
                guard let self else { return }
                self.region = region
            }.store(in: &cancellables)
        
        locationRepository.address
            .sink { [weak self] address in
                guard let self else { return }
                self.adress = adress
            }.store(in: &cancellables)
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
    
    /// 新規作成 or 更新処理
    public func createOrUpdateSeries(
        id: ObjectId?,
        name: String,
        count: Int,
        amount: Int,
        memo: String,
    ) {
        if let id {
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.amount = amount
                series.memo = memo
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
            series.createdAt = Date()
            series.updatedAt = Date()
            seriesRepository.addSeries(series)
            showEntrySuccessAlert = true
        }
        
    }
}

//
//  SeriesEntryViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI
import RealmSwift

final class SeriesEntryViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    @Published var showEntrySuccessAlert: Bool = false
    @Published var showUpdateSuccessAlert: Bool = false
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    
    public func onAppear() {
    }
    
    public func onDisappear() {
        
    }
    
    /// 新規作成 or 更新処理
    public func createSeriesOrUpdate(
        id: ObjectId?,
        name: String,
        count: Int,
        memo: String? = nil,
    ) {
        if let id {
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.memo = memo
                series.createdAt = Date()
                series.updatedAt = Date()
                showUpdateSuccessAlert = true
            }
        } else {
            let series = Series()
            series.name = name
            series.count = count
            series.memo = memo
            series.createdAt = Date()
            series.updatedAt = Date()
            seriesRepository.addSeries(series)
            showEntrySuccessAlert = true
        }
        
    }
}

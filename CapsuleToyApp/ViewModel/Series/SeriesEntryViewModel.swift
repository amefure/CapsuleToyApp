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
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    
    public func onAppear() {
    }
    
    public func onDisappear() {
        
    }
    
    /// 新規作成
    public func createSeries(
        name: String,
        count: Int,
        memo: String? = nil,
    ) {
        let series = Series()
        series.name = name
        series.count = count
        series.memo = memo
        series.createdAt = Date()
        series.updatedAt = Date()
        seriesRepository.addSeries(series)
    }

    /// 更新処理
    public func updateSeries(
        id: ObjectId,
        name: String,
        count: Int,
        memo: String? = nil,
    ) {
        seriesRepository.updateSeries(id: id) { [weak self] series in
            guard let self else { return }
            series.name = name
            series.count = count
            series.memo = memo
            series.createdAt = Date()
            series.updatedAt = Date()
        }
    }
}

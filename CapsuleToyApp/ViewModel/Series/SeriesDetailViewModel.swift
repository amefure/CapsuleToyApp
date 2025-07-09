//
//  SeriesDetailViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/08.
//

import SwiftUI
import RealmSwift

final class SeriesDetailViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    @Published private(set) var series: Series?
    
    @Published var showConfirmDeleteAlert: Bool = false
    @Published var showSuccessDeleteAlert: Bool = false
    @Published var showFaieldDeleteAlert: Bool = false
    
    
    @Published var presentEntryToyScreen: Bool = false
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    
    public func onAppear(id: ObjectId) {
        fetchSeries(id: id)
    }
    
    public func onDisappear() {
        
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
        seriesRepository.deleteSeries([series])
        showSuccessDeleteAlert = true
    }
}

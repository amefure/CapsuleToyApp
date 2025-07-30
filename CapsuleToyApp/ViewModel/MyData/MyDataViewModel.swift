//
//  MyDataViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/26.
//

import SwiftUI
import RealmSwift

final class MyDataViewModel: ObservableObject {
    
    @Published private(set) var seriesList: [Series] = []
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    public var allCount: Double {
        Double(seriesList.count)
    }
    
    public var completePercent: Double {
        guard allCount != 0 else { return 0 }
        let percent = Double(seriesList.filter { $0.isComplete }.count) / allCount
        return percent * 100
    }
    
    public var getSecretPercent: Double {
        guard allCount != 0 else { return 0 }
        let percent = Double(seriesList.filter { $0.isGetSecret }.count) / allCount
        return percent * 100
        
    }
    
    
    public func onAppear() {
        seriesList = seriesRepository.fetchAllSeries()
    }
    
    public func onDisappear() {
        
    }
}

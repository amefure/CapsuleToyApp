//
//  SeriesListViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//


import SwiftUI

final class SeriesListViewModel: ObservableObject {
    
    @Published private(set) var seriesList: [Series] = []
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    
    public func onAppear() {
        seriesList = seriesRepository.fetchAllSeries()
    }
    
    public func onDisappear() {
        
    }
}

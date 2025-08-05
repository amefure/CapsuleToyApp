//
//  SeriesListViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI
import Combine

final class SeriesListViewModel: ObservableObject {
    
    @Published private(set) var seriesList: [Series] = []
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
        
        // リフレッシュ処理実行通知観測
        NotificationCenter.default.publisher(for: .refresh)
            .sink { [weak self] notification in
                guard let self else { return }
                self.refresh()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    public func onAppear() {
        refresh()
    }
    
    public func onDisappear() {
    }
}

extension SeriesListViewModel {
    private func refresh() {
        seriesList = seriesRepository.fetchAllSeries()
    }
}

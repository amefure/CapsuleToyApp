//
//  DIContainer.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Swinject

final class DIContainer: @unchecked Sendable{
    static let shared = DIContainer()

    private let container = Container() { c in
        // Add Repository
        c.register(SeriesRepositoryProtocol.self) { _ in MockSeriesRepository.shared }
        // c.register(SeriesRepositoryProtocol.self) { _ in SeriesRepository() }
        
        // Add ViewModel
        c.register(SeriesListViewModel.self) { r in
            SeriesListViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(SeriesEntryViewModel.self) { r in
            SeriesEntryViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(SeriesDetailViewModel.self) { r in
            SeriesDetailViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
    }


    public func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}


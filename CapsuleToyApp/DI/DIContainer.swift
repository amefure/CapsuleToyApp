//
//  DIContainer.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Foundation
import Swinject

final class DIContainer: @unchecked Sendable {
    static let shared = DIContainer()
    
    // FIXME: モック切り替えフラグ
    static private let isTest: Bool = false

    private let container = Container() { c in
        
        // Add Repository
        if isTest {
            c.register(SeriesRepositoryProtocol.self) { _ in MockSeriesRepository.shared }
        } else {
            c.register(SeriesRepositoryProtocol.self) { _ in SeriesRepository() }
        }
        
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(LocationRepositoryProtocol.self) { _ in LocationRepository() }
        
        c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        
        
        // Add ViewModel
        c.register(SeriesListViewModel.self) { r in
            SeriesListViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(SeriesEntryViewModel.self) { r in
            SeriesEntryViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(SeriesDetailViewModel.self) { r in
            SeriesDetailViewModel(
                seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!,
                locationRepository: r.resolve(LocationRepositoryProtocol.self)!
            )
        }
        
        c.register(LocationInputViewModel.self) { r in
            LocationInputViewModel(locationRepository: r.resolve(LocationRepositoryProtocol.self)!)
        }
        
        c.register(CategoryInputViewModel.self) { r in CategoryInputViewModel()}
        
        c.register(CapsuleToyEntryViewModel.self) { r in
            CapsuleToyEntryViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(CapsuleToyDetailViewModel.self) { r in
            CapsuleToyDetailViewModel(seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!)
        }
        
        c.register(MyDataViewModel.self) { r in
            MyDataViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                seriesRepository: r.resolve(SeriesRepositoryProtocol.self)!
            )
        }
        
        c.register(InAppPurchaseViewModel.self) { r in
            InAppPurchaseViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }
            
        c.register(RootEnvironment.self) { r in
            RootEnvironment(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                locationRepository: r.resolve(LocationRepositoryProtocol.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!                
            )
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}


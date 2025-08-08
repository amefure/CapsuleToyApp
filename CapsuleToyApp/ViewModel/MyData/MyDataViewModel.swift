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
    
    /// 残り無料お試し機能解放数
    @Published private(set) var limitCount: Int = 5
    
    private let dateFormatUtility = DateFormatUtility()
    private let userDefaultsRepository: UserDefaultsRepository
    private let seriesRepository: SeriesRepositoryProtocol
    
    init(
        userDefaultsRepository: UserDefaultsRepository,
        seriesRepository: SeriesRepositoryProtocol
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.seriesRepository = seriesRepository
    }
    
    public func onAppear() {
        seriesList = seriesRepository.fetchAllSeries()
        // 現在のカウント数を取得
        let current = userDefaultsRepository.getShowLockLimit()
        // 最大数から現在のカウントを引いて残りを格納
        limitCount = UnlockFeatureConfig.MAX_LIMIT - current
    }
    
    public func onDisappear() {
        
    }
}

extension MyDataViewModel {
    /// 総数
    public var allCount: Double {
        Double(seriesList.count)
    }
    
    /// シリーズアイテムコンプリートパーセンテージ
    public var completePercent: Double {
        guard allCount != 0 else { return 0 }
        let percent = Double(seriesList.filter { $0.isComplete }.count) / allCount
        return percent * 100
    }
    
    /// シークレット取得率パーセンテージ
    public var getSecretPercent: Double {
        guard allCount != 0 else { return 0 }
        let percent = Double(seriesList.filter { $0.isGetSecret }.count) / allCount
        return percent * 100
    }
    
    /// 累計合計金額
    public var sumAmount: Int {
        guard allCount != 0 else { return 0 }
        let sum = seriesList.reduce(0) { (result, element) in
            let itemCount = element.capsuleToys.filter { $0.isOwned }.count
            return result + itemCount * element.amount
        }
        return sum
    }
    
    /// 累計取得アイテム数
    public var sumGetCount: Int {
        guard allCount != 0 else { return 0 }
        let sum = seriesList.reduce(0) { (result, element) in
            let itemCount = element.capsuleToys.filter { $0.isOwned }.count
            return result + itemCount
        }
        return sum
    }
    
    
    /// `CapsuleToy`を月毎にセクション分けした辞書型に変換する
    public func dayCapsuleToyDictionary() -> [Date: [CapsuleToy]]? {
        
        let toys: [(CapsuleToy, Date)] = seriesList
            .flatMap { $0.capsuleToys }
            .compactMap { [weak self] toy -> (CapsuleToy, Date)? in
                guard let self,
                      let isGetAt = toy.isGetAt else { return nil }
                return (toy, self.dateFormatUtility.startOfMonth(isGetAt))
            }
        
        var groupedRecords: [Date: [CapsuleToy]] = Dictionary(grouping: toys) { $0.1 }
            .mapValues { $0.map { $0.0 } }

        guard !groupedRecords.isEmpty else { return nil }
        let today = Date()
        // 今月のDate型を取得
        let currentMonth = dateFormatUtility.startOfMonth(today)
        
        // 6ヶ月前の日付を計算
        let sixMonthsAgo = dateFormatUtility.dateByAdding(currentMonth, by: .month, value: -6)
        
        // 6ヶ月前の日付の月単位の最初の日
        let startDate = dateFormatUtility.startOfMonth(sixMonthsAgo)
        
        var date = startDate
        
        while date <= today {
            // 現在の月の最初の日付をキーとして辞書に存在しない場合、空の配列で追加
            if groupedRecords[date] == nil {
                groupedRecords[date] = []
            }
            // 次の月の最初の日付を計算
            let nextMonth = dateFormatUtility.dateByAdding(date, by: .month, value: 1)
            date = dateFormatUtility.startOfMonth(nextMonth)
        }
        return groupedRecords
    }
}

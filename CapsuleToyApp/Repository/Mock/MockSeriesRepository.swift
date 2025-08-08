//
//  MockSeriesRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//


import Foundation
import RealmSwift

/// モックなので`@unchecked Sendable`とする
/// インメモリで管理
final class MockSeriesRepository: SeriesRepositoryProtocol, @unchecked Sendable {

    public static let shared = MockSeriesRepository()

    /// モック用のシリーズ一覧
    private var seriesList: [Series] = Series.mockList()

    /// すべてのシリーズを取得する
    public func fetchAllSeries() -> [Series] {
        return seriesList
    }

    /// 指定された ID のシリーズを取得する
    public func fetchSeries(by id: ObjectId) -> Series? {
        return seriesList.first { $0.id == id }
    }

    /// 新しいシリーズを追加する
    public func addSeries(_ series: Series) {
        seriesList.append(series)
    }

    /// 指定された ID のシリーズを更新する
    public func updateSeries(id: ObjectId, updateBlock: (Series) -> Void) {
        guard let index = seriesList.firstIndex(where: { $0.id == id }) else { return }
        updateBlock(seriesList[index])
    }

    /// 指定された複数のシリーズを削除する
    public func deleteSeries(_ list: [Series]) {
        let ids = list.map(\.id)
        seriesList.removeAll { ids.contains($0.id) }
    }

    /// 指定されたシリーズにカプセルトイを追加する
    public func addCapsuleToy(seriesId id: ObjectId, toy: CapsuleToy) {
        guard let index = seriesList.firstIndex(where: { $0.id == id }) else { return }
        seriesList[index].capsuleToys.append(toy)
        seriesList[index].updatedAt = Date()
    }
    
    /// 指定されたIDのカプセルトイを更新する
    public func updateCapsuleToy(
        toyId: ObjectId,
        updateBlock: (CapsuleToy) -> Void
    ) {
        guard let series = seriesList.first(where: {
            $0.capsuleToys.contains(where: { $0.id == toyId })
        }) else { return }

        guard let toyIndex = series.capsuleToys.firstIndex(where: { $0.id == toyId }) else { return }

        updateBlock(series.capsuleToys[toyIndex])
        series.updatedAt = Date()
    }
    
    /// カプセルトイ単体削除
    public func deleteCapsuleToy(_ toy: CapsuleToy) {
        guard let series = seriesList.first(where: {
            $0.capsuleToys.contains(where: { $0.id == toy.id })
        }) else { return }

        guard let toyIndex = series.capsuleToys.firstIndex(where: { $0.id == toy.id }) else { return }
        series.capsuleToys.remove(at: toyIndex)
    }
    
    /// カテゴリ全取得
    public func fetchAllCategory() -> [Category] {
        // カテゴリ名が重複していないものを全て取得する
        Dictionary(
            grouping: seriesList.flatMap { $0.categories },
            by: { $0.name }
        ).compactMap { $0.value.first }
    }
    
    /// カテゴリ物理削除
    public func deleteCategories(_ list: [Category]) {
        // モックでは不要
    }
    
    /// ロケーション物理削除
    public func deleteLocations(_ list: [Location]) {
        // モックでは不要
    }
}

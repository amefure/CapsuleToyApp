//
//  SeriesRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//
import RealmSwift
import Foundation

final class SeriesRepository: SeriesRepositoryProtocol {
    private let realmRepo = RealmRepository()

    public func fetchAllSeries() -> [Series] {
        realmRepo.readAllObjs()
    }

    public func fetchSeries(by id: ObjectId) -> Series? {
        realmRepo.getByPrimaryKey(id)
    }

    public func addSeries(_ series: Series) {
        realmRepo.createObject(series)
    }

    public func updateSeries(
        id: ObjectId,
        updateBlock: @escaping (Series) -> Void
    ) {
        realmRepo.updateObject(Series.self, id: id, updateBlock: updateBlock)
    }

    /// シリーズ削除
    public func deleteSeries(_ list: [Series]) {
        realmRepo.removeObjs(list: list)
        // RealmではSeries(親)を削除しても子は削除されないので明示的に削除する
        list.forEach { series in
            realmRepo.removeObjs(list: Array(series.capsuleToys))
            realmRepo.removeObjs(list: Array(series.locations))
            realmRepo.removeObjs(list: Array(series.categories))
        }
    }
    
    /// カプセルトイをシリーズに追加
    public func addCapsuleToy(seriesId id: ObjectId, toy: CapsuleToy) {
        realmRepo.updateObject(Series.self, id: id) { series in
            series.capsuleToys.append(toy)
            series.updatedAt = Date()
        }
    }
    
    /// 指定されたIDのカプセルトイを更新する
    public func updateCapsuleToy(
        toyId: ObjectId,
        updateBlock: @escaping (CapsuleToy) -> Void
    ) {
        realmRepo.updateObject(CapsuleToy.self, id: toyId, updateBlock: updateBlock)
    }
    
    /// カプセルトイ単体削除
    public func deleteCapsuleToy(_ toy: CapsuleToy) {
        realmRepo.removeObjs(list: [toy])
    }
    
    /// カテゴリ全取得
    public func fetchAllCategory() -> [Category] {
        let list: [Category] = realmRepo.readAllObjs()
        // カテゴリ名が重複していないものを全て取得する
        return Dictionary(
            grouping: list,
            by: { $0.name }
        ).compactMap { $0.value.first }
    }
    
    /// カテゴリ物理削除
    public func deleteCategories(_ list: [Category]) {
        realmRepo.removeObjsInWrite(list: list)
    }
    
    /// ロケーション物理削除
    public func deleteLocations(_ list: [Location]) {
        realmRepo.removeObjsInWrite(list: list)
    }
}

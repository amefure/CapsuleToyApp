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
        // RealmではSeries(親)を削除しても子は削除されないので明示的に削除する
        list.forEach { series in
            realmRepo.removeObjs(list: Array(series.capsuleToys))
            realmRepo.removeObjs(list: Array(series.locations))
            realmRepo.removeObjs(list: Array(series.categories))
        }
        
        realmRepo.removeObjs(list: list)
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
    
    public func deleteCapsuleToy(_ toy: CapsuleToy) {
        realmRepo.removeObjs(list: [toy])
    }
}

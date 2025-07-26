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
            removeAllCapsuleToys(seriesId: series.id)
        }
        
        realmRepo.removeObjs(list: list)
    }

    /// カプセルトイも一緒に削除する
    public func deleteAllSeries() {
        realmRepo.removeAllObjs(Series.self)
        realmRepo.removeAllObjs(CapsuleToy.self)
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
        id: ObjectId,
        updateBlock: @escaping (CapsuleToy) -> Void
    ) {
        realmRepo.updateObject(CapsuleToy.self, id: id, updateBlock: updateBlock)
    }

    /// カプセルトイをシリーズから削除
    public func removeCapsuleToy(seriesId id: ObjectId, toyId: ObjectId) {
        realmRepo.updateObject(Series.self, id: id) { series in
            guard let index = series.capsuleToys.firstIndex(where: { $0.id == toyId }) else { return }
            series.capsuleToys.remove(at: index)
            series.updatedAt = Date()
        }
    }

    /// 指定のシリーズ内のカプセルトイをすべて削除
    public func removeAllCapsuleToys(seriesId id: ObjectId) {
        realmRepo.updateObject(Series.self, id: id) { series in
            series.capsuleToys.removeAll()
        }
    }
}

//
//  SeriesRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//
import RealmSwift

final class SeriesRepository: SeriesRepositoryProtocol {
    private let realmRepo = RealmRepository()

    func fetchAllSeries() -> [Series] {
        realmRepo.readAllObjs()
    }

    func fetchSeries(by id: ObjectId) -> Series? {
        realmRepo.getByPrimaryKey(id.stringValue)
    }

    func addSeries(_ series: Series) {
        realmRepo.createObject(series)
    }

    func updateSeries(id: ObjectId, updateBlock: @escaping (Series) -> Void) {
        realmRepo.updateObject(Series.self, id: id.stringValue, updateBlock: updateBlock)
    }

    func deleteSeries(_ list: [Series]) {
        realmRepo.removeObjs(list: list)
    }

    func deleteAllSeries() {
        realmRepo.removeAllObjs(Series.self)
    }
}

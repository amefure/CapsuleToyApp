//
//  SeriesRepositoryProtocol.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import RealmSwift

protocol SeriesRepositoryProtocol {
    func fetchAllSeries() -> [Series]
    func fetchSeries(by id: ObjectId) -> Series?
    func addSeries(_ series: Series)
    func updateSeries(id: ObjectId, updateBlock: @escaping (Series) -> Void)
    func deleteSeries(_ list: [Series])
    func deleteAllSeries()
}

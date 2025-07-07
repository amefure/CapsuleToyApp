//
//  MockSeriesRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import RealmSwift

final class MockSeriesRepository: SeriesRepositoryProtocol {
    private var seriesList: [Series] = Series.mockList()

    func fetchAllSeries() -> [Series] {
        return seriesList
    }

    func fetchSeries(by id: ObjectId) -> Series? {
        return seriesList.first { $0.id == id }
    }

    func addSeries(_ series: Series) {
        seriesList.append(series)
    }

    func updateSeries(id: ObjectId, updateBlock: (Series) -> Void) {
        guard let index = seriesList.firstIndex(where: { $0.id == id }) else { return }
        updateBlock(seriesList[index])
    }

    func deleteSeries(_ list: [Series]) {
        let ids = list.map(\.id)
        seriesList.removeAll { ids.contains($0.id) }
    }

    func deleteAllSeries() {
        seriesList.removeAll()
    }
}

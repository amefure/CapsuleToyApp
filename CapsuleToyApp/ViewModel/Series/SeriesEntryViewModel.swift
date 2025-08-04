//
//  SeriesEntryViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI
import RealmSwift
import MapKit
import Combine

final class SeriesEntryViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol
    
    @Published var locationDic: [String: Location] = [:]
    @Published var categoryDic: [String: Category] = [:]
    
    @Published var showEntrySuccessAlert: Bool = false
    @Published var showUpdateSuccessAlert: Bool = false
    @Published var showValidationErrorAlert: Bool = false
    
    @Published var showAddLocationScreen: Bool = false
    @Published var showAddCategoryScreen: Bool = false
    
    @Published private(set) var errorMsg: String = ""
    private var errors: [ValidationError] = []
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    public func onAppear() { }
    
    public func onDisappear() { }
}

// MARK: - Public Method
extension SeriesEntryViewModel {
    
    public func updateCategoryDic(categories: RealmSwift.List<Category>) {
        categoryDic = Dictionary(uniqueKeysWithValues: categories.map { ($0.id.stringValue, $0) })
    }
    
    public func deleteCategoryDic(_ category: Category) {
        categoryDic.removeValue(forKey: category.id.stringValue)
    }
    
    
    public func updateLocationDic(locations: RealmSwift.List<Location>) {
        locationDic = Dictionary(uniqueKeysWithValues: locations.map { ($0.id.stringValue, $0) })
    }
    
    public func deleteLocationDic(_ location: Location) {
        locationDic.removeValue(forKey: location.id.stringValue)
    }
    
    /// 新規作成 or 更新処理
    public func createOrUpdateSeries(
        id: ObjectId?,
        name: String,
        count: Int,
        amount: Int,
        memo: String,
        locations: [Location],
        categories: [Category],
        image: UIImage?
    ) {
        let realmLocations = locations.toRealmList()
        
        let realmCategories = categories.toRealmList()
        
        if let id {
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: id.stringValue, image: image)
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.amount = amount
                series.memo = memo
                series.locations = realmLocations
                series.categories = realmCategories
                series.imagePath = path
                series.createdAt = Date()
                series.updatedAt = Date()
                showUpdateSuccessAlert = true
            }
        } else {
            let series = Series()
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: series.id.stringValue, image: image)
            series.name = name
            series.count = count
            series.amount = amount
            series.memo = memo
            series.locations = realmLocations
            series.categories = realmCategories
            series.imagePath = path
            series.createdAt = Date()
            series.updatedAt = Date()
            seriesRepository.addSeries(series)
            showEntrySuccessAlert = true
        }
    }
    
    /// 画像を取得する
    public func fecthImage(id: String) -> UIImage? {
        let imageFileManager = ImageFileManager()
        return imageFileManager.loadImage(id)
    }
    
}

// MARK: - Private Method
extension SeriesEntryViewModel {
    
    private func clearErrorMsg() {
        errors = []
        errorMsg = ""
        showValidationErrorAlert = false
    }
    
    private func showValidationAlert() {
        errorMsg = errors.map { $0.message }.joined(separator: "\n")
        showValidationErrorAlert = true
    }
    
    /// 画像をローカルへ保存する処理
    private func saveImageForLocal(id: String, image: UIImage?) -> String? {
        guard let image else { return nil }
        // 画像をローカルへ保存処理
        let imageFileManager = ImageFileManager()
        let path: String? = try? imageFileManager.saveImage(name: id, image: image)
        return path
    }
}

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
    
    /// 登録ずみのカテゴリリスト
    private var allCategories: [Category] = []
    
    /// 位置情報登録用辞書
    @Published var locationDic: [String: Location] = [:]
    /// カテゴリ登録用辞書
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
    
    public func onAppear() {
        allCategories = seriesRepository.fetchAllCategory()
    }
    
    public func onDisappear() { }
}

// MARK: - Public Method
extension SeriesEntryViewModel {
    
    public var filteredCategories: [Category] {
        return allCategories.filter { category in
            guard !categoryDic.isEmpty else { return true }
            return categoryDic.values.map({ $0.name }).contains(category.name) == false
        }.sorted(by: { $0.name < $1.name })
    }
    
    public func addCategoryDic(_ category: Category) {
        // 同じものをコピーする形で追加する
        let new = Category()
        new.name = category.name
        new.colorHex = category.colorHex
        // 既に同一名のカテゴリが付与済みなら追加しない
        guard categoryDic.values.map({ $0.name }).contains(new.name) == false else { return }
        categoryDic.updateValue(new, forKey: new.id.stringValue)
    }
    
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
        
        clearErrorMsg()
        
        if name.isEmpty {
            errors.append(.emptySeriesName)
        }
        
        if count <= 0 {
            errors.append(.emptySeriesCount)
        }
        
        guard errors.isEmpty else {
            showValidationAlert()
            return
        }
        
        if let id {
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: id.stringValue, image: image)
            seriesRepository.updateSeries(id: id) { [weak self] series in
                guard let self else { return }
                series.name = name
                series.count = count
                series.amount = amount
                series.memo = memo
                
                // Realmオブジェクトのプロパティにリストで保持している場合はそのまま更新しようとすると
                // Object is already managed by another Realm. Use create instead to copy it into this Realm.となるため
                // series.locations = realmLocations ×
                // 以下のように明示的に更新・追加・削除を行う
                if locations.isEmpty {
                    // 変更対象が存在しない場合は明示的に空の配列を格納してリセット
                    series.locations = RealmSwift.List<Location>()
                } else {
                    // (1)既存のものがリストからなくなっている => 削除
                    // (2)既存のもの内容が更新されている      => 更新
                    // (3)既存のものに同じIDのものが存在しない => 追加
                    
                    // (1)既存のものがリストからなくなっている => 削除
                    let toRemove = series.locations.filter { location in
                        // Realmの比較は参照比較なので同じRelamインスタンスに属した同じものでないと一致しない
                        // そのためidなどで明示的に比較する必要がある
                        !locations.contains(where: { $0.id == location.id })
                    }
                    toRemove.forEach { location in
                        guard let index = series.locations.firstIndex(where: { $0.id == location.id }) else { return }
                        // 辞書から削除
                        series.locations.remove(at: index)
                    }
                    
                    // ローカルからも削除する
                    seriesRepository.deleteLocations(Array(toRemove))
                    
                    
                    locations.forEach { newLocation in
                        if let location = series.locations.first(where: { $0.id == newLocation.id }) {
                            // (2)既存のもの内容が更新されている      => 更新
                            location.name = newLocation.name
                            location.latitude = newLocation.latitude
                            location.longitude = newLocation.longitude
                        } else {
                            // (3)既存のものに同じIDのものが存在しない => 追加
                            series.locations.append(newLocation)
                        }
                    }
                }
                
                
                // 変更対象のが存在しない場合は明示的に空の配列を格納してリセット
                if categories.isEmpty {
                    series.categories = RealmSwift.List<Category>()
                } else {
                    // (1)既存のものがリストからなくなっている => 削除
                    // (2)既存のもの内容が更新されている      => 更新
                    // (3)既存のものに同じIDのものが存在しない => 追加
                    
                    // (1)既存のものがリストからなくなっている => 削除
                    let toRemove = series.categories.filter { category in
                        // Realmの比較は参照比較なので同じRelamインスタンスに属した同じものでないと一致しない
                        // そのためidなどで明示的に比較する必要がある
                        !categories.contains(where: { $0.id == category.id })
                    }
                    toRemove.forEach { category in
                        guard let index = series.categories.firstIndex(where: { $0.id == category.id }) else { return }
                        // 辞書から削除
                        series.categories.remove(at: index)
                    }
                    
                    // ローカルからも削除する
                    seriesRepository.deleteCategories(Array(toRemove))

                    
                    categories.forEach { newCategory in
                        if let category = series.categories.first(where: { $0.id == newCategory.id }) {
                            // (2)既存のもの内容が更新されている      => 更新
                            category.name = newCategory.name
                            category.colorHex = newCategory.colorHex
                        } else {
                            // (3)既存のものに同じIDのものが存在しない => 追加
                            series.categories.append(newCategory)
                        }
                    }
                }
                
                series.imagePath = path
                series.createdAt = Date()
                series.updatedAt = Date()
                showUpdateSuccessAlert = true
            }
        } else {
            
            let realmLocations = locations.toRealmList()
            let realmCategories = categories.toRealmList()
            
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

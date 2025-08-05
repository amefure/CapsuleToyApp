//
//  CapsuleToyEntryViewModel.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

import SwiftUI
import RealmSwift

final class CapsuleToyEntryViewModel: ObservableObject {
    
    private let seriesRepository: SeriesRepositoryProtocol

    @Published var showEntrySuccessAlert: Bool = false
    @Published var showUpdateSuccessAlert: Bool = false
    @Published var showValidationErrorAlert: Bool = false
    
    @Published private(set) var errorMsg: String = ""
    private var errors: [ValidationError] = []
    
    init(seriesRepository: SeriesRepositoryProtocol) {
        self.seriesRepository = seriesRepository
    }
    
    
    public func onAppear() {
   
    }
    
    public func onDisappear() {
        
    }
    
    /// 新規作成 or 更新処理
    public func createOrUpdateToy(
        seriesId: ObjectId,
        toyId: ObjectId?,
        name: String,
        isOwned: Bool,
        isSecret: Bool,
        memo: String,
        image: UIImage?,
        isGetAt: Date?
    ) {
        
        clearErrorMsg()
        
        if name.isEmpty {
            errors.append(.emptyItemName)
        }
        guard errors.isEmpty else {
            showValidationAlert()
            return
        }
        
        
        if let toyId {
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: toyId.stringValue, image: image)
            seriesRepository.updateCapsuleToy(toyId: toyId) { toy in
                toy.name = name
                toy.isOwned = isOwned
                toy.isSecret = isSecret
                toy.memo = memo
                toy.imagePath = path
                toy.isGetAt = isGetAt
            }
            showUpdateSuccessAlert = true
        } else {
            let toy = CapsuleToy()
            
            // 画像が存在すれば保存してパスを渡す
            let path: String? = saveImageForLocal(id: toy.id.stringValue, image: image)
            toy.name = name
            toy.isOwned = isOwned
            toy.isSecret = isSecret
            toy.memo = memo
            toy.imagePath = path
            toy.isGetAt = isGetAt
            seriesRepository.addCapsuleToy(
                seriesId: seriesId,
                toy: toy
            )
            showEntrySuccessAlert = true
        }
        
    }
    
    /// 画像を取得する
    public func fecthImage(id: String) -> UIImage? {
        let imageFileManager = ImageFileManager()
        return imageFileManager.loadImage(id)
    }
}


extension CapsuleToyEntryViewModel {
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

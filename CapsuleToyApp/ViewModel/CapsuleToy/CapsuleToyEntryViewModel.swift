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
        memo: String,
        image: Image?
    ) {
        if let toyId {
            seriesRepository.updateCapsuleToy(id: toyId) { toy in
                toy.name = name
                toy.isOwned = isOwned
                toy.memo = memo
                toy.imageDataPath = ""
                toy.createdAt = Date()
                toy.updatedAt = Date()
            }
            showUpdateSuccessAlert = true
        } else {
            let toy = CapsuleToy()
            toy.name = name
            toy.isOwned = isOwned
            toy.memo = memo
            toy.imageDataPath = ""
            toy.createdAt = Date()
            toy.updatedAt = Date()
            seriesRepository.addCapsuleToy(
                seriesId: seriesId,
                toy: toy
            )
            showEntrySuccessAlert = true
        }
        
    }
}


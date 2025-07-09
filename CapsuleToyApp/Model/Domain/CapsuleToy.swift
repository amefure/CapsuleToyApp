//
//  CapsuleToy.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Foundation
import RealmSwift

/// カプセルトイクラス
final class CapsuleToy: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    /// 所持フラグ
    @Persisted var isOwned: Bool = false
    /// メモ
    @Persisted var memo: String
    /// 画像パス
    @Persisted var imageDataPath: String?
    /// 生成日
    @Persisted var createdAt: Date = Date()
    /// 更新日
    @Persisted var updatedAt: Date = Date()
}

extension CapsuleToy {
    static func mockList(count: Int = 5) -> [CapsuleToy] {
        return (1...count).map { index in
            let toy = CapsuleToy()
            toy.id = ObjectId.generate()
            toy.name = "カプセルトイ No.\(index)"
            toy.isOwned = index % 2 == 0
            toy.memo = index % 3 == 0 ? "これはメモです" : ""
            toy.imageDataPath = index % 2 == 0 ? "/path/to/image\(index).png" : nil
            toy.createdAt = Date()
            toy.updatedAt = Date()
            return toy
        }
    }
}

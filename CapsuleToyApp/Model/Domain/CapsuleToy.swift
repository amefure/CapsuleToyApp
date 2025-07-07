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
    @Persisted var memo: String?
    /// 画像パス
    @Persisted var imageDataPath: String?
    /// 生成日
    @Persisted var createdAt: Date = Date()
    /// 更新日
    @Persisted var updatedAt: Date = Date()
}

//
//  Series.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Foundation
import RealmSwift

/// カプセルトイのシリーズ登録
final class Series: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    /// シリーズ名
    @Persisted var name: String
    /// アイテム数(手入力)
    @Persisted var count: Int
    /// 紐づいているカプセルトイ情報
    @Persisted var capsuleToys: RealmSwift.List<CapsuleToy>
    /// メモ
    @Persisted var memo: String?
    /// 生成日
    @Persisted var createdAt: Date = Date()
    /// 更新日
    @Persisted var updatedAt: Date = Date()
}

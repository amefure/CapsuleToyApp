//
//  Category.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//
import Foundation
import RealmSwift

final class Category: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    /// シリーズ名
    @Persisted var name: String
    /// 色
    @Persisted var color: String
}

//
//  Category.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//
import Foundation
import RealmSwift
import SwiftUI

final class Category: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    /// シリーズ名
    @Persisted var name: String
    /// 色
    @Persisted var colorHex: String = Color.exGold.toHexString()
}

extension Category {
    
    public var color: Color {
        Color(hexString: colorHex)
    }
}

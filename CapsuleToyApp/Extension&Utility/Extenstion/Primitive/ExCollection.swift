//
//  ExCollection.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import UIKit
import RealmSwift

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Object {
    /// `RealmList`に変換
    func toRealmList() -> List<Element> {
        let list = List<Element>()
        list.append(objectsIn: self)
        return list
    }
}

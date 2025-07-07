//
//  ExCollection.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import UIKit

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

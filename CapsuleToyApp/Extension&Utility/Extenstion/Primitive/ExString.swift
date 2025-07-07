//
//  ExString.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/28.
//

extension String {
    public func toInt() -> Int? {
        guard let num = Int(self) else { return nil }
        return num
    }
}


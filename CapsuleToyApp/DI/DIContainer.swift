//
//  DIContainer.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Swinject

final class DIContainer: @unchecked Sendable{
    static let shared = DIContainer()

    private let container = Container() { c in
    }


    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}


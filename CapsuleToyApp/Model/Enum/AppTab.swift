//
//  AppTab.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/10.
//

enum AppTab: Int, CaseIterable {
    case series = 1
    case toys = 2
    case settings = 3

    var title: String {
        switch self {
        case .series:
            return "ガチャガチャ"
        case .toys:
            return "MyData"
        case .settings:
            return "Setting"
        }
    }

    var icon: String {
        switch self {
        case .series:
            return "circle.bottomhalf.filled"
        case .toys:
            return "circle.hexagongrid"
        case .settings:
            return "gearshape.2.fill"
        }
    }
}

//
//  AppIconName.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/10.
//

import SwiftUI

/// アプリアイコン
enum AppIcon: String, CaseIterable {
    
    case red = "AppIconRed"
    case green = "AppIconGreen"
    case blue = "AppIconBlue"
    case yellow = "AppIconYellow"
    case purple = "AppIconPurple"
    case all = "AppIconAll"
    
    public var image: Image {
        return Image(rawValue + "Img")
    }
    
    public var title: String {
        return switch self {
        case .red:
            "Red"
        case .green:
            "Green"
        case .blue:
            "Blue"
        case .yellow:
            "Yellow"
        case .purple:
            "Purple"
        case .all:
            "All"
        }
    }
}

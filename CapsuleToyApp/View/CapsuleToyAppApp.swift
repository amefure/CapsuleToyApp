//
//  CapsuleToyAppApp.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/05.
//

import SwiftUI
import UIKit
import Swinject

class AppDelegate: UIResponder, UIApplicationDelegate {


}

@main
struct CapsuleToyAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

//
//  CapsuleToyAppApp.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/05.
//

import SwiftUI
import UIKit
import GoogleMobileAds
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // AdMob
        MobileAds.shared.start(completionHandler: nil)

        // Firebase
        FirebaseApp.configure()
        return true
    }
}

@main
struct CapsuleToyAppApp: App {
    @ObservedObject private var rootEnvironment = DIContainer.shared.resolve(RootEnvironment.self)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .environmentObject(rootEnvironment)
            }.preferredColorScheme(rootEnvironment.isDarkMode ? .dark : .light)
        }
    }
}

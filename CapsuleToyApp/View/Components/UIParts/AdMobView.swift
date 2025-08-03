//
//  AdMobView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/03.
//

import UIKit
import SwiftUI
import GoogleMobileAds


struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context _: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner) // インスタンスを生成
#if DEBUG
        banner.adUnitID = SecretAdMobConfig.BANNER_TEST_ID
#else
        banner.adUnitID = SecretAdMobConfig.BANNER_ID
#endif
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = windowScene?.windows.first!.rootViewController
        let request = Request()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.load(request)
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_: BannerView, context _: Context) {
        // 特にないのでメソッドだけ用意
    }
}

@MainActor
class Reward: NSObject, ObservableObject, FullScreenContentDelegate {
    // リワード広告を読み込んだかどうか
    @Published var rewardLoaded: Bool = false
    // リワード広告が格納される
    var rewardedAd: RewardedAd?

    override init() {
        super.init()
    }

    // リワード広告の読み込み
    func loadReward() {
        let request = Request()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
#if DEBUG
        let rewardCode = SecretAdMobConfig.REWORD_TEST_ID
#else
        let rewardCode = SecretAdMobConfig.REWORD_ID
#endif
        
        RewardedAd.load(with: rewardCode, request: request, completionHandler: { ad, error in
            if let _ = error {
                // 読み込みに失敗しました
                self.rewardLoaded = false
                return
            }
            // 読み込みに成功しました
            self.rewardLoaded = true
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }

    // 読み込んだリワード広告を表示するメソッド
    func showReward() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        if let ad = rewardedAd {
            ad.present(from: rootVC!, userDidEarnRewardHandler: {
                // 報酬を獲得
                self.rewardLoaded = false
            })
        } else {
            rewardLoaded = false
            loadReward()
        }
    }
}

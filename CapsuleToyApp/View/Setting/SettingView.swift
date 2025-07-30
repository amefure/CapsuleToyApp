//
//  SettingView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/18.
//

import SwiftUI

struct SettingView: View {
    
    private var viewModel = SettingViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    
    var body: some View {
        VStack {
            
            Text("設定")
                .fontM(bold: true)
            
            List {
                // MARK: アプリ設定
                Section(
                    header: Text(L10n.settingSectionApp)
                ) {
                    
                    HStack {
                        Image(systemName: "questionmark.app")
                            .settingIcon()
                        
                        Toggle(isOn: $rootEnvironment.isDarkMode) {
                            Text(L10n.settingSectionAppMode)
                        }.tint(.exThema)
                    }.listRowHeight()
                    
                    // よくある質問
                    NavigationLink {
                        //FaqListView()
                          //  .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.app")
                                .settingIcon()
                            Text(L10n.settingSectionAppFaq)
                        }
                    }.listRowHeight()
                    
                    // アプリ内課金
                    NavigationLink {
                        //InAppPurchaseView()
                           // .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Image(systemName: "app.gift.fill")
                                .settingIcon()
                            Text(L10n.settingSectionAppPurchase)
                        }
                    }.listRowHeight()
                    
                }
                
                
                // MARK: Link
                Section(
                    header: Text(L10n.settingSectionLinkTitle),
                    footer: Text(L10n.settingSectionLinkDesc)
                        .fontS(bold: true)
                ) {
                    
                    if let url = URL(string: StaticUrls.APP_REVIEW_URL) {
                        // 1:レビューページ
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "hand.thumbsup")
                                    .settingIcon()
                                Text(L10n.settingSectionLinkReview)
                                
                            }
                        }).listRowHeight()
                    }
                    // 2:シェアボタン
                    Button {
                        viewModel.shareApp(
                            shareText: L10n.settingSectionLinkShareText,
                            shareLink: StaticUrls.APP_URL
                        )
                    } label: {
                        HStack {
                            Image(systemName: "star.bubble")
                                .settingIcon()
                            Text(L10n.settingSectionLinkRecommend)
                        }
                    }.listRowHeight()
                    
                    if let url = URL(string: StaticUrls.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        NavigationLink {
                            ControlWebView(url: url)
                        } label: {
                            HStack {
                                Image(systemName: "paperplane")
                                    .settingIcon()
                                Text(L10n.settingSectionLinkContact)
                            }
                        }.listRowHeight()
                    }
                    
                    if let url = URL(string: StaticUrls.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        NavigationLink {
                            ControlWebView(url: url)
                        } label: {
                            HStack {
                                Image(systemName: "note.text")
                                    .settingIcon()
                                Text(L10n.settingSectionLinkTerms)
                            }
                        }.listRowHeight()
                    }
                }
                
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        BoingButton {
                            
                        } label: {
                            Asset.Images.appicon.swiftUIImage
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(.exThema)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
                                .padding(.bottom, 8)
                        }

                        Text(L10n.appFeatures)
                        Text(L10n.appName + L10n.appVersion(viewModel.getVersion()))
                        Text(L10n.appCopyright)
                    }.fontSS()
                    Spacer()
                }.listRowBackground(Color.clear)
            }
        }.fontM(bold: true)
            .foregroundStyle(.exModeText)
    }
}

private extension View {
    func listRowHeight(height: CGFloat = 37) -> some View {
        frame(height: height)
    }
    
    func settingIcon() -> some View {
        return self
            .foregroundStyle(.exThema)
            .frame(width: 30)
    }
}

#Preview {
    SettingView()
}

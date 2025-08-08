//
//  RootView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/05.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var rootEnvironment = DIContainer.shared.resolve(RootEnvironment.self)
    @Namespace private var tabAnimation
    var body: some View {
        ZStack(alignment: .bottom) {
            switch rootEnvironment.selectedTab {
            case .series:
                SeriesListScreen()
                    .environmentObject(rootEnvironment)
                    .padding(.bottom, DeviceSizeUtility.isSESize ? 70 : 110) // TabBar Space
            case .mydata:
                MyDataScreen()
                    .environmentObject(rootEnvironment)
                    .padding(.bottom, DeviceSizeUtility.isSESize ? 70 : 110) // TabBar Space
            case .settings:
                SettingView()
                    .environmentObject(rootEnvironment)
                    .padding(.bottom, DeviceSizeUtility.isSESize ? 70 : 110) // TabBar Space
            }
                        
            CustomTabBar(
                tabAnimation: tabAnimation
            ).environmentObject(rootEnvironment)
        
        }.onAppear { rootEnvironment.onAppear() }
            .background(.exFoundation)
            .ignoresSafeArea(edges: [.bottom])
            .alert(
                isPresented: $rootEnvironment.showLocationDeniedAlert,
                title: L10n.dialogNoticeTitle,
                message: L10n.dialogDeniedLocationMsg,
                positiveButtonTitle: L10n.dialogOpenSettingTitle,
                negativeButtonTitle: L10n.cancel,
                positiveAction: {
                    rootEnvironment.openSetiing()
                }
            )
    }
}

#Preview {
    RootView()
}

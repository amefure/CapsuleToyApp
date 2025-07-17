//
//  CustomTabBar.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/10.
//

import SwiftUI

// MARK: - カスタムタブバー
struct CustomTabBar: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    @Binding var selectedTab: AppTab
    var tabAnimation: Namespace.ID

    var body: some View {
        HStack {
            ForEach(AppTab.allCases, id: \.self) { tab in
                BoingButton {
                    withAnimation {
                        selectedTab = tab
                    }
                    rootEnvironment.setActiveTab(tab)
                } label: {
                    VStack {
                        Image(systemName: tab.icon)
                            .fontL(bold: true)
                            .foregroundColor(selectedTab == tab ? .accent : .gray)
                        
                        Text(tab.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab ? .accent : .gray)

                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 100, height: 3)
                                .foregroundStyle(.accent)
                                .matchedGeometryEffect(id: "underline", in: tabAnimation)
                        } else {
                            Color.clear.frame(height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, DeviceSizeUtility.isSESize ? 5 :  40)
        .background(.exModeBase)
        .clipped()
        .shadow(color: .black.opacity(0.2), radius: 5, x: -3, y: -3)
    }
}


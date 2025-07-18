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
                Button {
                    withAnimation {
                        selectedTab = tab
                    }
                    rootEnvironment.setActiveTab(tab)
                } label: {
                    VStack(spacing: 0) {
                        
                        if selectedTab == tab {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.exThema)
                                .matchedGeometryEffect(id: "underline", in: tabAnimation)
                                .offset(y: -15)
                        } else {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.clear)
                                .offset(y: -15)
                        }
                        
                        Image(systemName: tab.icon)
                            .fontM(bold: true)
                            .foregroundStyle(selectedTab == tab ? .accent : .gray)
                        
                        Text(tab.title)
                            .font(.caption)
                            .foregroundStyle(selectedTab == tab ? .accent : .gray)
                       
                    }.frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.bottom, DeviceSizeUtility.isSESize ? 0 :  20)
        .background(.exModeBase)
        .clipped()
        .shadow(color: .black.opacity(0.2), radius: 5, x: -3, y: -3)
    }
}


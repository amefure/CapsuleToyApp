//
//  DataEmptyView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/04.
//

import SwiftUI

struct DataEmptyView: View {
    public let title: String = "データが存在しません"
    
    var body: some View {
        VStack {
            Spacer()
            
            Asset.Images.appiconNotext.swiftUIImage
                .resizable()
                .frame(width: 180, height: 180)
            
            Text(title)
                .fontM(bold: true)
                .foregroundStyle(.exModeText)
            Spacer()
        }
    }
}

#Preview {
    DataEmptyView()
}

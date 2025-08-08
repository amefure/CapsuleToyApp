//
//  DataEmptyView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/08/04.
//

import SwiftUI

struct DataEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Asset.Images.appiconNotext.swiftUIImage
                .resizable()
                .frame(width: 180, height: 180)
            
            Text("データが存在しません")
                .fontM(bold: true)
                .foregroundStyle(.exText)
            Spacer()
        }
    }
}

#Preview {
    DataEmptyView()
}

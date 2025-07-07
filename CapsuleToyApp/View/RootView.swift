//
//  RootView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/05.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        VStack {
            NavigationLink {
                SeriesListScreen()
            } label: {
                Text("SeriesListScreen")
            }
        }
        .padding()
    }
}

#Preview {
    RootView()
}

//
//  ControlWebView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/18.
//

import SwiftUI

//// Swift UIでWebViewを操作するための枠View
struct ControlWebView: View {
    
    // MARK: - Receive
    public var url: URL
    private let uICustomWebView: UICustomWebView!

    // MARK: - Initializa
    init(url: URL) {
        self.url = url
        uICustomWebView = UICustomWebView(url: url)
    }

    // MARK: - Environment
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .fontM()
                }.frame(width: 40)

                Spacer()
            }.padding(8)

            uICustomWebView

            HStack(spacing: 0) {
                Button {
                    uICustomWebView.goBack()
                } label: {
                    Image(systemName: "chevron.backward")
                        .fontM()
                }.frame(width: 40)

                Button {
                    uICustomWebView.goForward()
                } label: {
                    Image(systemName: "chevron.forward")
                        .fontM()
                }.frame(width: 40)

                Spacer()

                Button {
                    uICustomWebView.openBrowser()
                } label: {
                    Image(systemName: "network")
                        .fontM()
                }.frame(width: 40)

                Button {
                    uICustomWebView.reload()
                } label: {
                    Image(systemName: "goforward")
                        .fontM()
                }.frame(width: 40)
            }.padding(10)
                .padding(.horizontal)

        }.background(.white)
            .foregroundStyle(.black)
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    ControlWebView(url: URL(string: "https://appdev-room.com/")!)
}

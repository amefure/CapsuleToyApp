//
//  LocationInputScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/15.
//

import SwiftUI
import MapKit

struct LocationInputScreen: View {

    @StateObject private var viewModel = DIContainer.shared.resolve(LocationInputViewModel.self)
    
    @Binding public var locationDic: [String: Location]
    @State private var name: String = ""
    @State private var coordinate: CLLocationCoordinate2D?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "checkmark",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    guard let location = viewModel.createLocation(
                        coordinate: coordinate,
                        name: name
                    ) else { return }
                    locationDic.updateValue(location, forKey: location.id.stringValue)
                    dismiss()
                }
            )
            
            Spacer()
            
            Text("場所名")
                .exInputLabelView()
               
            
            TextField("例：イオンモール〇〇店 3F", text: $name)
                .exInputBackView()
            
            MapReader { proxy in
                Map(position: $viewModel.region) {
                    // ユーザー現在位置にアノテーション表示
                    UserAnnotation(anchor: .center) { userLocation in
                        Image(systemName: "figure.wave.circle.fill")
                            .fontL(bold: true)
                            .foregroundStyle(.exThema)
                    }
                    
                    if let coordinate = coordinate {
                        Marker(coordinate: coordinate) {
                            Text("選択中")
                        }.tint(.exThema)
                    }
                }.onTapGesture { position in
                    guard let selectedCoordinate = proxy.convert(position, from: .local) else { return }
                    coordinate = selectedCoordinate
                }
            }.mapControls {
                // 現在位置に戻るボタン
                MapUserLocationButton()
            }
            

            Spacer()
        }.onAppear {
            viewModel.observeUserLocation()
        }.onDisappear { viewModel.clearObserveUserLocation() }
        .navigationBarBackButtonHidden()
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .overlayErrorViewDialog(
                isPresented: $viewModel.showValidationErrorAlert,
                title: L10n.dialogErrorTitle,
                message: viewModel.errorMsg
            )
    }
}

#Preview {
    LocationInputScreen(locationDic: Binding.constant([:]))
}

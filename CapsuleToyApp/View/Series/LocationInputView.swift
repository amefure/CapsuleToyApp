//
//  LocationInputView.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/15.
//

import SwiftUI
import MapKit

struct LocationInputView: View {

    @EnvironmentObject var viewModel: SeriesEntryViewModel
    
    @State private var location: Location = Location()
    @State private var name: String = "Test"
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
                    let result = viewModel.addLocation(
                        coordinate: coordinate,
                        name: name,
                        location: location
                    )
                    if result {
                        dismiss()
                    }
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
                        }
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
            location = Location()
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
    LocationInputView()
}

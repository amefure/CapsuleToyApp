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
    @Binding var isPresented: Bool
    @Binding var locationDic: [String: Location]
    
    @State private var location: Location = Location()
    @State private var name: String = ""
    
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var showErrorAlert = false
    
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
                    guard let coordinate,
                          !name.isEmpty
                    else {
                        showErrorAlert = true
                        return
                    }
                    location.name = name
                    location.latitude = coordinate.latitude
                    location.longitude = coordinate.longitude
                    locationDic.updateValue(location, forKey: location.id.stringValue)
                    isPresented = false
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
            name = location.name
            viewModel.observeUserLocation()
        }.onDisappear { viewModel.clearObserveUserLocation() }
        .navigationBarBackButtonHidden()
            .padding(.horizontal)
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .overlayErrorViewDialog(
                isPresented: $showErrorAlert,
                title: L10n.dialogErrorTitle,
                message: "エラーだよ"
            )
    }
}

//#Preview {
//    LocationInputView(
//        isPresented: Binding.constant(false),
//        viewModel: EntryOiwaiUserViewModel(),
//        childrenDic: Binding.constant([:])
//    ).environmentObject(RootEnvironment())
//}


//private struct SelectTabPickerView: View {
//    @Namespace private var tabAnimation
//    @Binding var selectTab: HistoryTab
//    var body: some View {
//        HStack {
//            
//            ForEach(HistoryTab.allCases, id: \.self) { tab in
//                Button {
//                    selectTab = tab
//                } label: {
//                  
//                    ZStack {
//                        if selectTab == tab {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: (DeviceSizeUtility.deviceWidth / 2) - 20, height: 30)
//                                .foregroundStyle(.exThema)
//                                .matchedGeometryEffect(id: "block", in: tabAnimation)
//                        } else {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: (DeviceSizeUtility.deviceWidth / 2) - 20, height: 30)
//                                .foregroundColor(.clear)
//                        }
//                        
//                        Image(systemName: tab.imageName)
//                            .frame(width: (DeviceSizeUtility.deviceWidth / 2) - 20, height: 30)
//                            .foregroundStyle(selectTab == tab ? .white : .exThema)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                }
//            }
//        }.background(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
//    }
//}
//

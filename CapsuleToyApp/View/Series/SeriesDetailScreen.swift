//
//  SeriesDetailScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/08.
//

import SwiftUI
import RealmSwift
import MapKit

struct SeriesDetailScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesDetailViewModel.self)
    
    public var seriesId: ObjectId
    @State private var selectToy: CapsuleToy? = nil
    private let grids = Array(repeating: GridItem(.fixed(itemWidth)), count: 2)
    
    @State private var presentEditView: Bool = false
    
    private let df = DateFormatUtility(dateFormat: "yyyy年M月d日")
    
    static private let itemWidth: CGFloat = DeviceSizeUtility.deviceWidth / 2 - 20

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "pencil",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    presentEditView = true
                }
            )
            
            if let series = viewModel.series {
                
                ScrollView(showsIndicators: false) {
                    
                    Text(series.name)
                        .fontL(bold: true)
                        .lineLimit(2)
                        .exInputBackView()
                    
                   
                    ToysRatingListView(
                        isOwnedCount: series.isOwendToysCount,
                        maxCount: series.highCount
                    ).padding(.vertical)
                   
                    
                    Map(position: $viewModel.region) {
                        // ユーザー現在位置にアノテーション表示
                        UserAnnotation(anchor: .center) { userLocation in
                            Image(systemName: "figure.wave.circle.fill")
                                .fontL(bold: true)
                                .foregroundStyle(.exThema)
                        }
                        
                        ForEach(series.locations) { location in
                            if let coordinate = location.coordinate {
                                Marker(coordinate: coordinate) {
                                    Text(location.name)
                                }
                            }
                        }
                        
                    }.mapControls {
                        // 現在位置に戻るボタン
                        MapUserLocationButton()
                    }.frame(height: 250)
                    
                    HStack {
                        Text("コレクション")
                        Spacer()
                        
                        BoingButton {
                            viewModel.presentEntryToyScreen = true
                        } label: {
                            Image(systemName: "plus")
                                .exCircleButtonView()
                        }
                    }.exInputLabelView()
                        .padding(.vertical)
                    
                    LazyVGrid(columns: grids) {
                        ForEach(series.capsuleToys) { toy in
                            BoingButton {
                                selectToy = toy
                                viewModel.presentEntryToyScreen = true
                            } label: {
                                VStack {
                                    ImagePreView(
                                        photoPath: toy.imageDataPath,
                                        width: SeriesDetailScreen.itemWidth,
                                        height: SeriesDetailScreen.itemWidth,
                                        isNotView: true,
                                        isEnablePopup: false
                                    )
                                    Text(toy.name)
                                    Text(toy.memo)
                                }.frame(width: SeriesDetailScreen.itemWidth, height: SeriesDetailScreen.itemWidth)
                                    .background(.exThema)
                            }.clipped()
                        }.foregroundStyle(.white)
                    }.id(UUID()) // モックの場合のみ必要かも(新規追加後に再描画されないため)
                    
                    BoingButton {
                        viewModel.showConfirmDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .exCircleButtonView()
                    }
                    
                }.navigationDestination(isPresented: $presentEditView) {
                    SeriesEntryScreen(series: series)
                }
            }
            
            Spacer()
            
            
        }.onAppear {
            selectToy = nil
            viewModel.onAppear(id: seriesId)
        }.onDisappear { viewModel.onDisappear() }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true) // Mapがある場合これを明示的に指定する必要がある
            .padding(.horizontal)
            .fontM()
            .foregroundStyle(.exText)
            .background(.exFoundation)
            .navigationDestination(isPresented: $viewModel.presentEntryToyScreen, destination: {
                CapsuleToyEntryScreen(seriesId: seriesId, toy: selectToy)
            })
            .alert(
                isPresented: $viewModel.showConfirmDeleteAlert,
                title: L10n.dialogConfirmTitle,
                message: L10n.dialogDeleteConfirmMsg,
                positiveButtonTitle: L10n.delete,
                negativeButtonTitle: L10n.cancel,
                positiveButtonRole: .destructive,
                negativeButtonRole: .cancel,
                positiveAction: {
                    viewModel.deleteSeries()
                }
            ).alert(
                isPresented: $viewModel.showSuccessDeleteAlert,
                title: L10n.dialogSuccessTitle,
                message: L10n.dialogDeleteMsg,
                positiveButtonTitle: L10n.ok,
                positiveAction: {
                    dismiss()
                }
            ).alert(
                isPresented: $viewModel.showFaieldDeleteAlert,
                title: L10n.dialogErrorTitle,
                message: L10n.dialogDeleteFailedMsg,
                positiveButtonTitle: L10n.ok,
            )
    }
}

#Preview {
    SeriesDetailScreen(seriesId: ObjectId())
}



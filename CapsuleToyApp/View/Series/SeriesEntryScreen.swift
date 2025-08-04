//
//  SeriesEntryScreen.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import SwiftUI
import MapKit

struct SeriesEntryScreen: View {
    
    @StateObject private var viewModel = DIContainer.shared.resolve(SeriesEntryViewModel.self)
    
    public var series: Series? = nil
    
    @State private var name: String = ""
    @State private var count: String = ""
    @State private var amount: String = ""
    @State private var memo: String = ""
    @State private var image: UIImage? = nil

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
                    viewModel.createOrUpdateSeries(
                        id: series?.id,
                        name: name,
                        count: count.toInt() ?? 0,
                        amount: amount.toInt() ?? 0,
                        memo: memo,
                        locations: viewModel.locationDic.map { $0.value },
                        categories: viewModel.categoryDic.map { $0.value },
                        image: image
                    )
                }
            )
            
            ScrollView(showsIndicators: false) {
                
                HStack(alignment: .top) {
                    ImageSelectView(image: $image, isDisplayedCropView: true)
                        .padding(.vertical)
                    
                    VStack {
    
                        Text("金額")
                            .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        
                        HStack(alignment: .bottom) {
                            TextField("例：300円", text: $amount)
                                .keyboardType(.numberPad)
                            Text("／円")
                                .fontS(bold: true)
                                .opacity(0.5)
                        }.exInputBackView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        
                        Spacer()
                        
                        Text("種類数")
                            .exInputLabelView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                       
                        HStack(alignment: .bottom) {
                            TextField("例：6種類", text: $count)
                                .keyboardType(.numberPad)
                            Text("／種類")
                                .fontS(bold: true)
                                .opacity(0.5)
                        }.exInputBackView(width: DeviceSizeUtility.deviceWidth / 2 - 20)
                        Spacer()
                    }
                   
                }
                
                Text("シリーズ名")
                    .exInputLabelView()
                TextField("例：△△シリーズ", text: $name)
                    .exInputBackView()
                
                Text("カテゴリラベル")
                    .exInputLabelView()
                
                let categoryDic = viewModel.categoryDic.sorted(by: { $0.key < $1.key }).map { $0.value }
                ScrollView(.horizontal) {
                    HStack(spacing: 30) {
                        ForEach(categoryDic, id: \.id) { category in
                            ZStack(alignment: .topTrailing) {
                                Text(category.name)
                                    .exThemaLabelView(backgroundColor: category.color)
                                
                                Button {
                                    viewModel.deleteCategoryDic(category)
                                } label: {
                                    Image(systemName: "trash")
                                        .fontSS(bold: true)
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.white)
                                        .background(.exNegative)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }.offset(x: 15, y: -15)
                            }
                        }
                        
                        Button {
                            viewModel.showAddCategoryScreen = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.exGold)
                                .frame(width: 70, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.exGold, lineWidth: 2)
                                ).padding(.vertical, 20)
                        }
                    }
                }.padding()
                
   
                
                Text("ガチャガチャ設置場所")
                    .exInputLabelView()
                
                let dicList = viewModel.locationDic.sorted(by: { $0.key < $1.key }).map { $0.value }
                ForEach(dicList, id: \.id) { location in
                    HStack {
                        Image(systemName: location.coordinate == nil ? "map" : "map.fill")
                            .foregroundStyle(location.coordinate == nil ? .exText : .exThema)
                            .fontM(bold: true)
                        Text(location.name)
                            .fontL(bold: true)
                        Spacer()
                        
                        Button {
                            viewModel.deleteLocationDic(location)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.exNegative)
                                .fontM()
                        }
                    }.frame(width: DeviceSizeUtility.deviceWidth - 40, height: 35)
                }
                Button {
                    viewModel.showAddLocationScreen = true
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(.exGold)
                        .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.exGold, lineWidth: 2)
                        )
                }
                
                
                Text("MEMO")
                    .exInputLabelView()
                TextEditor(text: $memo)
                    .frame(height: 100)
                    .exInputBackView()
            }

        }.onAppear {
            viewModel.onAppear()
            guard let series else { return }
            name = series.name
            count = String(series.count)
            amount = String(series.amount)
            memo = series.memo
            viewModel.updateLocationDic(locations: series.locations)
            viewModel.updateCategoryDic(categories: series.categories)
            image = viewModel.fecthImage(id: series.id.stringValue)
        }
        .onDisappear { viewModel.onDisappear() }
        .navigationBarBackButtonHidden()
        .fontM()
        .foregroundStyle(.exText)
        .background(.exFoundation)
        .fullScreenCover(isPresented: $viewModel.showAddLocationScreen) {
            LocationInputScreen(locationDic: $viewModel.locationDic)
        }
        .fullScreenCover(isPresented: $viewModel.showAddCategoryScreen) {
            CategoryInputScreen(categoryDic: $viewModel.categoryDic)
        }
        .alert(
            isPresented: $viewModel.showEntrySuccessAlert,
            title: L10n.dialogSuccessTitle,
            message: L10n.dialogEntryMsg(name),
            positiveButtonTitle: L10n.ok,
            positiveAction: {
                dismiss()
            }
        ).alert(
            isPresented: $viewModel.showUpdateSuccessAlert,
            title: L10n.dialogSuccessTitle,
            message: L10n.dialogUpdateMsg,
            positiveButtonTitle: L10n.ok,
            positiveAction: {
                dismiss()
            }
        ).overlayErrorViewDialog(
            isPresented: $viewModel.showValidationErrorAlert,
            title: L10n.dialogErrorTitle,
            message: viewModel.errorMsg
        )
    }
}

#Preview {
    SeriesEntryScreen()
}

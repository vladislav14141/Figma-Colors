//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum FigmaContentType: String, CaseIterable {
    case all
    case colors
    case gradients
    case images
}

struct FigmaController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: FigmaViewModel = FigmaViewModel()

    let lazyStackSpacing: CGFloat = 16

    let gradientColumns = [
        GridItem(.flexible(minimum: 200, maximum: 640), spacing: 16)
    ]
    
    // MARK: - Private Properties
    private let figmaTokenURL = URL(string: "https://www.figma.com/")!
    private var types = FigmaContentType.allCases.map({$0.rawValue})
    private var exportTypes: [ExportModel]
    
    @State var currentType: String = FigmaContentType.colors.rawValue
    @State var currentExportTypeId: Int = 0
    @State var currentExportType: ExportModel
    @State var showSettings = false
    

    // MARK: - Lifecycle
    init() {
        let array = [IOSExportModel(), IOSAssetsExportModel()]
        exportTypes = array
        self._currentExportType = State(wrappedValue: array[0])
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                Picker("Type", selection: $currentType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                ScrollView {
                    ColorsPage(items: $viewModel.figmaColors).isHidden(!(currentType == FigmaContentType.colors.rawValue || currentType == FigmaContentType.all.rawValue))
                    GradientsPage(items: $viewModel.figmaGradient).isHidden(!(currentType == FigmaContentType.gradients.rawValue || currentType == FigmaContentType.all.rawValue))
                    ComponentsPage(items: $viewModel.figmaImages).isHidden(!(currentType == FigmaContentType.images.rawValue || currentType == FigmaContentType.all.rawValue))
                    MockPage().isHidden(!viewModel.isLoading)
                }
                HStack {
                    Text("\(viewModel.figmaColors.count) colors").font(.subheadline)
                    Text("\(viewModel.figmaGradient.count) gradients").font(.subheadline)

                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            InfoView()
                .background(Color.secondaryBackground).cornerRadius(8)
        }
        .padding()
        .popover(isPresented: $viewModel.showSettings, content: {
            SettingsController()
        })
        .sheet(isPresented: $viewModel.showCode, content: {
            CodeController(viewModel: .init(block: FigmaBlocks(colors: viewModel.figmaColors)))
        })
        .onAppear {
            viewModel.getData()
        }.background(Color.primaryBackground)
        
        // MARK: - Public methods
        
        // MARK: - Private Methods
        
    }
    
    @ViewBuilder func InfoView() -> some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        MRButton(iconName: "gearshape", title: nil, enabled: true) {
                            viewModel.showSettings = true
                        }.frame(width: 32)
                    }
                    
                    MRTextfield(title: "Figma access token", placeholder: "165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", text: $viewModel.figmaToken)
                    
                    Group {
                        MRTextfield(title: "Figma LIGHT theme URL", placeholder: "ulzno6iXBBVlvMog2k6XsX", text: $viewModel.fileKeyLight)
                        MRTextfield(title: "Figma DARK theme URL", placeholder: "GQz3OLZgxac5doTwkzTRM6", text: $viewModel.fileKeyDark)
                        MRButton(iconName: "repeat.circle", title: "Update", enabled: true) {
                            viewModel.getData()
                        }
                    }
                }
                
                VStack {
                    Picker("Export type", selection: $currentExportTypeId) {
                        ForEach(0..<exportTypes.count, id: \.self) {
                            Text(exportTypes[$0].title)
                        }
                    }.onChange(of: currentExportTypeId, perform: { value in
                        currentExportType = exportTypes[value]
                    })
                    
                    HStack(spacing: 16) {
                        ForEach(currentExportType.buttons, id: \.title) { bt in
                            MRButton(iconName: "folder.circle.fill", title: bt.title, enabled: true) {
                                bt.handle()
                            }
                        }
                    }
                }
                Spacer()
            }.frame(minWidth: 100, maxWidth: 300).padding()
        }
    }
}



//struct FigmaGradientCellItem2: View {
//    let gradientItem: GradientItem
//    let sheme: FigmaSheme
//    var body: some View {
//        VStack {
//            Text("").font(.headline).foregroundColor(.label)
//
//            VStack(spacing: 0) {
//                if let light = gradientItem.gradientLight, sheme == .light {
//                    LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
//                        Text("Light").font(.footnote)
//                    ).foregroundColor(light.stops.first?.color.labelText())
//                }
//                
//                if let dark = gradientItem.gradientDark, sheme == .dark {
//                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
//                        Text("Dark").font(.footnote)
//                    ).foregroundColor(dark.stops.first?.color.labelText())
//                }
//            }
//            .cornerRadius(16)
//            .frame(height: 120)
//        }
//        .padding(.horizontal,4)
//    }
//}



struct FigmaController_Previews: PreviewProvider {
    static var previews: some View {
        FigmaController()
    }
}

//
//  InfoPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import SwiftUI

struct InfoPage: View {
    
    @StateObject var viewModel: FigmaViewModel
    @State private var currentExportType: ExportModel?
    private let figmaTokenURL = URL(string: "https://www.figma.com/")!
    
    @State var exportModels = [IOSExportModel(), IOSAssetsExportModel()]
    @State var selectedExportModel = 0
    
    init(viewModel: FigmaViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.currentExportType = exportModels[selectedExportModel]
    }
    
    var body: some View {
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
                    Picker("Export type", selection: $selectedExportModel) {
                        ForEach(0..<exportModels.count, id: \.self) { i in
                            Text(exportModels[i].title).tag(i)
                        }
                    }.onChange(of: selectedExportModel, perform: { i in
                        self.currentExportType = exportModels[i]
                    })
                    
                    HStack(spacing: 16) {
                        if let buttons = currentExportType?.buttons {
                            ForEach(buttons, id: \.id) { bt in
                                 bt
                            }
                        }
                    }
                }
                Spacer()
            }.frame(minWidth: 100, maxWidth: 300).padding()
        }.background(Color.secondaryBackground).cornerRadius(8)
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage(viewModel: FigmaViewModel())
    }
}

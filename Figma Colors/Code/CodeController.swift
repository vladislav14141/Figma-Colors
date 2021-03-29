//
//  CodeController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021. All rights reserved.
//

import SwiftUI

struct CodeController: View {
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Public Properties
    @StateObject private var viewModel: CodeViewModel
    // MARK: - Private Properties
    var figmaBlock: FigmaBlocks {
        viewModel.figmaColors
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: CodeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        return VStack {
            HStack {
                Spacer()
                Toggle("Использовать шапку?", isOn: $viewModel.head)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            }
            HStack {
                VStack {
                    Text("UIKit").font(.title).bold()
                    TextEditor(text: $viewModel.uikit)
                }
                
                VStack {
                    Text("SwiftUI").font(.title).bold()
                    TextEditor(text: $viewModel.swiftui)
                }
                

            }.onAppear {
                viewModel.uikit = viewModel.generateUIKit(useHead: viewModel.head)
                viewModel.swiftui = viewModel.generateSwiftUI(useHead: viewModel.head)

            }.frame(minWidth: 600, idealWidth: 1000, maxWidth: .infinity, minHeight: 600, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
        }.padding()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct CodeController_Previews: PreviewProvider {
    static var previews: some View {
        CodeController(viewModel: .init(block: FigmaBlocks(colors: [])))
    }
}

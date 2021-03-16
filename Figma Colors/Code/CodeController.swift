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
    @StateObject private var viewModel: CodeViewModel = CodeViewModel()
    // MARK: - Private Properties
    let figmaColors: [FigmaColor]
    // MARK: - Lifecycle
    
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
                viewModel.figmaColors = figmaColors
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
        CodeController(figmaColors: [])
    }
}

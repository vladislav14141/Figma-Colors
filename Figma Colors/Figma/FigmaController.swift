//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum FigmaContentType: String, CaseIterable, Equatable, Identifiable {
    var id: String { rawValue }
    case all
    case colors
    case gradients
    case images
}

struct FigmaController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: FigmaViewModel = FigmaViewModel()

    @State var currentType: FigmaContentType = .colors

    // MARK: - Private Properties    
    @State var showSettings = false
    

    // MARK: - Lifecycle
    init() {

    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                Picker("Type", selection: $currentType) {
                    ForEach(FigmaContentType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }

                ContentPage(viewModel: viewModel, currentType: $currentType)
                HStack {
                    Text("\(viewModel.figmaColors.count) colors").font(.subheadline)
                    Text("\(viewModel.figmaGradient.count) gradients").font(.subheadline)

                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
//            InfoPage(viewModel: viewModel)
                
        }
        .padding()
        .popover(isPresented: $viewModel.showSettings, content: {
            SettingsController()
        })
        .sheet(isPresented: $viewModel.showCode, content: {
//            CodeController(viewModel: .init(block: FigmaBlocks(colors: viewModel.figmaColors)))
        })
        .onAppear {
            viewModel.getData()
        }.background(Color.primaryBackground)
        
        // MARK: - Public methods
        
        // MARK: - Private Methods
        
    }
}


struct FigmaController_Previews: PreviewProvider {
    static var previews: some View {
        FigmaController()
    }
}


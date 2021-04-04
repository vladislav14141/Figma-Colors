//
//  SettingsController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 30.03.2021. All rights reserved.
//

import SwiftUI


struct SettingsController: View {
    
    // MARK: - Public Properties

    // MARK: - Private Properties
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    let namecases = [NameCase.camelcase, NameCase.snakecase]
    // MARK: - Lifecycle
    init() {

    }
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    MRButton(iconName: "xmark", title: nil) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Picker("Name case", selection: $viewModel.nameCase) {
                    ForEach(NameCase.allCases, id: \.self) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                
                
                
                HStack {
                    MRTextfield(title: "Separate gradient colors by", placeholder: "-", text: $viewModel.gradientSeparator)
                }
            }.padding()
        }.frame(minWidth: 300, idealWidth: 500, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct SettingsController_Previews: PreviewProvider {
    static var previews: some View {
        SettingsController()
    }
}



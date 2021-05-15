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
    @Binding var settingOpened: Bool
    @EnvironmentObject var storage: FigmaStorage

    // MARK: - Lifecycle
    
    var body: some View {
        
        HStack {
            Spacer()
            RSTButton(iconName: "xmark", appereance: .primaryOpacity2) {
                withAnimation {
                    settingOpened = false
                }
            }.frame(width: 44, height: 44)
        }
        MRTextfield(title: "Separate gradient colors by", placeholder: "-", text: $storage.gradientSeparator)
        
        Picker("Name case", selection: $storage.nameCase) {
            ForEach(NameCase.allCases, id: \.self) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct SettingsController_Previews: PreviewProvider {
    static var previews: some View {
        SettingsController(settingOpened: .constant(true))
    }
}



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
            }.padding(.bottom)
                
        MRTextfield(title: "Fill separator", placeholder: "-", text: $storage.gradientSeparator)
        
        Picker("Name case", selection: $storage.nameCase) {
            ForEach(NameCase.allCases, id: \.self) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
        Spacer()
                RSTButton(iconName: "paperplane", title: "Suggest a feature", enabled: true, loading: nil, appereance: .primaryOpacity2) {
                    let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
                    service.recipients = ["cappreem@yandex.ru"]
                    service.subject = "Figma Assets feature"
                    
                    service.perform(withItems: [])
                }
                
                RSTButton(iconName: "exclamationmark.triangle", title: "Report a bug", enabled: true, loading: nil, appereance: .primaryOpacity2) {
                    let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
                    service.recipients = ["cappreem@yandex.ru"]
                    service.subject = "Figma Assets bug"
                    
                    service.perform(withItems: [])
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



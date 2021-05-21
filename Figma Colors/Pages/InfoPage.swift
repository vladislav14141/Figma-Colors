//
//  InfoPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import SwiftUI

struct InfoPage: View {
    
    @EnvironmentObject var factory: FigmaFactory

    private let figmaTokenURL = URL(string: "https://www.figma.com/")!
    let directoryHelper = DirectoryHelper()

    @State var selectedExportModel = 0
    @State var codeOpened = false
//    @State var navLinkTag: Int?
    @EnvironmentObject var storage: FigmaStorage
    @State var settingsOpened: Bool = false
    init() {

    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                
                settingsContent()
            }.isHidden(!settingsOpened)
            mainContent().transition(.flipFromRight).isHidden(settingsOpened)
        }.padding().sheet(isPresented: $codeOpened, content: {
            if storage.navigationLink == .colors {
                
                CodeController(viewModel: .init(content: .colors(storage.colors)))
            } else if storage.navigationLink == .gradients {
                CodeController(viewModel: .init(content: .gradients(storage.gradients)))

            } else if storage.navigationLink == .components {
                CodeController(viewModel: .init(content: .components(storage.components)))
            }
        }).listStyle(InsetListStyle())
        .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity).layoutPriority(2)
    }
    
    @ViewBuilder func mainContent() -> some View {
        
        HStack {
            Spacer()
            RSTButton(iconName: "gearshape", appereance: .primaryOpacity2) {
                withAnimation {
                    settingsOpened = true
                }
            }.frame(width: 44, height: 44)
        }.padding(.bottom)
        Group {
            MRTextfield(title: "Figma LIGHT theme URL", placeholder: "Link to file or frame", text: $factory.fileKeyLight)
            MRTextfield(title: "Figma DARK theme URL", placeholder: "Link to file or frame", text: $factory.fileKeyDark)
            MRTextfield(title: "Figma access token", placeholder: "Optional. Use token for private files.", tooltip: "Used for private files. Optional.", text: $factory.figmaToken)
            RSTButton(iconName: "repeat.circle", title: "Update", enabled: true, loading: $factory.isLoading, appereance: storage.storageIsEmpty ? .primary : .primaryOpacity2) {
                factory.getData()
            }
        }
        
        Spacer(minLength: 32)
        Group {
            RSTButton(iconName: "doc.plaintext.fill", title: "Code", enabled: !storage.storageIsEmpty && !factory.isLoading, appereance: .primary) {
                codeOpened = true
            }
            
            RSTButton(iconName: "folder.fill", title: "Download Assets", enabled: !storage.storageIsEmpty && !factory.isLoading, appereance: .primary) {
                directoryHelper.downloadAssets(factory: factory)
            }
        }
    }
    
    @ViewBuilder func settingsContent() -> some View {
        SettingsController(settingOpened: $settingsOpened).transition(.flipFromRight)
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage()
    }
}

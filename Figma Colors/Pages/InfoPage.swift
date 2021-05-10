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
        List {
            mainContent()
        }.popover(isPresented: $codeOpened, content: {
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
            RSTButton(iconName: "repeat.circle") {
                settingsOpened.toggle()
            }
        }
        MRTextfield(title: "Figma access token", placeholder: "165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", text: $factory.figmaToken)
        Group {
            MRTextfield(title: "Figma LIGHT theme URL", placeholder: "ulzno6iXBBVlvMog2k6XsX", text: $factory.fileKeyLight)
            MRTextfield(title: "Figma DARK theme URL", placeholder: "GQz3OLZgxac5doTwkzTRM6", text: $factory.fileKeyDark)
            RSTButton(iconName: "repeat.circle", title: "Update", enabled: true, loading: $factory.isLoading, appereance: storage.storageIsEmpty ? .primary : .primaryOpacity2) {
                factory.getData()
            }
        }
        
        Spacer(minLength: 32)
        Group {
            RSTButton(iconName: "doc.plaintext.fill", title: "Code", enabled: !storage.storageIsEmpty, appereance: .primary) {
                codeOpened = true
            }
            
            RSTButton(iconName: "folder.fill", title: "Download Assets", enabled: !storage.storageIsEmpty, appereance: .primary) {
                directoryHelper.downloadAssets(factory: factory)
            }
        }
    }
    
    @ViewBuilder func settingsContent() -> some View {
        HStack {
            Spacer()
            RSTButton(iconName: "xmark") {
                settingsOpened.toggle()
            }
        }
        
        
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage()
    }
}

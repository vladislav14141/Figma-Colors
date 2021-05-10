//
//  SideBarController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import SwiftUI
enum NavigationTabItem: Identifiable {
    case components
    case colors
    case gradients
    case main
    var id: Int {
        hashValue
    }
}

struct SideBarController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: SideBarViewModel = SideBarViewModel()
//    @StateObject var factory = FigmaFactory()
//    @StateObject var storage = FigmaStorage.shared
    @EnvironmentObject var factory: FigmaFactory
    @EnvironmentObject var storage: FigmaStorage
    // MARK: - Private Properties

    
    // MARK: - Lifecycle
    init() {

    }
    
        var body: some View {
            List {
//                NavigationLink(destination: InfoPage(), tag: .main, selection: $storage.navigationLink) {
//                    HStack {
//                        Image(systemName: "paintbrush.pointed").foregroundColor(.primary)
//                        Text("Main").font(.callout)
//                        Spacer()
//                    }
//                }
                
                NavigationLink(destination: ColorSideBar(items: $storage.colors), tag: .colors, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "paintpalette").foregroundColor(storage.navigationLink == .colors ? .label : .blue)
                        Text("Colors").font(.callout)
                        Spacer()
                    }
                }
                
                NavigationLink(destination: GradientSideBar(items: $storage.gradients), tag: .gradients, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square").foregroundColor(storage.navigationLink == .gradients ? .label : .blue)
                        Text("Gradients").font(.callout)
                        Spacer()
                    }
                }
                
                NavigationLink(destination: ComponentsSideBar(items: $storage.components), tag: .components, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "aqi.medium").foregroundColor(storage.navigationLink == .components ? .label : .blue)
                        Text("Components").font(.callout)
                        Spacer()
                    }
                }
                
                
            }.environmentObject(factory).environmentObject(storage)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    
                    Button(action: {toggleSidebar()}, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }.presentedWindowToolbarStyle(UnifiedWindowToolbarStyle())
        }
    
    func toggleSidebar() {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}

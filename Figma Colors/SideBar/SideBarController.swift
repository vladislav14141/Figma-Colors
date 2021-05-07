//
//  SideBarController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import SwiftUI

struct SideBarController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: SideBarViewModel = SideBarViewModel()
//    @StateObject var factory = FigmaFactory()
//    @StateObject var storage = FigmaStorage.shared
    @EnvironmentObject var factory: FigmaFactory
    @EnvironmentObject var storage: FigmaStorage
    // MARK: - Private Properties
    enum ContentType: Identifiable {
        case components
        case colors
        case gradients
        case main
        var id: Int {
            hashValue
        }
    }

    @State var navigationLink: ContentType? = .colors
    // MARK: - Lifecycle
    init() {

    }
    
        var body: some View {
//            NavigationView {
                
                    List {
                        
                        NavigationLink(destination: InfoPage(), tag: .main, selection: $navigationLink) {
                            HStack {
                                Image(systemName: "paintbrush.pointed").foregroundColor(.primary)
                                Text("Main").font(.callout)
                                Spacer()
                            }
                        }
                        
                        NavigationLink(destination: ColorSideBar(items: $storage.colors), tag: .colors, selection: $navigationLink) {
                            HStack {
                                Image(systemName: "paintpalette").foregroundColor(navigationLink == .colors ? .label : .blue)
                                Text("Colors").font(.callout)
                                Spacer()
                            }
                        }
                        
                        NavigationLink(destination: GradientSideBar(items: $storage.gradients), tag: .gradients, selection: $navigationLink) {
                            HStack {
                                Image(systemName: "slider.horizontal.below.square.fill.and.square").foregroundColor(navigationLink == .gradients ? .label : .blue)
                                Text("Gradients").font(.callout)
                                Spacer()
                            }
                        }
                        
                        NavigationLink(destination: ComponentsSideBar(items: $storage.components), tag: .components, selection: $navigationLink) {
                            HStack {
                                Image(systemName: "aqi.medium").foregroundColor(navigationLink == .components ? .label : .blue)
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
                        
//                        ToolbarItem(placement: .navigation) {
//
//                            Text("selected:")
//                        }
                    }.presentedWindowToolbarStyle(UnifiedWindowToolbarStyle())
                    

                
                
            
//            }
//            .navigationTitle("Menu")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    
    func toggleSidebar() {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct ColorSideBar: View {
    @Binding var items: [FigmaSection<ColorItem>]
    @State var tab: Int? = 0
    
    var body: some View {
        List {
            NavigationLink(destination: ColorsPage(items: $items, selected: nil), tag: 0, selection: $tab) {
                HStack {
                    Image(systemName: "atom").foregroundColor(.blue)
                    Text("All")
                    Spacer()
                }
            }
            
            ForEach(items) { (section) in
                    
                    Section(header: ColorSectionButton(section: section).padding(.top)) {
                        ForEach(section.rows) { row in
                            ColorButton(figmaColor: row)
                        }
                    }
                }
        }
        .navigationTitle("Colors")
    }
}

struct GradientSideBar: View {
    @Binding var items: [FigmaSection<GradientItem>]
    @State var tab: Int? = 0

    var body: some View {
        List {
            NavigationLink(destination: GradientsPage(items: $items, selected: nil), tag: 0, selection: $tab) {
                HStack {
                    Image(systemName: "atom").foregroundColor(.blue)
                    Text("All")
                    Spacer()
                }
            }
            ForEach(items) { (section) in
                    
                    Section(header: GradientSectionButton(section: section)) {
                        ForEach(section.rows) { row in
                            GradientButton(item: row)
                        }
                    }
                }
        }
        .navigationTitle("Gradients")

    }
}

struct ComponentsSideBar: View {
    @Binding var items: [FigmaSection<ComponentItem>]
    @State var tab: Int? = 0

    var body: some View {
        List {
            NavigationLink(destination: ComponentsPage(items: $items, selected: nil), tag: 0, selection: $tab) {
                Image(systemName: "atom").foregroundColor(.blue)
                Text("All")
                Spacer()
            }

            ForEach(items) { (section) in
                
                Section(header: ComponentSectionButton(section: section)) {
                    ForEach(section.rows) { row in
                        ComponentButton(item: row)
                    }
                }
            }
        }
        .navigationTitle("Components")
    }
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}

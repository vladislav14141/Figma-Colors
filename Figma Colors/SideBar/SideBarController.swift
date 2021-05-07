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
                Text("All")
            }

            ForEach(items) { (section) in
                NavigationLink(destination: ColorsPage(items: $items, selected: nil), tag: section.id.hashValue, selection: $tab) {
                    ColorSectionButton(section: section)
                }
//                NavigationLink(destination: ColorsPage(items: $items, selected: section.name)) {
            }
        }//.frame(width: 150, idealWidth: 200, maxWidth: 300)
        .navigationTitle("Colors")

    }
}

struct GradientSideBar: View {
    @Binding var items: [FigmaSection<GradientItem>]

    var body: some View {
        List {
            NavigationLink(destination: GradientsPage(items: $items, selected: nil)) {
                Text("All")
            }

            ForEach(items) { (section) in
                NavigationLink(destination: GradientsPage(items: $items, selected: section.name)) {
                    HStack {
                        
                        Text(section.name)
                    }
                }
            }
        }.frame(minWidth: 150, idealWidth: 200, maxWidth: 300)
        .navigationTitle("Gradients")

    }
}

struct ComponentsSideBar: View {
    @Binding var items: [FigmaSection<ComponentItem>]

    var body: some View {
        List {
            NavigationLink(destination: ComponentsPage(items: $items, selected: nil)) {
                Text("All")
            }

            ForEach(items) { (section) in
                NavigationLink(destination: ComponentsPage(items: $items, selected: section.name)) {
                    Text(section.name)
                }
            }
        }.frame(minWidth: 150, idealWidth: 200, maxWidth: 300)
        .navigationTitle("Components")
    }
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}


//
//struct SplitView: View {
//    @State var selectedMenu: OutlineMenu = .popular
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading) {
//                    ForEach(OutlineMenu.allCases) { menu in
//                        OutlineRow(item: menu, selectedMenu: self.$selectedMenu)
//                    }
//                }
//                .frame(width: 250)
//            }
//            .frame(width: 250)
//            .background(Color(.sRGB, white: 0.1, opacity: 1))
//            selectedMenu.contentView
//        }
//    }
//}
//
//enum OutlineMenu: Int, CaseIterable, Identifiable {
//    var id: Int {
//        return self.rawValue
//    }
//
//
//    case popular, topRated, upcoming, nowPlaying, discover, wishlist, seenlist, myLists, settings
//
//    var title: String {
//        switch self {
//        case .popular:    return "Popular"
//        case .topRated:   return "Top rated"
//        case .upcoming:   return "Upcoming"
//        case .nowPlaying: return "Now Playing"
//        case .discover:   return "Discover"
//        case .wishlist:   return "Wishlist"
//        case .seenlist:   return "Seenlist"
//        case .myLists:    return "MyLists"
//        case .settings:   return "Settings"
//        }
//    }
//
//    var image: String {
//        switch self {
//        case .popular:    return "film.fill"
//        case .topRated:   return "star.fill"
//        case .upcoming:   return "clock.fill"
//        case .nowPlaying: return "play.circle.fill"
//        case .discover:   return "square.stack.fill"
//        case .wishlist:   return "heart.fill"
//        case .seenlist:   return "eye.fill"
//        case .myLists:    return "text.badge.plus"
//        case .settings:   return "wrench"
//        }
//    }
//
//    var contentView: AnyView {
//        switch self {
//        case .popular:    return AnyView( NavigationView{ Text("asda") })
//        case .topRated:   return AnyView( NavigationView{ Text("as") })
//        case .upcoming:   return AnyView( NavigationView{ Text("as") })
//        case .nowPlaying: return AnyView( NavigationView{ Text("as") })
//        case .discover:   return AnyView( Text("as") )
//        case .wishlist:   return AnyView(Text("as")) )
//        case .seenlist:   return AnyView( Text("as") )
//        case .myLists:    return AnyView( Text("as") )
//        case .settings:   return AnyView( Text("as") )
//        }
//    }
//}

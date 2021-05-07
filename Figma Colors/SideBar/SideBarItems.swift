//
//  SideBarItems.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 07.05.2021.
//

import SwiftUI
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

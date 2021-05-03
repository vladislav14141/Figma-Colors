//
//  SideBarGradientButton.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 01.05.2021.
//

import SwiftUI

struct SideBarComponentButton: View {
    @Binding var items: [FigmaSection<ComponentItem>]
    var body: some View {
        DisclosureGroup(
            content: {
                if items.isEmpty {
                    Text("Empty")
                } else {
                    ForEach(items) { section in
                        ComponentSectionButton(section: section)
                    }
                }
            },
            label: {
                NavigationLink(
                    destination: ComponentsPage(items: $items)) {
                    HStack {
                        Image(systemName: "person.crop.square")
                        Text("Components").font(.callout)
                    }
                }
            }
        )
    }
}

struct ComponentSectionButton: View {
    @ObservedObject var section: FigmaSection<ComponentItem>
    @State var count = ""
    @State var updater: Bool = false

    var body: some View {
        DisclosureGroup(
            content: {
                ForEach(section.rows) { row in
                    ComponentButton(item: row)
                        .onReceive(row.$isSelected, perform: { value in
                        count = "\(section.selectedCount)/\(section.count)"
                            section.isSelected = section.selected()
                    })
                }
                
            }) {
            NavigationLink(
                destination: ComponentsPage(items: .constant([section]))) {
                HStack {
                    Text(section.name).font(.callout)
                    Spacer()
                    Text(count).font(.caption)
                    MRCheckBox(isOn: $section.isSelected) { isOn in
                        isOn ? section.selectAll() : section.unSelectAll()
                    }
                }
            }.onAppear {
                count = "\(section.selectedCount)/\(section.count)"
            }.onReceive(section.$isSelected, perform: { _ in
                count = "\(section.selectedCount)/\(section.count)"
            })

            
        }
    }
}

struct ComponentButton: View {
    @ObservedObject var item: ComponentItem
    
    var section: FigmaSection<ComponentItem> {
        FigmaSection(name: item.groupName, colors: [item])
    }
    
    var body: some View {
        NavigationLink(
            destination: ComponentsPage(items: .constant([section])),
            label: {
                HStack(spacing: 8) {
                    Text(item.fullName).font(.callout)
                    Spacer()
                    MRCheckBox(isOn: $item.isSelected)
                }
            }
        )
    }
}

//struct SideBarGradientButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarGradientButton(items: .constant([]))
//    }
//}

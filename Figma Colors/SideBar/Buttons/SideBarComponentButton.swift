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
    var countString: String {
        "\(section.selectedCount)/\(section.count)"
    }
    
    var body: some View {
        HStack {
            Text(section.name).font(.callout)
            Spacer()
            Text(countString).font(.caption)
            MRCheckBox(isOn: $section.isSelected) { isOn in
                isOn ? section.selectAll() : section.unSelectAll()
            }
        }
    }
}

struct ComponentButton: View {
    @ObservedObject var item: ComponentItem
    @EnvironmentObject var storage: FigmaStorage

    var section: FigmaSection<ComponentItem> {
        FigmaSection(name: item.groupName, colors: [item])
    }
    
    var body: some View {
        NavigationLink(
            destination: ComponentsPage(items: .constant([section])),
            label: {
                HStack(spacing: 8) {
                    MRWebImage(url: item.x3).frame(width: 32, height: 32)
                    Text(item.fullName(nameCase: storage.nameCase)).font(.callout)
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

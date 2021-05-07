//
//  SideBarGradientButton.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 01.05.2021.
//

import SwiftUI

struct SideBarGradientButton: View {
    @Binding var items: [FigmaSection<GradientItem>]
    var body: some View {
        DisclosureGroup(
            content: {
                if items.isEmpty {
                    Text("Empty")
                } else {
                    ForEach(items) { section in
                        GradientSectionButton(section: section)
                    }
                }
            },
            label: {
                NavigationLink(
                    destination: GradientsPage(items: $items)) {
                    HStack {
                        Image(systemName: "paintbrush")
                        Text("Gradient").font(.callout)
                    }
                }
            }
        )
    }
}

struct GradientSectionButton: View {
    @ObservedObject var section: FigmaSection<GradientItem>
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

struct GradientButton: View {
    @ObservedObject var item: GradientItem
    
    var section: FigmaSection<GradientItem> {
        FigmaSection(name: item.groupName, colors: [item])
    }
    
    var body: some View {
        NavigationLink(
            destination: GradientsPage(items: .constant([section])),
            label: {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        if let g = item.light?.gradient {
                            LinearGradient(gradient: g, startPoint: .leading, endPoint: .trailing).frame(width: 64, height: 32).cornerRadius(2)
                        }
                        
                        if let g = item.dark?.gradient {
                            LinearGradient(gradient: g, startPoint: .leading, endPoint: .trailing).frame(width: 64, height: 32).cornerRadius(2)

                        }
                    }
                    Text(item.fullName).font(.callout)
                    Spacer()
                    MRCheckBox(isOn: $item.isSelected)
                }
            }
        ).frame(minWidth: 200)
    }
}

//struct SideBarGradientButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarGradientButton(items: .constant([]))
//    }
//}

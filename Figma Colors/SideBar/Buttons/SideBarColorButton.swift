//
//  SideBarGradientButton.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 01.05.2021.
//

import SwiftUI

struct SideBarColorButton: View {
    @Binding var figmaColors: [FigmaSection<ColorItem>]
    var selectedCount: Int {
        var count = 0
        figmaColors.forEach { (section) in
            section.rows.forEach { (row) in
                if row.isSelected {
                    count += 0
                }
            }
        }
        return count
    }
    var body: some View {
        DisclosureGroup(
            content: {
                if figmaColors.isEmpty {
                    Text("Empty")
                } else {
                    
                    ForEach(figmaColors) { section in
                        ColorSectionButton(section: section)
                    }
                }
            },
            label: {
                NavigationLink(
                    destination: ColorsPage(items: $figmaColors)) {
                    HStack {
                        Image(systemName: "paintbrush.pointed").foregroundColor(.primary)
                        Text("Colors").font(.callout)
                        Spacer()
                        Text("\(selectedCount)")

                    }
                }
            }
        )
    }
    
    
}

struct ColorSectionButton: View {
    @ObservedObject var section: FigmaSection<ColorItem>
    var countString: String {
        "\(section.selectedCount)/\(section.count)"
    }
    
    var body: some View {
        
        HStack {
            Text(section.name).font(.callout)
            Spacer()
            Text("\(section.selectedCount)/\(section.count)").font(.caption)
            MRCheckBox(isOn: $section.isSelected) { isOn in
                isOn ? section.selectAll() : section.unSelectAll()
            }
        }
    }
}

struct ColorButton: View {
    @ObservedObject var figmaColor: ColorItem

    var section: FigmaSection<ColorItem> {
        FigmaSection(name: figmaColor.groupName, colors: [figmaColor])
    }
    @EnvironmentObject var storage: FigmaStorage

    var body: some View {
        NavigationLink(
            destination: ColorsPage(items: .constant([section])),
            label: {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        figmaColor.light?.color
                            .frame(width: 32, height: 32)
                            .cornerRadius(2)
                        figmaColor.dark?
                            .color
                            .frame(width: 32, height: 32).cornerRadius(2)

                    }
                    Text(figmaColor.fullName(nameCase: storage.nameCase)).font(.callout)
                    Spacer()
                    MRCheckBox(isOn: $figmaColor.isSelected)
                }
            })
    }
}

//struct SideBarColorButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarGradientButton()
//    }
//}

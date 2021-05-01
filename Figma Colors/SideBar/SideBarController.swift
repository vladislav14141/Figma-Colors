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
    @StateObject var factory = FigmaFactory()
    // MARK: - Private Properties
    
    // MARK: - Lifecycle
    init() {

    }
    
        var body: some View {
            NavigationView {
                List {
//                    Section {
                        colorsPage()
                    
                    NavigationLink(destination: SideBarController()) {
                        Text("Side bar")
                    }
                    
                        NavigationLink(destination: ColorsPage(items: $factory.figmaColors)) {
                            Text("Content")
                        }
                        
                        NavigationLink(destination: GradientsPage(items: $factory.figmaGradient)) {
                            Text("Gradients")
                        }
                        
                        NavigationLink(destination: ComponentsPage(items: $factory.figmaComponents)) {
                            Text("Components")
                        }
                        
                        NavigationLink(destination: ImagesPage()) {
                            Text("Images")
                        }
                        
//                        NavigationLink(
//                        NavigationLink(<#T##title: StringProtocol##StringProtocol#>, destination: <#T##_#>, tag: <#T##Hashable#>, selection: <#T##Binding<Hashable?>#>)
//                        NavigationLink(destination: StaticGridView()) {
//                            Text("Static Grid")
//                        }
//                    }
                }
                .listStyle(SidebarListStyle())
//                .frame(minWidth: 200, maxWidth: 300)
                
            }
//     ы
//            .navigationViewStyle(
//                NavigationV
//                DoubleColumnNavigationViewStyle()
//            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    
    @ViewBuilder func colorsPage() -> some View {
        DisclosureGroup(
            content: {
                ForEach(factory.figmaColors) { section in
                    ColorSectionButton(section: section)
                }
            },
            label: {
                NavigationLink(
                    destination: ColorsPage(items: $factory.figmaColors)) {
                    HStack {
                        Text("Colors").customFont(.callout)
                        Spacer()
                        MRCheckBox1(isOn: isSelectedColors()) { isOn in
                            selectAll(isOn: isOn)
                        }
                    }
                }
                
                
                
            }
        )
    }
    
    func selectAll(isOn: Bool) {
        factory.figmaColors.forEach {
            isOn ? $0.selectAll() : $0.unSelectAll()
        }
    }
    
    func isSelectedColors() -> Bool {
        let selectedCount = factory.figmaColors.filter({$0.isSelected}).count
        
        return selectedCount == factory.figmaColors.count
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}


struct ColorSectionButton: View {
    @ObservedObject var section: FigmaSection<ColorItem>
    @State var count = ""
    @State var updater: Bool = false

    var body: some View {
        DisclosureGroup(
            content: {
                ForEach(section.rows) { row in
                    ColorButton(figmaColor: row)
                        .onReceive(row.$isSelected, perform: { _ in
                        count = "\(section.selectedCount)/\(section.count)"
                        
                    })
                }
                
            }) {
            NavigationLink(
                destination: ColorsPage(items: .constant([section]))) {
                HStack {
                    Text(section.name).customFont(.callout)
                    Spacer()
                    Text(count).customFont(.caption)
                    MRCheckBox1(isOn: section.isSelected) { isOn in
                        !section.isSelected ? section.selectAll() : section.unSelectAll()
                    }
                }
            }.onAppear {
                count = "\(section.selectedCount)/\(section.count)"

            }.onReceive(section.$selected, perform: { _ in
                count = "\(section.selectedCount)/\(section.count)"
            })

            
        }
    }
}

struct ColorButton: View {
    @ObservedObject var figmaColor: ColorItem

    var section: FigmaSection<ColorItem> {
        FigmaSection(name: figmaColor.groupName, colors: [figmaColor])
    }
    
    var body: some View {
        NavigationLink(
            destination: ColorsPage(items: .constant([section])),
            label: {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        figmaColor.light?.color
                            .frame(width: 16, height: 16)
                            .cornerRadius(2)
                        figmaColor.dark?
                            .color
                            .frame(width: 16, height: 16).cornerRadius(2)

                    }
                    Text(figmaColor.fullName).customFont(.callout)
                    Spacer()
                    MRCheckBox(isOn: $figmaColor.isSelected)
                }
            })
    }
}



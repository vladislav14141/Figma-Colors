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
    var colorsTitle: String {
        "\(selectedColorsCount)/\(colorsCount)"
    }
    var gradientsTitle: String {
        "\(selectedGradientsCount)/\(gradientsCount)"
    }
    var componentsTitle: String {
        "\(selectedComponentsCount)/\(componentsCount)"
    }
    
    @State var selectedComponentsCount = 0
    @State var selectedColorsCount = 0
    @State var selectedGradientsCount = 0

    @State var componentsCount = 0
    @State var colorsCount = 0
    @State var gradientsCount = 0
    
    // MARK: - Lifecycle
    init() {

    }
    
        var body: some View {
            List {
                
                NavigationLink(destination: ColorSideBar(items: $storage.colors), tag: .colors, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "paintpalette").foregroundColor(storage.navigationLink == .colors ? .label : .blue)
                        Text("Colors").font(.callout)
                        Spacer()


                        SideBarCellLabel(text: colorsTitle) { selected in
                            storage.colors.forEach { (item) in
                                if selected {
                                    item.selectAll()
                                } else {
                                    item.unSelectAll()

                                }
                            }
                        }
                    }
                }
                .onReceive(storage.$colors, perform: { colors in

                    colors.forEach { (section) in
                        section.$isSelected.sink { ( isSelected ) in
                            var count = 0
                            let selectedCount = colors.reduce(into: 0, { (result, section) in
                                result += section.selectedCount
                                count += section.count
                            })
                            selectedColorsCount = selectedCount
                            colorsCount = count
                            
                        }.store(in: &viewModel.bag)
                    }

                })
                
                NavigationLink(destination: GradientSideBar(items: $storage.gradients), tag: .gradients, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "slider.horizontal.below.square.fill.and.square").foregroundColor(storage.navigationLink == .gradients ? .label : .blue)
                        Text("Gradients")
                            .font(.callout)
                        Spacer()

                        SideBarCellLabel(text: gradientsTitle) { selected in
                            storage.gradients.forEach { (item) in
                                if selected {
                                    item.selectAll()
                                } else {
                                    item.unSelectAll()

                                }
                            }
                        }

                    }
                }
                .onReceive(storage.$gradients, perform: { gradients in
                    print(viewModel.bag.count)
                    gradients.forEach { (section) in
                        section.$isSelected.sink { ( isSelected ) in
                            var count = 0

                            let selectedCount = gradients.reduce(into: 0, { (result, section) in
                                result += section.selectedCount
                                count += section.count

                            })
                            gradientsCount = count
                            selectedGradientsCount = selectedCount
                        }.store(in: &viewModel.bag)
                    }
                })
                
                NavigationLink(destination: ComponentsSideBar(items: $storage.components), tag: .components, selection: $storage.navigationLink) {
                    HStack {
                        Image(systemName: "aqi.medium")
                            .foregroundColor(storage.navigationLink == .components ? .label : .blue)
                        
                        Text("Components")
                            .font(.callout)
                        Spacer()
                        SideBarCellLabel(text: componentsTitle) { selected in
                            storage.components.forEach { (item) in
                                if selected {
                                    item.selectAll()
                                } else {
                                    item.unSelectAll()

                                }
                            }
                        }
//                        Text(componentsTitle)
//                            .font(.footnote)
//                            .foregroundColor(.secondaryLabel)
                    }
                }
                .onReceive(storage.$components, perform: { components in

                    components.forEach { (section) in
                        section.$isSelected.sink { ( isSelected ) in
                            var count = 0

                            let selectedCount = components.reduce(into: 0, { (result, section) in
                                result += section.selectedCount
                                count += section.count

                            })
                            selectedComponentsCount = selectedCount
                            componentsCount = count


                        }.store(in: &viewModel.bag)
                    }
                })
                
                
            }
            .environmentObject(factory).environmentObject(storage)
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

struct SideBarCellLabel: View {
    var text: String
    @State var isSelected: Bool = true
    @State var isHovered = false
    var onSelected: (Bool)->() = { _ in }
    
    var textColor: Color {
        let opacity: Double = isHovered ? 0.5 : 1
        return isSelected ? Color.primary10.opacity(opacity) : Color.secondaryLabel.opacity(opacity)
    }
    
    var imageColor: Color {
        isSelected ? .primary08 : .secondaryLabel
    }
    
    var body: some View {
            Text(text)
                .strikethrough(!isSelected, color: textColor)
                .lineLimit(1)
                .customFont(.footnote)
                .foregroundColor(textColor)


        .onTapGesture {
            isSelected.toggle()
            self.onSelected(isSelected)
        }
        .whenHovered { (isHovered) in
            self.isHovered = isHovered
        }

    }
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}

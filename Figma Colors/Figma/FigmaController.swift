//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum FigmaContentType: String, CaseIterable {
    case all
    case colors
    case gradients
    case images
}

struct FigmaController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: FigmaViewModel = FigmaViewModel()
    let colorColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    let lazyStackSpacing: CGFloat = 16

    let gradientColumns = [
//        GridItem(.fixed(200), spacing: 16),

//        GridItem(.adaptive(minimum: 200, maximum: 640), spacing: 16)
        GridItem(.flexible(minimum: 200, maximum: 640), spacing: 16)

    ]
    
    // MARK: - Private Properties
    private let figmaTokenURL = URL(string: "https://www.figma.com/")!
    private var types = FigmaContentType.allCases.map({$0.rawValue})
    private var exportTypes: [ExportModel]
    
    @State var currentType: String = FigmaContentType.colors.rawValue
    @State var currentExportTypeId: Int = 0
    @State var currentExportType: ExportModel
    @State var showSettings = false
    

    // MARK: - Lifecycle
    init() {
        let array = [IOSExportModel(), IOSAssetsExportModel()]
        exportTypes = array
        self._currentExportType = State(wrappedValue: array[0])
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                Picker("Type", selection: $currentType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                if viewModel.isLoading { ProgressView() }

                ScrollView {
                    Text(currentType.capitalized).font(.title).fontWeight(.semibold)
                    colorView().isHidden(!(currentType == FigmaContentType.colors.rawValue || currentType == FigmaContentType.all.rawValue))
                    gradientView().isHidden(!(currentType == FigmaContentType.gradients.rawValue || currentType == FigmaContentType.all.rawValue))
                    imagesView().isHidden(!(currentType == FigmaContentType.images.rawValue || currentType == FigmaContentType.all.rawValue))
                    mockColorView().isHidden(!viewModel.isLoading)
                }
                HStack {
                    Text("\(viewModel.figmaColors.count) colors").font(.subheadline)
                    Text("\(viewModel.figmaGradient.count) gradients").font(.subheadline)

                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            InfoView()
                .background(Color.secondaryBackground).cornerRadius(8)
        }
        .padding()
        .popover(isPresented: $viewModel.showSettings, content: {
            SettingsController()
        })
        .sheet(isPresented: $viewModel.showCode, content: {
            CodeController(viewModel: .init(block: FigmaBlocks(colors: viewModel.figmaColors)))
        })
        .onAppear {
            viewModel.getData()
        }.background(Color.primaryBackground)
        
        // MARK: - Public methods
        
        // MARK: - Private Methods
        
    }
    
    @ViewBuilder func InfoView() -> some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        MRButton(iconName: "gearshape", title: nil, enabled: true) {
                            viewModel.showSettings = true
                        }.frame(width: 32)
                    }
                    
                    MRTextfield(title: "Figma access token", placeholder: "165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", text: $viewModel.figmaToken)
                    
                    Group {
                        MRTextfield(title: "Figma LIGHT theme URL", placeholder: "ulzno6iXBBVlvMog2k6XsX", text: $viewModel.fileKeyLight)
                        MRTextfield(title: "Figma DARK theme URL", placeholder: "GQz3OLZgxac5doTwkzTRM6", text: $viewModel.fileKeyDark)
                        MRButton(iconName: "repeat.circle", title: "Update", enabled: true) {
                            viewModel.getData()
                        }
                    }
                }
                
                VStack {
                    Picker("Export type", selection: $currentExportTypeId) {
                        ForEach(0..<exportTypes.count, id: \.self) {
                            Text(exportTypes[$0].title)
                        }
                    }.onChange(of: currentExportTypeId, perform: { value in
                        currentExportType = exportTypes[value]
                    })
                    
                    HStack(spacing: 16) {
                        ForEach(currentExportType.buttons, id: \.title) { bt in
                            MRButton(iconName: "folder.circle.fill", title: bt.title, enabled: true) {
                                bt.handle()
                            }
                        }
                    }
                }
                Spacer()
            }.frame(minWidth: 100, maxWidth: 300).padding()
        }
    }
    
    @ViewBuilder func gradientView() -> some View {
        LazyVGrid (
            columns: gradientColumns,
            alignment: .leading,
            spacing: lazyStackSpacing,
            pinnedViews: [.sectionHeaders] )
        {
            ForEach(viewModel.figmaGradient) { section in
                
                Section(header: headerView(title: section.name)) {
                    
                    
                    ForEach(section.rows) { row in
                        HStack(alignment: .bottom, spacing: 16) {
                            
                            HStack(spacing: 8) {
                                
                                FigmaGradientCellItem2(gradientItem: row, sheme: .light).frame(width: 160)
                                FigmaGradientCellItem2(gradientItem: row, sheme: .dark).frame(width: 160)
                            }
                            Divider().frame(height: 120)
                            HStack(spacing: 8) {
                                
                                ForEach(row.colors) { color in
                                    FigmaColorCell(colorItem: color).frame(width: 120)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }.padding()
    }
    
    @ViewBuilder func imagesView() -> some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .leading,
            spacing: lazyStackSpacing,
            pinnedViews: [.sectionHeaders] )
        {
            ForEach(viewModel.figmaImages) { section in
                Section(header: headerView(title: section.name)) {
                    ForEach(section.rows) { row in
                        FigmaImageCellItem(item: row)
                    }
                }
            }
        }.padding()
    }
    
    @ViewBuilder func colorView() -> some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .leading,
            spacing: lazyStackSpacing,
            pinnedViews: [.sectionHeaders] )
        {
            ForEach(viewModel.figmaColors) { section in
                
                Section(header: headerView(title: section.name)) {
                    
                    ForEach(section.rows) { row in
                        FigmaColorCell(colorItem: row)
                    }
                }
            }
        }.padding()
    }
    
    @ViewBuilder func mockColorView() -> some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .center,
            spacing: lazyStackSpacing,
            pinnedViews: [] )
        {
            ForEach(0..<5, id: \.self) { section in
                
                Section(header: headerView(title: "section.name")) {
                    
                    ForEach(1..<12, id: \.self) { row in
                        FigmaColorCell().id("\(section) - \(row)")
                    }
                }
            }.redacted()
        }
    }
    
    @ViewBuilder func headerView(title: String) -> some View {
//        VStack(alignment: .leading) {
//            Divider()
//        }
        HStack {
            Text(title.capitalized).font(.title2).bold().padding(.top).padding(4)//.offset(x: 8, y: 16)
            Spacer()
        }.background(Color.primaryBackground)
    }
}



struct FigmaGradientCellItem2: View {
    let gradientItem: GradientItem
    let sheme: FigmaSheme
    var body: some View {
        VStack {
            Text("").font(.headline).foregroundColor(.label)

            VStack(spacing: 0) {
                if let light = gradientItem.gradientLight, sheme == .light {
                    LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Light").font(.footnote)
                    ).foregroundColor(light.stops.first?.color.labelText())
                }
                
                if let dark = gradientItem.gradientDark, sheme == .dark {
                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Dark").font(.footnote)
                    ).foregroundColor(dark.stops.first?.color.labelText())
                }
            }
            .cornerRadius(16)
            .frame(height: 120)
        }
        .padding(.horizontal,4)
    }
}

struct FigmaGradientCellItem: View {
    let gradientItem: GradientItem
    var body: some View {
        VStack {
            Text("").font(.headline).foregroundColor(.label)

            VStack(spacing: 0) {
                if let light = gradientItem.gradientLight {
                    LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Light").font(.footnote)
                    ).foregroundColor(light.stops.first?.color.labelText())
                }
                
                if let dark = gradientItem.gradientDark {
                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Dark").font(.footnote)
                    ).foregroundColor(dark.stops.first?.color.labelText())
                }
            }
            .cornerRadius(16)
            .frame(height: 120)
        }
        .padding(.horizontal,4)
    }
}

//struct
struct FigmaColorCell: View {
    let colorItem: ColorItem
    var isMock = false
    init() {
        isMock = true
        self.colorItem = .init(figmaName: "Bla bla", light: .init(r: Double(Int.random(in: 0...255)), g: Double(Int.random(in: 0...255)), b: Double(Int.random(in: 0...255)), a: 1), dark: nil, description: nil)
    }
    
    init(colorItem: ColorItem) {
        self.colorItem = colorItem
    }
    var body: some View {
        VStack {
            Text(colorItem.fullName).font(.headline).foregroundColor(.label)
            VStack(spacing: 0) {
                if isMock {
                    Color.secondaryBackground
                } else {
                    FigmaColorCellItem(figmaColor: colorItem.light, scheme: .light)
                    
                    FigmaColorCellItem(figmaColor: colorItem.dark, scheme: .dark)
                }
                
            }
            .cornerRadius(16)
            .frame(height: 120)
        }
        .padding(.horizontal,4)
    }
}

struct FigmaImageCellItem: View {
    let item: ImageItem
    
    var body: some View {
        if let img = item.x3, let url = URL(string: img) {
            VStack {
                Text(item.fullName).font(.headline).frame(height: 32, alignment: .bottom)
                if let size = item.size {
                    VStack {
                        WebImage(url: url).resizable().scaledToFit().frame(width: min(size.width, 120),height: min(size.height, 120)).clipped()
                        
                    }.frame(width: 120, height: 120, alignment: .center).background(Color.tertiaryBackground).cornerRadius(8)
                    
                    
                } else {
                    
                    WebImage(url: url).resizable().scaledToFit().frame(height: 120).clipped()
                }
            }
            
        }
    }
}

struct FigmaColorCellItem: View {
    let figmaColor: FigmaColor?
    let scheme: FigmaSheme
    @State var isHover = false
    @State var isCopied = false
    var body: some View {
        if let figmaColor = figmaColor {
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
                isCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    isCopied = false
                }
            }, label: {
                
                ZStack(alignment: scheme == .light ? .bottomTrailing : .topTrailing) {
                    figmaColor.color.overlay(
                        VStack {
                            Text(figmaColor.hex).font(.callout).fontWeight(.semibold).foregroundColor(figmaColor.color.labelText())
                            Text("copied").font(.callout).fontWeight(.semibold).foregroundColor(figmaColor.color.labelText())

//                            Text(scheme == .light ? "Light" : "Dark").font(.footnote).foregroundColor(figmaColor.color.labelText())
                        }
                    )
                    
                }.opacity(isHover ? 0.9 : 1)

            }).buttonStyle(ColorButtonStyle())

            .onHover { over in
                isHover = over
            }
        }
    }
}

struct ColorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.8 : 1)


    }
}

struct FigmaController_Previews: PreviewProvider {
    static var previews: some View {
        FigmaController()
    }
}

//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI
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
        GridItem(.adaptive(minimum: 120))
    ]
    let gradientColumns = [
        GridItem(.fixed(300)),
        GridItem(.adaptive(minimum: 120))

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
                    gradientView().isHidden(currentType != FigmaContentType.gradients.rawValue)
                    colorView().isHidden(currentType != FigmaContentType.colors.rawValue)
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
            alignment: .center,
            spacing: 8,
            pinnedViews: [] )
        {
            ForEach(viewModel.figmaGradient) { section in
                
                Section(header: Text(section.name.capitalized).font(.title).bold().padding(.top).padding(.horizontal,4)) {
                    
                    
                    ForEach(section.rows) { row in
                        FigmaGradientCellItem(gradientItem: row)
                        ForEach(row.colors) { color in
                            FigmaColorCell(colorItem: color)
                            
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder func colorView() -> some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .center,
            spacing: 8,
            pinnedViews: [] )
        {
            ForEach(viewModel.figmaColors) { section in
                
                Section(header: Text(section.name.capitalized).font(.title).bold().padding(.top).padding(.horizontal,4)) {
                    
                    ForEach(section.rows) { row in
                        FigmaColorCell(colorItem: row)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func mockColorView() -> some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .center,
            spacing: 8,
            pinnedViews: [] )
        {
            ForEach(0..<5, id: \.self) { section in
                
                Section(header: Text("section.name").font(.title).bold().padding(.top).padding(.horizontal,4)) {
                    
                    ForEach(1..<12, id: \.self) { row in
                        FigmaColorCell().id("\(section) - \(row)")
                    }
                }
            }.redacted()
        }
    }
}




struct FigmaGradientCellItem: View {
    let gradientItem: GradientItem
    var body: some View {
        VStack {
            Text(gradientItem.name).font(.headline).foregroundColor(.label)

            VStack(spacing: 0) {
                if let light = gradientItem.gradientLight {
                    LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end)
                }
                
                if let dark = gradientItem.gradientDark {
                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end)
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

struct FigmaColorCellItem: View {
    let figmaColor: FigmaColor?
    let scheme: FigmaSheme
    @State var isHover = false

    var body: some View {
        if let figmaColor = figmaColor {
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
            }, label: {
                
                ZStack(alignment: scheme == .light ? .bottomTrailing : .topTrailing) {
                    figmaColor.color.overlay(
                        VStack {
                            Text(figmaColor.hex).font(.callout).fontWeight(.semibold).foregroundColor(figmaColor.color.labelText())
                            Text(scheme == .light ? "Light" : "Dark").font(.footnote).foregroundColor(figmaColor.color.labelText())
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



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
    let columns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    // MARK: - Private Properties
    private let figmaTokenURL = URL(string: "https://www.figma.com/")!
    private var types = FigmaContentType.allCases.map({$0.rawValue})
    private var exportTypes: [ExportModel]
    
    @State var currentType: String = FigmaContentType.colors.rawValue
    @State var currentExportTypeId: Int = 0
    @State var currentExportType: ExportModel

    

    // MARK: - Lifecycle
    init() {
        let array = [IOSExportModel(), IOSAssetsExportModel()]
        exportTypes = array
        self._currentExportType = State(wrappedValue: array[0])
//        $currentExportTypeId.sin
        
    }
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Access token").font(.headline)
                HStack {
                    TextField("165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", text: $viewModel.figmaToken)
                    Button("Get access token", action: {
                        NSWorkspace.shared.open(figmaTokenURL)
                    })
                }
            }
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Figma LIGHT theme URL").font(.headline)
                    TextField("ulzno6iXBBVlvMog2k6XsX", text: $viewModel.fileKeyLight)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Figma DARK theme URL").font(.headline)
                    TextField("GQz3OLZgxac5doTwkzTRM6", text: $viewModel.fileKeyDark)
                }
            }
            HStack {
                Button("Get") {
                    viewModel.getData()
                }
                
                
                Button("Export All") {
                    viewModel.onExportAll()
                }
                
                ForEach(currentExportType.buttons, id: \.title) { bt in
                    Button(bt.title) {
                        bt.handle()
                    }
                }
            }
            
            HStack {
                Picker("Type", selection: $currentType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Export type", selection: $currentExportTypeId) {
                    ForEach(0..<exportTypes.count, id: \.self) {
                        Text(exportTypes[$0].title)
                    }
                }.onChange(of: currentExportTypeId, perform: { value in
                    currentExportType = exportTypes[value]

                })
            }
            
            if viewModel.isLoading { ProgressView()
                
                
            }
            colorView().isHidden(currentType != FigmaContentType.colors.rawValue)
            
            Spacer()
        }.padding()
        .sheet(isPresented: $viewModel.showCode, content: {
            CodeController(viewModel: .init(block: FigmaBlocks(colors: viewModel.figmaColors)))
        })
        .onAppear {
            viewModel.getData()
        }
        
        // MARK: - Public methods
        
        // MARK: - Private Methods
        
    }
    
    @ViewBuilder func colorView() -> some View {
        ScrollView {
            
            LazyVGrid (
                columns: columns,
                alignment: .center,
                spacing: 8,
                pinnedViews: [.sectionHeaders, .sectionFooters] )
            {
                ForEach(viewModel.figmaColors) { section in
                    
                    Section(header: Text(section.name.capitalized).font(.title).bold().padding(.top).padding(.horizontal,4)) {
                        
                        ForEach(section.colors) { row in
                            //                                ZStack(alignment: .top) {
                            VStack {
                                Text(row.name).font(.headline).foregroundColor(.label)
                                VStack(spacing: 0) {
                                    
                                    FigmaColorCell(figmaColor: row.light, scheme: .light)
                                    
                                    FigmaColorCell(figmaColor: row.dark, scheme: .dark)
                                }
                                .cornerRadius(16)
                                .frame(height: 120)
                            }
                            .padding(.horizontal,4)
                            
                        }
                    }
                }
            }
        }
    }
}

struct FigmaColorCell: View {
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



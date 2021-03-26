//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI
enum FigmaContentType: String, CaseIterable {
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
    let figmaTokenURL = URL(string: "https://www.figma.com/")!
    @State var currentType: String = "images"
    var types = FigmaContentType.allCases.map({$0.rawValue})
//    let availableTypes = ["Images", ""]
    // MARK: - Lifecycle
    init() {
        
    }
    @State var selection = 0
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Access token").font(.headline)
                HStack {
                    TextField("165961-035dfc42-d428-4cb2-a7d7-7c63ba242e72", text: viewModel.$figmaToken)
                    Button("Get access token", action: {
                        NSWorkspace.shared.open(figmaTokenURL)
                    })
                }
            }
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Figma file light").font(.headline)
                    TextField("ulzno6iXBBVlvMog2k6XsX", text: viewModel.$fileKeyDark)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Figma file dark").font(.headline)
                    TextField("GQz3OLZgxac5doTwkzTRM6", text: viewModel.$fileKeyDark)
                }
            }
            Button("Get") {
                viewModel.getData()
            }
            Picker("Type", selection: $currentType) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            if viewModel.isLoading { ProgressView()
                
                
            }
            colorView().isHidden(currentType != FigmaContentType.colors.rawValue)
            
            Spacer()
        }.padding()
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
//            .opacity(configuration.isPressed ? 0.8 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)


    }
}

struct FigmaController_Previews: PreviewProvider {
    static var previews: some View {
        FigmaController()
    }
}

struct SafariPreview: View {
    @ObservedObject var model: WebViewModel
    init(mesgURL: String) {
        self.model = WebViewModel(link: mesgURL)
    }
    
    var body: some View {
        //Create a VStack that contains the buttons in a preview as well a the webpage itself
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Spacer()
                //The title of the webpage
                Text(self.model.didFinishLoading ? self.model.pageTitle : "")
                Spacer()
                //The "Open with Safari" button on the top right side of the preview
                Button(action: {
                    if let url = URL(string: self.model.link) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Open with Safari")
                }
            }
            //The webpage itself
            SwiftUIWebView(viewModel: model)
        }.frame(width: 800, height: 450, alignment: .bottom)
        .padding(5.0)
    }
}


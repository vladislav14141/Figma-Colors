//
//  CodeController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021. All rights reserved.
//

import SwiftUI
import HighlightedTextEditor
let function = try! NSRegularExpression(pattern: "import |extension |static |let ", options: [])
let classes = try! NSRegularExpression(pattern: " Color| UIColor| UIImage|", options: [])
let string = try! NSRegularExpression(pattern: "\"\\S*\"", options: [])
let mark = try! NSRegularExpression(pattern: "// MARK: - .*", options: [])
let named = try! NSRegularExpression(pattern: "let \\S*", options: [])

struct CodeController: View {
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Public Properties
    
    @EnvironmentObject var storage: FigmaStorage

    // MARK: - Private Properties
    @StateObject private var viewModel: CodeViewModel
    private let rules: [HighlightRule] = [
        HighlightRule(pattern: named, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor(Color.nameColor)),
        ]),
        HighlightRule(pattern: string, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor(Color.stringColor))
        ]),
        HighlightRule(pattern: function, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor(Color.xcodeColor)),
        ]),
        HighlightRule(pattern: classes, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor(Color.classesColor)),
        ]),
        HighlightRule(pattern: mark, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor(Color.markColor)),
        ])
    ]
    // MARK: - Lifecycle
    
    init(viewModel: CodeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        return VStack {
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("UIKit").font(.title).bold()
                    HighlightedTextEditor(text: $viewModel.uikit, highlightRules: rules).font(.body)
                }
                
                VStack(alignment: .leading) {
                    Text("SwiftUI").font(.title).bold()
                    HighlightedTextEditor(text: $viewModel.swiftui, highlightRules: rules).font(.body)
                }

            }.navigationTitle("Code")
            .toolbar(content: {
                ToolbarItem(id: "0") {
                    Picker(selection: $viewModel.selectedContentType, label: EmptyView(), content: {
                        Text("Colors").tag(0)
                        Text("Gradients").tag(1)
                        Text("Components").tag(2)
                    })
                }
                ToolbarItem(id: "1") {
                    Picker(selection: $viewModel.nameCase, label: EmptyView(), content: {
                        ForEach(NameCase.allCases, id: \.self) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    })
                }
                
                ToolbarItem(id: "2", placement: ToolbarItemPlacement.cancellationAction) {
                    RSTButton(iconName: "xmark", appereance: .primaryOpacity2) {
                        presentationMode.wrappedValue.dismiss()
                    }.frame(width: 44, height: 44)
                }
            })
            .onAppear {

            }.onReceive(viewModel.$selectedContentType, perform: { tag in
                var content: CodeContentType = CodeContentType.colors(storage.colors)
                switch tag {
                case 0: content = CodeContentType.colors(storage.colors)
                case 1: content = CodeContentType.gradients(storage.gradients)
                case 2: content = CodeContentType.components(storage.components)
                default: ()
                }
                viewModel.initialContentType = content
                viewModel.uikit = viewModel.generateCode(codeType: .UIKit, contentType: viewModel.initialContentType)
                viewModel.swiftui = viewModel.generateCode(codeType: .SwiftUI, contentType: viewModel.initialContentType)
            }).onReceive(viewModel.$nameCase, perform: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    viewModel.uikit = viewModel.generateCode(codeType: .UIKit, contentType: viewModel.initialContentType)
                    viewModel.swiftui = viewModel.generateCode(codeType: .SwiftUI, contentType: viewModel.initialContentType)
                }
            })
            .frame(minWidth: 600, idealWidth: 900, maxWidth: .infinity, minHeight: 400, idealHeight: 600, maxHeight: .infinity, alignment: .center)
        }.padding()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

//struct CodeNavigationView: View {
//    var body: some View {
//        List {
//            
//        }
//    }
//}




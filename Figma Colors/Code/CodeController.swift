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
let mark = try! NSRegularExpression(pattern: "// MARK: - \\S*", options: [])
let named = try! NSRegularExpression(pattern: "let \\S*", options: [])

struct CodeController: View {
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Public Properties
    
    
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
            HStack {
                Spacer()
                Toggle("Использовать шапку?", isOn: $viewModel.useHead)
                MRButton(iconName: "xmark", title: nil) {
                    presentationMode.wrappedValue.dismiss()
                }.frame(width: 44, height: 44)
            }
            HStack {
                VStack {
                    Text("UIKit").font(.title).bold()
                    HighlightedTextEditor(text: $viewModel.uikit, highlightRules: rules).font(.body)
                }
                
                VStack {
                    Text("SwiftUI").font(.title).bold()
                    HighlightedTextEditor(text: $viewModel.swiftui, highlightRules: rules).font(.body)
                }
                

            }.onAppear {
                viewModel.uikit = viewModel.generateCode(codeType: .UIKit, contentType: viewModel.initialContentType)
                viewModel.swiftui = viewModel.generateCode(codeType: .SwiftUI, contentType: viewModel.initialContentType)

            }.frame(minWidth: 600, idealWidth: 1000, maxWidth: .infinity, minHeight: 600, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
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




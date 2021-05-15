//
//  CodeViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021. All rights reserved.
//

import Combine
import Foundation

enum CodeType {
    case UIKit
    case SwiftUI
    
    func getExtension(contentType: CodeContentType) -> String {
        switch contentType {
        case .colors, .gradients:
            switch self {
            case .SwiftUI:
                return "extension Color {"
            case .UIKit:
                return "extension UIColor {"
                
            }
        case .components: return "extension UIImage {"
        }
    }
    
    var imp: String {
        switch self {
        case .SwiftUI: return "import SwiftUI\n\n"
        case .UIKit: return "import UIKit\n\n"
        }
    }
}

enum CodeContentType {
    case colors([FigmaSection<ColorItem>])
    case gradients([FigmaSection<GradientItem>])
    case components([FigmaSection<ComponentItem>])
}

class CodeViewModel: ObservableObject {
    
    // MARK: - Public Properties
//    @Published var storage: FigmaStorage
    @Published var uikit: String = ""
    @Published var swiftui: String = ""
    @Published var useHead = false
    @Published var nameCase: NameCase = .camelcase
    var bag = [AnyCancellable]()
    @Published var initialContentType: CodeContentType
    @Published var selectedContentType: Int = 0

    // MARK: - Private Methods

    // MARK: - Lifecycle
    init(content: CodeContentType) {
        self.initialContentType = content
//        self._storage = Published(wrappedValue: storage)
    }
    
    func generateCode(codeType: CodeType, contentType: CodeContentType) -> String {
        print("Generate", nameCase.rawValue)
        var content = ""

        let bracket = "}"
        let nextLine = "\n"
        let spacer = nextLine + nextLine


        content += codeType.imp
        
        content += codeType.getExtension(contentType: contentType)
        content += spacer
        
        switch contentType {
        case .colors(let sections):
            sections.forEach { (section) in
                let rows = section.selectedRows
                
                if rows.isEmpty == false {
                    content += section.description
                    content += nextLine
                }
                
                rows.forEach { (color) in

                    switch codeType {
                    case .SwiftUI: content += color.swiftuiCode(nameCase: nameCase)
                    case .UIKit: content += color.uikitCode(nameCase: nameCase)
                    }
                    content += nextLine
                }
                content += nextLine
            }
            
        case .components(let sections):
            sections.forEach { (section) in
                content += section.description
                content += nextLine
                section.selectedRows.forEach { (color) in

                    switch codeType {
                    case .SwiftUI: content += color.swiftuiCode(nameCase: nameCase)
                    case .UIKit: content += color.uikitCode(nameCase: nameCase)
                    }
                    content += nextLine
                }
                content += nextLine
            }
            
        case .gradients(let sections):
            sections.forEach { (section) in
                content += section.description
                content += nextLine
                section.selectedRows.forEach { (color) in

                    switch codeType {
                    case .SwiftUI: content += color.swiftuiCode(nameCase: nameCase)
                    case .UIKit: content += color.uikitCode(nameCase: nameCase)
                    }
                    content += nextLine
                }
                content += nextLine
            }
        }
        
        content += spacer
        content += bracket
        return content
    }
}

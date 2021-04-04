//
//  CodeViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021. All rights reserved.
//

import Combine
import Foundation

class CodeViewModel: ObservableObject {
    // MARK: - Public Properties
    @Published var figmaColors: FigmaBlocks
    @Published var uikit: String = ""
    @Published var swiftui: String = ""
    @Published var head = false
    var bag = [AnyCancellable]()
    
    // MARK: - Private Methods

    // MARK: - Lifecycle
    init(block: FigmaBlocks) {
        _figmaColors = Published(wrappedValue: block)
        $head.sink(receiveValue: { head in
            self.uikit = self.generateUIKit(useHead: head)
            self.swiftui = self.generateSwiftUI(useHead: head)
        }).store(in: &bag)
    }
    
    func generateUIKit(useHead: Bool) -> String {
        var content = ""
        let head = "import UIKit\n\nextension UIColor {"
        let down = "}"
        let nextLine = "\n"
        if useHead {
            content += head
            content += nextLine
        }
        
        figmaColors.colors.forEach { section in
            content += nextLine
            content += "    // MARK: - \(section.name)"
            content += nextLine
            
            section.rows.forEach { color in
                
                content += "    static let \(color.fullName) = UIColor(named: \"\(color.fullName)\")!"
                content += nextLine
            }
        }
        content += nextLine
        if useHead { content += down }
        return content
    }
    
    func generateSwiftUI(useHead: Bool) -> String {
        var content = ""
        let head = "import SwiftUI\n\nextension Color {"
        let down = "}"
        let nextLine = "\n"
        if useHead {
            content += head
            content += nextLine
        }
        figmaColors.colors.forEach { section in
            content += nextLine
            content += "    // MARK: - \(section.name)"
            content += nextLine
            
            section.rows.forEach { color in
                
                content += "    static let \(color.fullName) = Color(\"\(color.fullName)\")"
                content += nextLine
            }
        }
        content += nextLine
        if useHead { content += down }
        return content
    }
    
}

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
    @Published var figmaColors = [FigmaColor]()
    @Published var uikit: String = ""
    @Published var swiftui: String = ""
    @Published var head = false
    var bag = [AnyCancellable]()
    // MARK: - Private Methods
//    fileprivate let dataFetcher = NetworkDataFetcher()

    // MARK: - Lifecycle
    init() {
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
        
        var previus: FigmaColor?
        figmaColors.forEach { color in
            if color.groupName != previus?.groupName {
                content += nextLine
                content += "    // MARK: - \(color.groupName)"
                content += nextLine
            }
            content += "    static let \(color.name.split(separator: "-").joined()) = UIColor(named: \"\(color.name)\")!"
            content += nextLine
            previus = color
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
        
        var previus: FigmaColor?
        figmaColors.forEach { color in
            if color.groupName != previus?.groupName {
                content += nextLine
                content += "    // MARK: - \(color.groupName)"
                content += nextLine
            }
            content += "    static let \(color.name.split(separator: "-").joined()) = Color(\"\(color.name)\")"
            content += nextLine
            previus = color
        }
        content += nextLine
        if useHead { content += down }
        return content
    }
    
}

//
//  FigmaItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import Foundation

class FigmaItem: Identifiable {
    let id = UUID()
    
    /// "g / 10"
    let figmaName: String
    let figmaNameComponents: [String]
    
    /// "g"
    var groupName: String

    var fullName: String {
        return createName(nameComponents: figmaNameComponents)
    }
    
    var shortName: String {
        var components = figmaNameComponents
        components.removeFirst()
        return createName(nameComponents: components)

    }
    
    
    init(figmaName: String) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaName = figmaName
        self.figmaNameComponents = nameComponents
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""
    }
    
    func createName(nameComponents: [String]) -> String {
        var name = ""
        switch settings.nameCase {
        case .camelcase:
            name = nameComponents.enumerated().map{
                if $0 == 0 {
                    return $1
                } else {
                    return $1.capitalized
                }
            }.joined()
        case .snakecase:
            name = nameComponents.joined(separator: "_")
        }
        return name
    }
}

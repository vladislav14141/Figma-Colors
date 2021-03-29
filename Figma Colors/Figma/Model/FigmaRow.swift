//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation

class FigmaRow: Identifiable {
    var id: String {
        return name
    }

    var name: String
    let figmaName: String
    let figmaNameComponents: [String]
    var fullName: String {
        return figmaNameComponents.enumerated().map({
            if $0 == 0 {
                return $1
            } else {
                return $1.capitalized
            }
            
        }).joined()
    }
    
    var groupName: String?
    var light: FigmaColor?
    var dark: FigmaColor?
    var description: String?

    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil, description: String? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        let name = nameComponents.joined(separator: "-")
        self.figmaNameComponents = nameComponents
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.light = light
        self.dark = dark
        self.description = description

    }
}

class FigmaGradientRow: Identifiable {
    var id: String {
        return name
    }
    
    var name: String
    let figmaName: String
    var groupName: String?
    var light: [FigmaColor]?
    var dark: [FigmaColor]?

    internal init(figmaName: String, light: [FigmaColor]? = nil, dark: [FigmaColor]? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        let name = nameComponents.joined(separator: "-")
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.light = light
        self.dark = dark
    }
}

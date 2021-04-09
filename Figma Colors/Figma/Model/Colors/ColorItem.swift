//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
protocol FigmaSectionProtocol {
    var groupName: String { get }
    var fullName: String { get }

}
class ColorItem: Identifiable, FigmaSectionProtocol  {
    let id = UUID()

    let figmaName: String
    let figmaNameComponents: [String]
    var gradientComponents: [String] = []
    
    var fullName: String {
        var grad = gradientComponents
        var name = ""
        switch settings.nameCase {
        case .camelcase:
            name = figmaNameComponents.enumerated().map{
                if $0 == 0 {
                    return $1
                } else {
                    return $1.capitalized
                }
            }.joined()
        case .snakecase:
            name = figmaNameComponents.joined(separator: "_")
        }
        
        grad.insert(name, at: 0)
        return grad.joined(separator: settings.gradientSeparator)
    }
    
    var groupName: String
    var light: FigmaColor?
    var dark: FigmaColor?
    var description: String?

    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil, description: String? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaNameComponents = nameComponents
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""
        self.light = light
        self.dark = dark
        self.description = description

    }
}

class FigmaItem: Identifiable {
    let id = UUID()
    let figmaName: String
    let figmaNameComponents: [String]
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

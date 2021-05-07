//
//  FigmaItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import Foundation

class FigmaItem: Identifiable, ObservableObject {
    let id = UUID()
    
    /// "g / 10"
    let figmaName: String
    let figmaNameComponents: [String]
    
    /// "g"
    var groupName: String

    var fullName: String {
        return createName(nameComponents: figmaNameComponents)
    }
    
    var uiKitCode: String {
        ""
    }
    
    var swftUICode: String {
        ""
    }
    
    var fillSubnames: [String] = []

    var shortName: String {
        var components = figmaNameComponents
        components.removeFirst()
        return createName(nameComponents: components)
    }
    
    @Published var isSelected = true
    
  
    init(figmaName: String) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaName = figmaName
        self.figmaNameComponents = nameComponents
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : "Not a group"
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
        let currentName = ([name] + fillSubnames).joined(separator: settings.gradientSeparator)
        return currentName.isEmpty ? fullName : currentName
    }
}



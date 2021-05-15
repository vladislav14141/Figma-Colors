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
        return createName(nameComponents: figmaNameComponents, nameCase: figmaStorageDefault.nameCase)
    }
    
    var shortName: String {
        var components = figmaNameComponents
        components.removeFirst()
        return createName(nameComponents: components, nameCase: figmaStorageDefault.nameCase)
    }
    
    func uikitCode(nameCase: NameCase) -> String {
        ""
    }
    
    func swiftuiCode(nameCase: NameCase) -> String {
        ""
    }

    
    var fillSubnames: [String] = []

    
    @Published var isSelected = true
  
    init(figmaName: String) {
        let brokenCharacter: Set<Character> = [#"/"#, " ", "-", "_", "."]
        let nameComponents = figmaName.split(whereSeparator: { (char) -> Bool in
            brokenCharacter.contains(char)
        }).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaName = figmaName
        self.figmaNameComponents = nameComponents
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : "Not a group"
        
//        objectWillChange
    }
    
    func fullName(nameCase: NameCase) -> String {
        return createName(nameComponents: figmaNameComponents, nameCase: nameCase)
    }
    
    func shortName(nameCase: NameCase) -> String {
        if figmaNameComponents.count < 2 {
            return createName(nameComponents: figmaNameComponents, nameCase: nameCase)
        } else {
            var components = figmaNameComponents
            components.removeFirst()
            return createName(nameComponents: components, nameCase: nameCase)

        }
    }
    
    func createName(nameComponents: [String], nameCase: NameCase, fillSeparator: String = figmaStorageDefault.gradientSeparator) -> String {
        var name = ""

        switch nameCase {
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
        case .kebabcase:
            name = nameComponents.joined(separator: "-")

        }
        let currentName = ([name] + fillSubnames).joined(separator: fillSeparator)
        return currentName.isEmpty ? fullName : currentName
    }
}



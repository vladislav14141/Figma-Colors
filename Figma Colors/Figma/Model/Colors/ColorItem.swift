//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
protocol FigmaSectionProtocol {
    var groupName: String { get }
//    var name: String { get set }
    var fullName: String { get }

}
class ColorItem: Identifiable, FigmaSectionProtocol  {
//    var id: String {
//        return fullName
//    }
    let id = UUID()

//    var name: String
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
//        let name = nameComponents.joined(separator: settings.folderSeparator)
        self.figmaNameComponents = nameComponents
//        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""
        self.light = light
        self.dark = dark
        self.description = description

    }
}


import SwiftUI
class GradientItem: Identifiable, FigmaSectionProtocol {
    var fullName: String {
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
        return name
    }
    
    
    let id = UUID()
    let figmaNameComponents: [String]

    /// "g-10"
//    var name: String
    
    /// "g / 10"
    let figmaName: String
    
    /// "g"
    var groupName: String
    
    /// [0, 1]
    var colorLocation: [Float]
    
    var colors: [ColorItem]
    var start: UnitPoint
    var end: UnitPoint
    
    var gradientLight: Gradient? {
        let stopLight: [Gradient.Stop] = colors.enumerated().compactMap { i, color in
            if let color = color.light?.color {
                
                return Gradient.Stop(color: color, location: CGFloat(colorLocation[i]))
            } else {
                return nil
            }
        }
        return stopLight.isEmpty ? nil : .init(stops: stopLight)
    }
    
    var gradientDark: Gradient? {
        let stopDark: [Gradient.Stop] = colors.enumerated().compactMap { i, color in
            if let color = color.dark?.color {
                return Gradient.Stop(color: color, location: CGFloat(colorLocation[i]))
            } else {
                return nil
            }
        }
        
        return stopDark.isEmpty ? nil : .init(stops: stopDark)
    }
    
    internal init(figmaName: String, colors: [ColorItem] = [], colorLocation: [Float], start: UnitPoint, end: UnitPoint) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
//        let name = nameComponents.joined(separator: "-")
        self.figmaNameComponents = nameComponents
        self.colorLocation = colorLocation
        self.start = start
        self.end = end
//        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""
        self.colors = colors
    }
}

class ImageItem: Identifiable, FigmaSectionProtocol {
    var fullName: String {
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
        return name
    }
    
    
    let id = UUID()

//    var id: String {
//        return name
//    }
    var groupName: String
    let figmaNameComponents: [String]

    let figmaName: String
    var x3: String?
    var x2: String?
    var x1: String?
    @Published var size: CGSize?

    internal init(figmaName: String) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaNameComponents = nameComponents
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""

        self.figmaName = figmaName
    }
}

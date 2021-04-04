//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation

class ColorItem: Identifiable  {
    var id: String {
        return fullName
    }

    var name: String
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
    
    var groupName: String?
    var light: FigmaColor?
    var dark: FigmaColor?
    var description: String?

    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil, description: String? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        let name = nameComponents.joined(separator: settings.folderSeparator)
        self.figmaNameComponents = nameComponents
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.light = light
        self.dark = dark
        self.description = description

    }
}

//class GradientSection {
//    var id: String {
//        return name
//    }
//    let name: String
//
//    private(set) var colorsName = Set<Row.ID>()
//    private(set) var colors: [GradientItem] = []
//
//    internal init(name: String, colors: [Row] = [Row]()) {
//        self.name = name
//        self.colors = colors
//    }
//
//    func append(_ object: GradientItem) {
//        if colorsName.contains(object.id) == false {
//            colors.append(object)
//            colorsName.insert(object.id)
//        }
//    }
//
//    func sortColors() {
//        colors.sort(by: {$0.id < $1.id})
//    }
//}

//class GradientItemColor: Identifiable {
//    var id: String {
//        colorItem.id
//    }
//    let colorItem: ColorItem
//    let position: Float
//
//    init(colorItem: ColorItem, position: Float) {
//        self.colorItem = colorItem
//        self.position = position
//    }
//}
import SwiftUI
class GradientItem: Identifiable {
    var id: String {
        return name
    }
    
    /// "g-10"
    var name: String
    
    /// "g / 10"
    let figmaName: String
    
    /// "g"
    var groupName: String?
    
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
        let name = nameComponents.joined(separator: "-")
        
        self.colorLocation = colorLocation
        self.start = start
        self.end = end
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.colors = colors
    }
}

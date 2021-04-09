//
//  GradientItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import Foundation
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


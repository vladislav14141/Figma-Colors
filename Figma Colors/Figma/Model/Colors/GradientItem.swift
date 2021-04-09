//
//  GradientItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import Foundation
import SwiftUI

class GradientItem: FigmaItem {
    
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
        self.colorLocation = colorLocation
        self.start = start
        self.end = end
        self.colors = colors
        
        super.init(figmaName: figmaName)
        
    }
}


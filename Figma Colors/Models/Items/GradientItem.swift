//
//  GradientItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import Foundation
import SwiftUI

class GradientItem: FigmaItem {
    var light: FigmaGradient?
    var dark: FigmaGradient?
    var colors: [ColorItem] = []
    private var colorsCache: [String: ColorItem] = [:]
    
    internal init(figmaName: String, colors: [ColorItem]) {
        self.colors = colors
        super.init(figmaName: figmaName)
    }
    
    override func uikitCode(nameCase: NameCase) -> String {
        colors.reduce(into: "") { (result, item) in
            result += "\n" + item.uikitCode(nameCase: nameCase)
        }
    }
    
    override func swiftuiCode(nameCase: NameCase) -> String {
        colors.reduce(into: "") { (result, item) in
            result += "\n" + item.swiftuiCode(nameCase: nameCase)
        }
    }
    
    func setGradient(_ gradient: FigmaGradient,for sheme: FigmaSheme) {
        switch sheme {
        case .dark: self.dark = gradient
        case .light: self.light = gradient
            
        }
    }
    
//    ful
    

}

class FigmaGradient: FigmaItem {
    let colors: [FigmaColor]
    let colorLocation: [Float]
    let start: UnitPoint
    let end: UnitPoint
    let gradient: Gradient
    
    init(figmaName: String, colors: [FigmaColor], location: [Float], start: UnitPoint, end: UnitPoint) {
        self.colors = colors
        self.colorLocation = location
        self.start = start
        self.end = end
        
        let stops: [Gradient.Stop] = colors.enumerated().compactMap { i, figmaColor in
            return Gradient.Stop(color: figmaColor.color, location: CGFloat(location[i]))
        }
        self.gradient = Gradient(stops: stops)
        
        super.init(figmaName: figmaName)
    }
}

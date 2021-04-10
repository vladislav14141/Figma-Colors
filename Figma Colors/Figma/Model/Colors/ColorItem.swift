//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
//protocol FigmaSectionProtocol {
//    var groupName: String { get }
//    var fullName: String { get }
//
//}
class ColorItem: FigmaItem  {

    var light: FigmaColor?
    var dark: FigmaColor?
    

    
    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil) {
        super.init(figmaName: figmaName)
        self.light = light
        self.dark = dark
    }
    
    func setColor(_ color: FigmaColor, for sheme: FigmaSheme) {
        switch sheme {
        case .dark: dark = color
        case .light: light = color
        }
    }
    
    func colorFor(_ sheme: FigmaSheme) -> FigmaColor? {
        switch sheme {
        case .dark: return dark
        case .light: return light
        }
    }
}



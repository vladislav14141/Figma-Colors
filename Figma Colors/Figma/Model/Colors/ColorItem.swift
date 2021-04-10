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
    var gradientNameComponents: [String] = []
    
    override var fullName: String {
        var grad = gradientNameComponents
        let name = super.fullName
        grad.insert(name, at: 0)
        return grad.joined(separator: settings.gradientSeparator)
    }
    
    override var shortName: String {
        var grad = gradientNameComponents
        let name = super.shortName
        grad.insert(name, at: 0)
        return grad.joined(separator: settings.gradientSeparator)
    }
    
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
}



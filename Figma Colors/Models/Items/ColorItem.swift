//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import SwiftUI

class ColorItem: FigmaItem  {

    @Published var light: FigmaColor?
    @Published  var dark: FigmaColor?
        
    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil) {
        super.init(figmaName: figmaName)
        self.light = light
        self.dark = dark
    }
    
    override func uikitCode(nameCase: NameCase) -> String {
        "    static let \(fullName(nameCase: nameCase)) = UIColor(named: \"\(fullName)\")!"
    }
    
    override func swiftuiCode(nameCase: NameCase) -> String {
        "   static let \(fullName(nameCase: nameCase)) = Color(\"\(fullName)\")"
    }
    
    func setColor(_ color: FigmaColor, for sheme: FigmaSheme) {
        DispatchQueue.main.async {
            switch sheme {
            case .dark: self.dark = color
            case .light: self.light = color
            }
        }
    }
    
    func colorFor(_ sheme: FigmaSheme) -> FigmaColor? {
        switch sheme {
        case .dark: return dark
        case .light: return light
        }
    }
}



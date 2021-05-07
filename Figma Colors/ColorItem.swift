//
//  FigmaRow.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import SwiftUI
//protocol FigmaSectionProtocol {
//    var groupName: String { get }
//    var fullName: String { get }
//
//}
class ColorItem: FigmaItem  {

    @Published var light: FigmaColor?
    @Published  var dark: FigmaColor?
        
    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil) {
        super.init(figmaName: figmaName)
        self.light = light
        self.dark = dark
    }
    
    override var swftUICode: String {
        "   static let \(fullName) = Color(\"\(fullName)\")"
    }
    
    override var uiKitCode: String {
        "    static let \(fullName) = UIColor(named: \"\(fullName)\")!"
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



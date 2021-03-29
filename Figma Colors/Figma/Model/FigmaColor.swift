//
//  FigmaColor.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import SwiftUI

class FigmaColor: Identifiable {
    let color: Color
    let hex: String
    
    let red: Double
    let blue: Double
    let green: Double
    let alpha: Double
    
    init(r: Double, g: Double, b: Double, a: Double) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.color = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
        self.hex = FigmaColor.rgbToHex(r: r, g: g, b: b, a: a)
    }
    
    static func rgbToHex(r: Double, g: Double, b: Double, a: Double) -> String {
        if a == 1 {
            
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "%06x", rgb)
        } else {
            let rgba:Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0
            return String(format: "%08x", rgba)
        }

    }
    
}

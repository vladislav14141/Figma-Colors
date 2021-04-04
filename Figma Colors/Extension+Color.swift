//
//  Extension+Color.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 30.03.2021.
//

import Foundation
import Cocoa
import SwiftUI
//import UIKit
extension Color {
    
    static let label = Color(NSColor.labelColor)
    static let primaryBackground = Color(NSColor.gridColor)//Color("primaryBackground")
    static let secondaryBackground = Color(NSColor.controlBackgroundColor)//Color("secondaryBackground")
    static let buttonBackground = Color("buttonBackground")

    static func random() -> Color{
        return Color(red: Double.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0.5...1))
    }
//    static let secondaryBackground = Color("s")
    func labelText() -> Color {
        if let rgb = rgb() {
            var sum = 0
            [rgb.blue, rgb.red, rgb.green].forEach({
                sum += $0
            })
            return sum > (255 * 3) / 2 ? .black : .white
        }
        return .label
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        let color = NSColor(self)
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
//        if  {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
//        } else {
//            // Could not extract RGBA components:
//            return nil
//        }
    }
    
    public func rgbToHex() -> String {
        let color = NSColor(self)
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
}


extension String {
    func hexStringToUIColor() -> (CGFloat, CGFloat, CGFloat, CGFloat){
        let r, g, b, a: CGFloat
        let hex = self.hasPrefix("#") ? String(self.dropFirst()) : self
        
        if hex.count == 8 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                return (r,g,b,a)
            }
        } else if hex.count == 6 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                a = 1
                return (r,g,b,a)
            }
        }
        return (0,0,0,1)
    }
}

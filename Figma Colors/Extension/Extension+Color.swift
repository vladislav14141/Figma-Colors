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
    static let markColor = Color("markColor")
    static let classesColor = Color("classesColor")
    static let nameColor = Color("nameColor")
    static let stringColor = Color("stringColor")
    static let xcodeColor = Color("xcodeColor")

    static let label = Color(NSColor.labelColor)
    static let primaryBackground = Color(NSColor.gridColor)//Color("primaryBackground")
    static let secondaryBackground = Color(NSColor.controlBackgroundColor)//Color("secondaryBackground")
    static let tertiaryBackground = Color(NSColor.unemphasizedSelectedContentBackgroundColor)//Color("secondaryBackground")

    static let buttonBackground = Color("buttonBackground")
    static let disabledButtonBackground = Color("buttonBackground")
    static let disabledButtonText = Color("buttonBackground")

    static let smallButtonSelectedBackground = Color(NSColor.systemBlue)
    static let smallButtonBackground = Color(NSColor.systemGray)
    static let primary01 = Color("primary01")
    static let primary02 = Color("primary02")
    static let primary03 = Color("primary03")
    static let primary04 = Color("primary04")
    static let primary05 = Color("primary05")
    static let primary06 = Color("primary06")
    static let primary07 = Color("primary07")
    static let primary08 = Color("primary08")
    static let primary09 = Color("primary09")
    static let primary10 = Color("primary10")

    static let grey01 = Color("grey01")
    static let grey02 = Color("grey02")
    static let grey03 = Color("grey03")
    static let grey04 = Color("grey04")
    static let grey05 = Color("grey05")
    static let grey06 = Color("grey06")
    static let grey07 = Color("grey07")
    static let grey08 = Color("grey08")
    static let grey09 = Color("grey09")
    static let grey10 = Color("grey10")
    static let grey11 = Color("grey11")
    static let grey12 = Color("grey12")
    static let grey13 = Color("grey13")
    static let grey14 = Color("grey14")
    static let grey15 = Color("grey15")
    static let grey16 = Color("grey16")
    static let grey17 = Color("grey17")
    static let grey18 = Color("grey18")
    static let grey19 = Color("grey19")
    static let grey20 = Color("grey20")
    
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
        let iRed = Int(fRed * 255.0)
        let iGreen = Int(fGreen * 255.0)
        let iBlue = Int(fBlue * 255.0)
        let iAlpha = Int(fAlpha * 255.0)
        
        return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
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

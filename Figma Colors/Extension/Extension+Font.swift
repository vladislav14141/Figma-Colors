//
//  Extension+Font.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI
import Foundation
enum JetBrainsFont: String, Equatable, CaseIterable {
    case title
    case title2
    case body
    case callout
    case caption
    
    var name: String { "JetBrainsMono" }
    var weight: (String, Font.Weight) {
        switch self {
//        default: return ("Bold", .bold)
        case .title, .title2: return ("Bold", .bold)
        default: return ("Regular", .regular)
        }
    }
    
//    var size: CGFloat {
//        switch self {
//        case .title: return 48
//        case .title2: return 32
//        case .body: return 16
//        case .callout: return 13
//        case .caption: return 12
//        }
//    }
    
    var size: CGFloat {
        switch self {
        case .title: return 22
        case .title2: return 17
        case .body: return 13
        case .callout: return 12
        case .caption: return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title: return 26
        case .title2: return 22
        case .body: return 16
        case .callout: return 15
        case .caption: return 13
        }
    }
// Large   32    Bold
//Title 1    Regular    22    26    Bold
//Title 2    Regular    17    22    Bold
//Title 3    Regular    15    20    Semibold
//Headline    Bold    13    16    Heavy
//Subheadline    Regular    11    14    Semibold
//Body    Regular    13    16    Semibold
//Callout    Regular    12    15    Semibold
//Footnote    Regular    10    13    Semibold
//Caption 1    Regular    10    13    Medium
//Caption 2    Medium    10    13
}
extension Font {
    static func jetBrains(_ font: JetBrainsFont) -> Font {
        let name = "\(font.name)-\(font.weight.0)"
        print("font", name)
        return Font.custom(name, size: font.size)
    }
}

extension View {
    func customFont(_ font: Font) -> some View {
        self.font(font)
//        return self.font(.jetBrains(font)).lineSpacing(font.lineHeight)
    }
}

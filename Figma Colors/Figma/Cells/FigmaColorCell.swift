//
//  FigmaColorCell.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct FigmaColorCell: View {
    
    @ObservedObject var colorItem: ColorItem
    var isMock = false
    
    init() {
        isMock = true
        let color = FigmaColor(r: Double(Int.random(in: 0...255)), g: Double(Int.random(in: 0...255)), b: Double(Int.random(in: 0...255)), a: 1)
        self.colorItem = ColorItem(figmaName: "Bla/bloBelka", light: color, dark: color)
    }
    
    init(colorItem: ColorItem) {
        self.colorItem = colorItem
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 0) {
                if isMock {
                    Color.secondaryBackground
                } else {
                    FigmaColorCellItem(figmaColor: colorItem.light, scheme: .light)
                    
                    FigmaColorCellItem(figmaColor: colorItem.dark, scheme: .dark)
                }
                
            }
            .cornerRadius(16)
            .frame(height: 120)
            
            Text(colorItem.shortName)
                .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .customFont(.callout)
                .foregroundColor(.label)
                .overlay(
                    LinearGradient(gradient: .init(colors: [Color.primaryBackground.opacity(0.01), .primaryBackground]),
                                   startPoint: .leading,
                                   endPoint: .trailing).frame(width: 24),
                    alignment: .trailing)
        }
    }
}

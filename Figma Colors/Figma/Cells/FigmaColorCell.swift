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
    @State var isHovered = false
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
                .stokedLabel(!colorItem.isSelected)
                .lineLimit(1)
                .customFont(.callout)
                .foregroundColor(foregroundColor())
                .background(Color.primaryBackground)
                .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                
                .onTapGesture {
                    colorItem.isSelected.toggle()
                }
                .onHover { (isHovered) in
                    self.isHovered = isHovered
                }
        }
    }
    
    func foregroundColor() -> Color {
        let opacity: Double = colorItem.isSelected ? 1 : 0.5
        return isHovered ? Color.blue.opacity(opacity) : Color.label.opacity(opacity)
    }
}

struct FigmaCellLabel: View {
    var body: some View {
        
    }
    
}

extension View {
    @ViewBuilder func gradiented(color: Color = Color.primaryBackground) -> some View {
        self.overlay(
            LinearGradient(gradient: .init(colors: [color.opacity(0.01), color]),
                           startPoint: .leading,
                           endPoint: .trailing)
                .frame(width: 24),
            alignment: .trailing)
    }
    @ViewBuilder func stokedLabel(_ stroked: Bool) -> some View {
        ZStack(alignment: .leading) {
            self
            Divider().animation(.easeIn).transition(.slide).isHidden(!stroked)
        }.clipped()
    }
    
    
}

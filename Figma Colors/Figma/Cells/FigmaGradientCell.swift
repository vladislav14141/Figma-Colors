//
//  FigmaGradientCell.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 10.04.2021.
//

import SwiftUI

struct FigmaGradientCellItem: View {
    let gradientItem: FigmaGradient
    
    @State var hoveredItem: FigmaColor?
    @State var isHoveredView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LinearGradient(gradient: gradientItem.gradient, startPoint: gradientItem.start, endPoint: gradientItem.end)
                .onHover { hover in
                    withAnimation(.easeInOut) {
                        
                        isHoveredView = hover
                    }
                }
                .overlay(
                    
                    GeometryReader { reader in
                        HStack(spacing: 0) {
                            
                            ForEach(gradientItem.colors) { figmaColor in
                                
//                                FigmaColorCellItem(figmaColor: figmaColor, scheme: .light)
                                figmaColor.color
                                    .onHover { hovered in
                                        withAnimation(.easeInOut) {
                                            hoveredItem = figmaColor
                                            print(hovered, figmaColor.blue)
                                        }
                                    }
                                    .frame(width: hoverWidth(item: figmaColor, reader: reader))
                            }
                        }
                    }.isHidden(!isHoveredView)
                )
                .foregroundColor(gradientItem.colors.first?.color.labelText())
                .cornerRadius(16)
                .frame(height: 120)
            
            Text(gradientItem.shortName).customFont(.callout).foregroundColor(.label)
        }
    }
    
    func hoverWidth(item: FigmaColor, reader: GeometryProxy) -> CGFloat {
        let hoveredWidth = reader.frame(in: .local).width / 2 * 1.3
        let unhovered = (reader.frame(in: .local).width - hoveredWidth) / (CGFloat(gradientItem.colors.count) - 1)
//        print(hoveredWidth," as ", unhovered)
        
        if let hover = hoveredItem {
            if (hover.id == item.id) {
                return hoveredWidth
            } else {
                return (reader.frame(in: .local).width - hoveredWidth) / (CGFloat(gradientItem.colors.count) - 1)
            }
        } else {
            return reader.frame(in: .local).width / CGFloat(gradientItem.colors.count)
        }
    }
}

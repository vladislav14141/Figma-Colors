//
//  FigmaGradientCellItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct FigmaGradientCell: View {
    
    let gradientItem: GradientItem
    @State var hoveredItem: ColorItem?
    @State var isHoveredView = false
    
    var body: some View {
        HStack(spacing: 16) {
            if let light = gradientItem.light {
                FigmaGradientCellItem(gradientItem: light)
            }
            
            if let dark = gradientItem.dark {
                FigmaGradientCellItem(gradientItem: dark)
            }
        }
    }
}



//struct FigmaGradientCellItem_Preview: PreviewProvider {
//    static var view: FigmaGradientCellItem {
//        let colors = [ColorItem(figmaName: "b/1", light: FigmaColor(r: Double.random(in: 0...1), g: Double.random(in: 0...1), b: Double.random(in: 0...1), a: 1)), ColorItem(figmaName: "b/2", light: FigmaColor(r: Double.random(in: 0...1), g: Double.random(in: 0...1), b: Double.random(in: 0...1), a: 1))]
//        let item = GradientItem(figmaName: "g/10", colors: colors, colorLocation: [0,1], start: .bottomLeading, end: .trailing)
//        let g = FigmaGradientCellItem(gradientItem: item, sheme: .light)
//        return g
//    }
//    static var previews: some View {
//        return view
//    }
//}

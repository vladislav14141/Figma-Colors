//
//  FigmaGradientCellItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct FigmaGradientCellItem: View {
    
    let gradientItem: GradientItem
    let sheme: FigmaSheme
    @State var hoveredItem: ColorItem?
    @State var isHoveredView = false
    
    var body: some View {
        VStack {
            Text("").font(.headline).foregroundColor(.label)

//            VStack(spacing: 0) {
//                if let light = gradientItem.gradientLight, sheme == .light {
////                    ZStack {
//                        LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end)
//                            .onHover { hover in
//                                withAnimation(.easeInOut) {
//
//                                    isHoveredView = hover
//                                }
//                            }
//                            .overlay(
//
//                                GeometryReader { reader in
//                                    HStack(spacing: 0) {
//
//                                        ForEach(gradientItem.colors) { color in
//
//                                            FigmaColorCellItem(figmaColor: color.light, scheme: .light)
//                                                .onHover { hovered in
//                                                    withAnimation(.easeInOut) {
//
//                                                        hoveredItem = hovered ? color : nil
//                                                    }
//                                                }
//                                                .frame(width: hoverWidth(item: color, reader: reader))
//                                        }
//                                    }
//                                }.isHidden(!isHoveredView)
//                            ).foregroundColor(light.stops.first?.color.labelText())
//
//                }
//
//                if let dark = gradientItem.gradientDark, sheme == .dark {
//                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
//                        Text("Dark").font(.footnote)
//                    ).foregroundColor(dark.stops.first?.color.labelText())
//                }
//            }
            .cornerRadius(16)
            .frame(height: 120)
        }
    }
    
//    func hoverWidth(item: ColorItem, reader: GeometryProxy) -> CGFloat {
//        let hoveredWidth = reader.frame(in: .local).width / 2 * 1.5
//        let unhovered = (reader.frame(in: .local).width - hoveredWidth) / (CGFloat(gradientItem.colors.count) - 1)
//        print(hoveredWidth," as ", unhovered)
//            
//        if let hover = hoveredItem {
//            if (hover.id == item.id) {
//                return hoveredWidth
//            } else {
//                return (reader.frame(in: .local).width - hoveredWidth) / (CGFloat(gradientItem.colors.count) - 1)
//            }
//        } else {
//            return reader.frame(in: .local).width / CGFloat(gradientItem.colors.count)
//        }
//    }
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

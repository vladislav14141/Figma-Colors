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
                        if hover == false {
                            hoveredItem = nil
                        }
                    }
                }
                .overlay(
                    
                    GeometryReader { reader in
                        HStack(spacing: 0) {
                            
                            ForEach(gradientItem.colors) { figmaColor in
                                gradientOverlay(figmaColor, reader: reader)
                                    .overlay(
                                        buttonOverlay(figmaColor, reader: reader)
                                            .isHidden(hoveredItem?.id != figmaColor.id)
                                    ).clipped()
                            }
                        }
                    }.isHidden(!isHoveredView)
                )
                .foregroundColor(gradientItem.colors.first?.color.labelText())
            
        }
    }
    
    @ViewBuilder fileprivate func gradientOverlay(_ figmaColor: FigmaColor, reader: GeometryProxy) -> some View {
        figmaColor
            .color
            .frame(width: hoverWidth(item: figmaColor, reader: reader))
            .onHover { hovered in
                withAnimation(.easeInOut) {
                    if hovered {
                        hoveredItem = figmaColor
                    }
                    print("hex hover", figmaColor.hex, hovered)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    self.hoveredItem = figmaColor
                }
            }
            .id(figmaColor.hex)
    }
    
    @ViewBuilder fileprivate func buttonOverlay(_ figmaColor: FigmaColor, reader: GeometryProxy) -> some View {
        HStack(spacing: 8) {
            
            MRSmallButton("hex") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
            }
            
            MRSmallButton("rgba") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                let rgba = "\(figmaColor.red),\(figmaColor.green),\(figmaColor.blue),\(figmaColor.alpha)"
                pasteboard.setString(rgba, forType: NSPasteboard.PasteboardType.string)
            }
        }.padding(8)
        .frame(width: 120)
//        .animation(Animation.easeInOut.delay(0.2))
//        .transition(.flipFromRight)
//        .transition(AnyTransition.scale(scale: 0.2, anchor: .top).combined(with: AnyTransition.fade))
    }
    
    func hoverWidth(item: FigmaColor, reader: GeometryProxy) -> CGFloat {
        let width = reader.frame(in: .local).width
        let colorCount = CGFloat(gradientItem.colors.count)
        let hoveredWidth: CGFloat = 120//min(width / colorCount * 2, width / 2 * 1.3)
        
        let openWidth = width - hoveredWidth
        let unhovered = openWidth / (colorCount - 1)
//        print(hoveredWidth," as ", unhovered)
        
        if let hover = hoveredItem {
            if (hover.id == item.id) {
                return hoveredWidth
            } else {
                return unhovered
            }
        } else {
            return width / colorCount
        }
    }
}

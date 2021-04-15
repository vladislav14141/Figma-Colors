//
//  FigmaGradientCell.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 10.04.2021.
//

import SwiftUI

struct FigmaGradientCellItem: View {
    let gradientItem: FigmaGradient
    
//    @State var hoveredItem: FigmaColor?
    @State var isHoveredView = false
    @State var hoveredColorIndex: Int?


    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LinearGradient(gradient: gradientItem.gradient, startPoint: gradientItem.start, endPoint: gradientItem.end)
                .onHover { hover in
                    withAnimation(.easeInOut) {
                        
                        isHoveredView = hover
                        if hover == false {
                            hoveredColorIndex = nil
                        }
                    }
                }
                .overlay(
                    
                    GeometryReader { reader in
                        HStack(spacing: 0) {
                            
                            ForEach(0..<gradientItem.colors.count) { i in
                                let figmaColor = gradientItem.colors[i]
                                gradientOverlay(figmaColor, i: i, reader: reader)
                            }
                      
                        }
                        .overlay(
                            buttonOverlay()
                                .frame(width: hoveredWidth(reader).hoverWidth)
                                .offset(x: buttonOffset(reader: reader), y: 0)
                                .isHidden(hoveredColorIndex == nil)
                            ,alignment: .leading
                                
                        ).clipped()
                    }.isHidden(!isHoveredView)
                )
                .foregroundColor(gradientItem.colors.first?.color.labelText())
            
        }
    }
    
    @ViewBuilder fileprivate func gradientOverlay(_ figmaColor: FigmaColor, i: Int, reader: GeometryProxy) -> some View {
        figmaColor
            .color
            .frame(width: hoverWidth(i: i, reader: reader))
            .onHover { hovered in
                withAnimation(.easeInOut) {
                    if hovered {
                        hoveredColorIndex = i
                    }
                    print("hex hover", figmaColor.hex, hovered)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    self.hoveredColorIndex = i
                }
            }
            .id(figmaColor.hex)
    }
    
    @ViewBuilder fileprivate func buttonOverlay() -> some View {
        let figmaColor = gradientItem.colors[hoveredColorIndex ?? 0]
        HStack(spacing: 8) {
            
            MRSmallButton("HEX") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
            }.frame(width: 55)
            .id("Buttons j")

            MRSmallButton("RGBA") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                let rgba = "\(figmaColor.red),\(figmaColor.green),\(figmaColor.blue),\(figmaColor.alpha)"
                pasteboard.setString(rgba, forType: NSPasteboard.PasteboardType.string)
            }.frame(width: 55)
            .id("Buttons d")

        }.padding(8)
        .id("Buttons")
//        .animation(Animation.easeInOut.delay(0.2))
//        .offset(x: 0, y: 0)
//        .animation(Animation.easeInOut.delay(0.2))
//        .transition(.flipFromRight)
//        .transition(AnyTransition.scale(scale: 0.2, anchor: .top).combined(with: AnyTransition.fade))
    }
    var colorCount: CGFloat { CGFloat(gradientItem.colors.count) }
    
    func hoverWidth(i: Int, reader: GeometryProxy) -> CGFloat {
        let widths = hoveredWidth(reader)

        if let hoverIndex = hoveredColorIndex {
            if (hoverIndex == i) {
                return widths.hoverWidth
            } else {
                return widths.unHoverWidth
            }
        } else {
            return widths.width / colorCount
        }
    }
    
    func hoveredWidth(_ reader: GeometryProxy)-> (hoverWidth: CGFloat, unHoverWidth: CGFloat, width: CGFloat, openWidth: CGFloat) {
        let width = reader.frame(in: .local).width
        let hoveredWidth: CGFloat = max(120, width / 2 * 1.1)
        let openWidth = width - hoveredWidth
        let unhovered = openWidth / (colorCount - 1)
        return (hoveredWidth, unhovered, width, openWidth)
    }
    
    func buttonOffset(reader: GeometryProxy) -> CGFloat {
        let widths = hoveredWidth(reader)
        
        if let hoverIndex = hoveredColorIndex {
            return widths.unHoverWidth * CGFloat(hoverIndex)
        } else {
            return .zero
        }
    }
}

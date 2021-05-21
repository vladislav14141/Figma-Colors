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
    @State var isCopied = false {
        didSet {
            guard isCopied else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                isCopied = false
            }
        }
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LinearGradient(gradient: gradientItem.gradient, startPoint: gradientItem.start, endPoint: gradientItem.end)
                .whenHovered { hover in
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
            .frame(width: max(0, hoverWidth(i: i, reader: reader)))
            .whenHovered { hovered in
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
            if isCopied {
                Text("Copied")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(figmaColor.color.labelText())
            } else {
                Text(figmaColor.hex)
                    .foregroundColor(figmaColor.color.labelText())
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .onTapGesture {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                        pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
                        NSSound.funk?.play()
                        isCopied = true
                    }
            }
        }.padding(8)
        .id("Buttons")
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

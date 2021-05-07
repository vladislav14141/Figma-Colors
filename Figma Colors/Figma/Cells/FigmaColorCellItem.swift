//
//  FigmaColorCellItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI
struct FigmaColorCellItem: View {
     var figmaColor: FigmaColor?
    let scheme: FigmaSheme
    @State var isHover = false
    @State var isCopied = false {
        didSet {
            if isCopied {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    isCopied = false
                }
            }
        }
    }
    var body: some View {
        if let figmaColor = figmaColor {
            ZStack(alignment: scheme == .light ? .bottomTrailing : .topTrailing) {
                figmaColor.color.overlay(
                    VStack {
                        if isCopied {
                            
                            Text("Copied")
                                .font(.jetBrains(.body))
                                .foregroundColor(figmaColor.color.labelText())
                            
                        } else if isHover {
                            
                            HStack(spacing: 8) {
                                MRSmallButton("hex") {
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                                    pasteboard.setString(figmaColor.hex, forType: NSPasteboard.PasteboardType.string)
                                    isCopied = true
                                }
                                
                                MRSmallButton("rgba") {
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                                    let rgba = "\(figmaColor.red),\(figmaColor.green),\(figmaColor.blue),\(figmaColor.alpha)"
                                    pasteboard.setString(rgba, forType: NSPasteboard.PasteboardType.string)
                                    isCopied = true
                                }
                            }.padding(8)
                        }
                        
                    }
                )
                
            }.opacity(isHover ? 0.9 : 1)

            .whenHovered { over in
                isHover = over
            }
        }
    }
    
//    func copiedVie
    
    struct ColorButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .opacity(configuration.isPressed ? 0.8 : 1)
        }
    }
}

//struct SmallButton: View {
//    var body: some View {
//        Button("HEX") {
//            MRButton
//        }
//    }
//}

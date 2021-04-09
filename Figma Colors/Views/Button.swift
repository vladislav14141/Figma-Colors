//
//  Button.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 02.04.2021.
//

import Foundation
import SwiftUI

struct MRButtonStyle: ButtonStyle {
    
    var enabled: Bool
//    private var color: Color
    var backgroundColor: Color = .buttonBackground
    @Binding var isHovered: Bool
    
//    init(enabled: Bool = true, isHovered: Bool) {
//        self.enabled = enabled
//        self.isHovered = isHovered
//    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(backgroundColor(configuration))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .disabled(!enabled)
        
    }
    
    private func backgroundColor(_ configuration: Self.Configuration) -> Color {
        if enabled {
            if configuration.isPressed {
                return backgroundColor.opacity(0.5)
            } else if isHovered {
                print(isHovered)
                return backgroundColor.opacity(0.25)

            } else {
                return .clear
            }
        } else {
            return Color.white.opacity(0.1)
        }
    }
}

struct MRButton: View {
    var id: String {
        (icon ?? "") + (title ?? "")
    }
    private let icon: String?
    private let title: String?
    private var onTap: (()->())?
    private var font: Font
    private var enabled: Bool = true
    @State var isHovered = false

    init(iconName: String?, title: String?, enabled: Bool = true, onTap: (()->())? = nil) {
        self.title = title
        font = .callout
        self.icon = iconName
        self.onTap = onTap
        self.enabled = enabled
        
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }, label: {
            HStack {
                if let icon = icon {
                    Image(systemName: icon).font(.title3)
                }
                
                if let title = title {
                    Text(title).font(font)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .frame(minWidth: 32, maxWidth: .infinity)
            .frame(height: 32)
        })
        .buttonStyle(MRButtonStyle(enabled: enabled, isHovered: $isHovered))
        .onHover(perform: {
            isHovered = $0
        })
        
    }
}

//
//  Button.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 02.04.2021.
//

import Foundation
import SwiftUI

//struct MRButtonStyle: ButtonStyle {
//
//    var enabled: Bool
////    private var color: Color
//    var backgroundColor: Color = .buttonBackground
//    @Binding var isHovered: Bool
//
////    init(enabled: Bool = true, isHovered: Bool) {
////        self.enabled = enabled
////        self.isHovered = isHovered
////    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .background(backgroundColor(configuration))
//            .clipShape(RoundedRectangle(cornerRadius: 8))
//            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
//            .disabled(!enabled)
//
//    }
//
//    private func backgroundColor(_ configuration: Self.Configuration) -> Color {
//        if enabled {
//            if configuration.isPressed {
//                return backgroundColor.opacity(0.5)
//            } else if isHovered {
//                print(isHovered)
//                return backgroundColor.opacity(0.25)
//
//            } else {
//                return .clear
//            }
//        } else {
//            return Color.white.opacity(0.1)
//        }
//    }
//}

struct MRButtonStyle: ButtonStyle {
    enum ButtonType {
        case opacity
        case plain
        case scale(CGFloat = 0.9)
    }
    
    var type: ButtonType
    var isPressed: ((Bool)->())?
    func makeBody(configuration: Configuration) -> some View {
        configSetup(configuration).onChange(of: configuration.isPressed, perform: { value in
            isPressed?(value)
        })
    }
    
    @ViewBuilder func configSetup(_ configuration: Configuration) -> some View {
        switch type {
        case .opacity: opacityConfig(configuration)
        case .scale(let size): scaleMinConfig(configuration, size: size)
        case .plain: plainConfig(configuration)
            
        }
    }

    
    @ViewBuilder func plainConfig(_ configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
    
    @ViewBuilder func opacityConfig(_ configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(Animation.easeOut(duration: configuration.isPressed ? 0.05 : 0.2))

    }
    
    @ViewBuilder func scaleMinConfig(_ configuration: Configuration, size: CGFloat) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? size : 1)
            .animation(Animation.easeOut(duration: configuration.isPressed ? 0.05 : 0.2))

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
        .buttonStyle(MRButtonStyle(type: .plain))
        .whenHovered {
            isHovered = $0
        }
        
    }
}


struct MRSmallButton: View {
    
//    private let icon: String?
    @State var isHovered = false
    private let title: String?
    private var onTap: (()->())?
    
    init(_ title: String?, onTap: (()->())? = nil) {
        self.title = title
        self.onTap = onTap
    }
    var body: some View {
        Button(action: {
            onTap?()
        }, label: {
            HStack {
                if let title = title {
                    Text(title).customFont(.body).foregroundColor(isHovered ? .white : .label)
                }
            }
            .frame(minWidth: 44, maxWidth: .infinity)
            .frame(height: 44)
            .background(isHovered ? Color.smallButtonSelectedBackground : Color.smallButtonBackground)
            .cornerRadius(8)
            .overlay( onHover() )
        })
        .buttonStyle(MRSmallButtonStyle())

        .whenHovered {
            isHovered = $0
        }
    }
    
    @ViewBuilder func onHover() -> some View {
        if isHovered {
            RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1)
        }
    }
}

struct MRSmallButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .opacity(configuration.isPressed ? 0.90 : 1.0)
//            .background(configuration.isPressed ? Color.primary : Color.primary)

    }
}

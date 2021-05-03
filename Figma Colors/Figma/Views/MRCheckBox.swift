//
//  MRCheckBox.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 26.04.2021.
//

import SwiftUI

struct MRCheckBox: View {
    @Binding var isOn: Bool
    var onToggle: ((Bool)->()) = { _ in}
    var body: some View {
        Button(action: {
            isOn.toggle()
            onToggle(isOn)
        }, label: {
            Group {
                if isOn {
                    Image(systemName: "checkmark.circle.fill").renderingMode(.original).font(.system(size: 17, weight: .light))
                } else {
                    Image(systemName: "checkmark.circle").font(.system(size: 17, weight: .light))
                }
            }.background(Color.clear).clipShape(Circle())
        }).buttonStyle(MRButtonStyle1(type: .opacity))
    }
}

struct MRCheckBox1: View {
    var isOn: Bool
    var onToggle: ((Bool)->()) = { _ in}
    var body: some View {
        Button(action: {
//            isOn.toggle()
            onToggle(isOn)
        }, label: {
            Group {
                if isOn {
                    Image(systemName: "checkmark.circle.fill").renderingMode(.original).font(.system(size: 17, weight: .light))
                } else {
                    Image(systemName: "checkmark.circle").font(.system(size: 17, weight: .light))
                }
            }.transition(.fade).background(Color.clear).clipShape(Circle())
        }).buttonStyle(MRButtonStyle1(type: .opacity))
    }
}

struct MRButtonStyle1: ButtonStyle {
    enum ButtonType {
        case opacity
        case scale(CGFloat = 0.9)
    }
    var type: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configSetup(configuration)
    }
    
    @ViewBuilder func configSetup(_ configuration: Configuration) -> some View {
        switch type {
        case .opacity: opacityConfig(configuration)
        case .scale(let size): scaleMinConfig(configuration, size: size)
        }
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

struct MRCheckBox_Previews: PreviewProvider {
    static var previews: some View {
        MRCheckBox(isOn: .constant(true))
    }
}

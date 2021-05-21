//
//  Extension + View.swift
//  AppConstructor
//
//  Created by Владислав Миронов on 28.01.2021.
//

import SwiftUI

extension View {

    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
    
    @ViewBuilder func redacted(_ condition: Bool = true) -> some View {
        if !condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
    
    @ViewBuilder func gradiented(color: Color = Color.primaryBackground) -> some View {
        self.overlay(
            LinearGradient(gradient: .init(colors: [color.opacity(0.01), color]),
                           startPoint: .leading,
                           endPoint: .trailing)
                .frame(width: 24),
            alignment: .trailing)
    }
    
    @ViewBuilder func stokedLabel(_ stroked: Bool) -> some View {
        ZStack(alignment: .leading) {
            self
            VStack {

                Divider().animation(.easeIn).transition(.slide).isHidden(!stroked)
            }
        }.clipped()
    }
    
    func whenHovered(_ mouseIsInside: @escaping (Bool) -> Void) -> some View {
        modifier(MouseInsideModifier(mouseIsInside))
    }
    
}



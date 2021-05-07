//
//  FigmaCellLabel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 07.05.2021.
//

import SwiftUI

struct FigmaCellLabel: View {
    var text: String
    @Binding var isSelected: Bool
    @State var isHovered = false

    var body: some View {
        Text(text)
            .stokedLabel(!isSelected)
            .lineLimit(1)
            .customFont(.callout)
            .foregroundColor(foregroundColor())
            .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
            .background(Color.primaryBackground)
//            gradiented()
            .onTapGesture {
                isSelected.toggle()
            }
            .whenHovered { (isHovered) in
                self.isHovered = isHovered
            }
    }
    
    func foregroundColor() -> Color {
        let opacity: Double = isSelected ? 1 : 0.5
        return isHovered ? Color.blue.opacity(opacity) : Color.label.opacity(opacity)
    }
    
}

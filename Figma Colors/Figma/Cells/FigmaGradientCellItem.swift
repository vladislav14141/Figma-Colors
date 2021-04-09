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
    
    var body: some View {
        VStack {
            Text("").font(.headline).foregroundColor(.label)

            VStack(spacing: 0) {
                if let light = gradientItem.gradientLight, sheme == .light {
                    LinearGradient(gradient: light, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Light").font(.footnote)
                    ).foregroundColor(light.stops.first?.color.labelText())
                }
                
                if let dark = gradientItem.gradientDark, sheme == .dark {
                    LinearGradient(gradient: dark, startPoint: gradientItem.start, endPoint: gradientItem.end).overlay(
                        Text("Dark").font(.footnote)
                    ).foregroundColor(dark.stops.first?.color.labelText())
                }
            }
            .cornerRadius(16)
            .frame(height: 120)
        }
    }
}

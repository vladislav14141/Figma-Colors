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
        }).buttonStyle(MRButtonStyle(type: .plain))
    }
}


struct MRCheckBox_Previews: PreviewProvider {
    static var previews: some View {
        MRCheckBox(isOn: .constant(true))
    }
}

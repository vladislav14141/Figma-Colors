//
//  Textfield.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 02.04.2021.
//

import Foundation
import SwiftUI

struct MRTextfield: View {
    let title: String?
    let placeholder: String
    var tooltip: String?
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                HStack(spacing: 8) {
                    Text(title).font(.headline).tooltip(placeholder)
                    Spacer()
                    if let tip = tooltip {
                        Image(systemName: "questionmark.circle")
                            .font(.headline)
                            .tooltip(tip)
                    }
                }
            }
            TextField(placeholder, text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

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
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                
                Text(title).font(.headline)
            }
            TextField(placeholder, text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

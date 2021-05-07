//
//  FigmaImageCellItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FigmaImageCellItem: View {
    @ObservedObject var item: ComponentItem
    
    var body: some View {
        if let img = item.x3, let url = URL(string: img) {
            VStack(alignment: .leading, spacing: 8) {
                if let img = item.imageX3 {
                    VStack {
                        Image(nsImage: img).resizable().aspectRatio(contentMode: .fit).frame(width: min(img.size.height, 120), height: min(img.size.height, 120)).clipped()
                    }.frame(width: 120, height: 120, alignment: .center).background(Color.tertiaryBackground).cornerRadius(8)
                }
                FigmaCellLabel(text: item.shortName, isSelected: $item.isSelected)
            }
            
        }
    }
}

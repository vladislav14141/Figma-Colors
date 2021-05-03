//
//  FigmaImageCellItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct FigmaImageCellItem: View {
    let item: ComponentItem
    
    var body: some View {
        if let img = item.x3, let url = URL(string: img) {
            VStack(alignment: .leading, spacing: 8) {
                
                if let size = item.size {
                    VStack {
                        MRWebImage(url: url).frame(width: min(size.width, 120),height: min(size.height, 120)).clipped()
                        
                    }.frame(width: 120, height: 120, alignment: .center).background(Color.tertiaryBackground).cornerRadius(8)
                    
                    
                } else {
                    MRWebImage(url: url).frame(height: 120).clipped()
                }
                Text(item.shortName)
                    .frame(minWidth: 120, maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .customFont(.callout)
                    .foregroundColor(.label)
                    .overlay(
                        LinearGradient(gradient: .init(colors: [Color.primaryBackground.opacity(0.01), .primaryBackground]),
                                       startPoint: .leading,
                                       endPoint: .trailing).frame(width: 24),
                        alignment: .trailing)
            }
            
        }
    }
}

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
            VStack {
                Text(item.fullName).font(.headline).frame(height: 32, alignment: .bottom)
                if let size = item.size {
                    VStack {
                        WebImage(url: url).resizable().scaledToFit().frame(width: min(size.width, 120),height: min(size.height, 120)).clipped()
                        
                    }.frame(width: 120, height: 120, alignment: .center).background(Color.tertiaryBackground).cornerRadius(8)
                    
                    
                } else {
                    
                    WebImage(url: url).resizable().scaledToFit().frame(height: 120).clipped()
                }
            }
            
        }
    }
}

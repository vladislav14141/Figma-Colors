//
//  GradientsPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct GradientsPage: View {
    
    @Binding var items: [FigmaSection<GradientItem>]
    
    fileprivate let lazyStackSpacing: CGFloat = 16
    fileprivate let gradientColumns = [
        GridItem(.flexible(minimum: 200, maximum: 640), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid (
            columns: gradientColumns,
            alignment: .leading,
            spacing: lazyStackSpacing,
            pinnedViews: [.sectionHeaders] )
        {
            ForEach(items) { section in
                
                Section(header: PageHeaderView(title: section.name)) {
                    
                    
                    ForEach(section.rows) { row in
                        FigmaGradientCellItem(gradientItem: row, sheme: .light)
//                        HStack(alignment: .bottom, spacing: 16) {
//
//                            HStack(spacing: 8) {
//
//                                FigmaGradientCellItem(gradientItem: row, sheme: .light).frame(width: 160)
//                                FigmaGradientCellItem(gradientItem: row, sheme: .dark).frame(width: 160)
//                            }
//                            Divider().frame(height: 120)
//                            HStack(spacing: 8) {
//
//                                ForEach(row.colors) { color in
//                                    FigmaColorCell(colorItem: color).frame(width: 120)
//
//                                }
//                            }
//                        }
                    }
                }
            }
        }.padding()
    }
}

//struct GradientsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        GradientsPage(items: .constant([.init(name: "Guard", colors: [.init(figmaName: "guard/green", colors: [], colorLocation: [0,1], start: .leading, end: .topTrailing)])]))
//    }
//}

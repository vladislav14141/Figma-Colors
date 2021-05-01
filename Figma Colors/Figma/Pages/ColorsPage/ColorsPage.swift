//
//  ColorsPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct ColorsPage: View {
    
    @Binding var items: [FigmaSection<ColorItem>]
    
    fileprivate let lazyStackSpacing: CGFloat = 16
    fileprivate let colorColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            
            LazyVGrid (
                columns: colorColumns,
                alignment: .leading,
                spacing: lazyStackSpacing,
                pinnedViews: [] ) {
                ForEach(items) { section in
                    
                    Section(header: PageHeaderView(title: section.name)) {
                        ForEach(section.rows) { row in
                            FigmaColorCell(colorItem: row)
                        }
                    }
                }
            }.padding()
        }.background(Color.primaryBackground)
    }
}

struct ColorsPage_Previews: PreviewProvider {
    static var previews: some View {
        ColorsPage(items: .constant([]))
    }
}

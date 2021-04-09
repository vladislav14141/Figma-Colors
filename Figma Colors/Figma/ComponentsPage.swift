//
//  ComponentsPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct ComponentsPage: View {
    
    @Binding var items: [FigmaSection<ImageItem>]
    
    fileprivate let lazyStackSpacing: CGFloat = 16
    fileprivate let colorColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .leading,
            spacing: lazyStackSpacing,
            pinnedViews: [.sectionHeaders] )
        {
            ForEach(items) { section in
                Section(header: PageHeaderView(title: section.name)) {
                    ForEach(section.rows) { row in
                        FigmaImageCellItem(item: row)
                    }
                }
            }
        }.padding()
        
    }
}

struct ComponentsPage_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsPage(items: .constant([]))
    }
}

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
    @EnvironmentObject var storage: FigmaStorage
    @State var selected: String?
    var body: some View {
        ScrollView {
            if storage.isLoading {
                MockPage()
            } else {
                
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
                        }.isHidden(!(selected == nil || section.name == selected))
                    }
                }.padding()
            }
        }.background(Color.primaryBackground).frame(minWidth: 600,idealWidth: 650, maxWidth: .infinity).layoutPriority(5)
        
    }
}

struct ColorsPage_Previews: PreviewProvider {
    static var previews: some View {
        ColorsPage(items: .constant([]))
    }
}

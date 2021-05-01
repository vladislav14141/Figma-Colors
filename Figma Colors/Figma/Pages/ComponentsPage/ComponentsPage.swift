//
//  ComponentsPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI
import Grid
struct ComponentsPage: View {
    
    @Binding var items: [FigmaSection<ComponentItem>]
    
    fileprivate let lazyStackSpacing: CGFloat = 16
    fileprivate let colorColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    @StateObject var viewModel = ComponentViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid (
                columns: colorColumns,
                alignment: .leading,
                spacing: lazyStackSpacing,
                pinnedViews: [.sectionHeaders] )
            {
                ForEach(items) { section in
                    Section(header: PageHeaderView(title: "grey")) {
                        ForEach(section.rows) { row in
                            FigmaImageCellItem(item: row)
                        }
                    }
                }
            }.padding()
            .onAppear {
                viewModel.fetchComponents()
            }
        }
    }
}

struct ComponentsPage_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsPage(items: .constant([]))
    }
}

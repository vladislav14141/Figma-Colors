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
        GridItem(.adaptive(minimum: 260, maximum: 320), spacing: 16)
    ]
    @State var selected: String?

    var body: some View {
        ScrollView {
            
            LazyVGrid (
                columns: gradientColumns,
                alignment: .leading,
                spacing: lazyStackSpacing,
                pinnedViews: [.sectionHeaders] )
            {
                ForEach(items) { section in
                    
                    Section(header: PageHeaderView(title: section.name)) {
                        
                        
                        ForEach(section.rows) { row in
                            FigmaGradientCell(gradientItem: row)
                            
                        }
                    }.isHidden(!(selected == nil || section.name == selected))
                }
            }.padding()
        }.background(Color.primaryBackground)
    }
}

//struct GradientsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        GradientsPage(items: .constant([.init(name: "Guard", colors: [.init(figmaName: "guard/green", colors: [], colorLocation: [0,1], start: .leading, end: .topTrailing)])]))
//    }
//}

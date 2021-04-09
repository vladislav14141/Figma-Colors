//
//  MockPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct MockPage: View {
        
    fileprivate var lazyStackSpacing: CGFloat = 16
    fileprivate let colorColumns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid (
            columns: colorColumns,
            alignment: .center,
            spacing: lazyStackSpacing,
            pinnedViews: [] )
        {
            ForEach(0..<5, id: \.self) { section in
                
                Section(header: PageHeaderView(title: "section.name")) {
                    
                    ForEach(1..<12, id: \.self) { row in
                        FigmaColorCell().id("\(section) - \(row)")
                    }
                }
            }.redacted()
        }
    }
}

struct MockPage_Previews: PreviewProvider {
    static var previews: some View {
        MockPage()
    }
}

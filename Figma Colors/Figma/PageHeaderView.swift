//
//  PageHeaderView.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import SwiftUI

struct PageHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title.capitalized).font(.title2).bold().padding(.top).padding(4)//.offset(x: 8, y: 16)
            Spacer()
        }.background(Color.primaryBackground)
    }
}

struct PageHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PageHeaderView(title: "Primary")
    }
}

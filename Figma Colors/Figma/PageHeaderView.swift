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
        HStack(alignment: .bottom) {
            Text(title.lowercased()).customFont(.title).padding(.top, 40)
            Spacer()
        }.background(Color.primaryBackground)
    }
}

struct PageHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PageHeaderView(title: "Primary")
    }
}

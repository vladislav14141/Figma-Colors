//
//  TestPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import SwiftUI
import Cocoa
struct TestPage: View {
    var body: some View {
//        for family in Font.familyNames.sorted() {
//            let names = Font.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        VStack {
//            Text("gray").font(.custom("JetBrainsMono-Bold", size: 48, relativeTo: Font.TextStyle.title))
//            Text("gray").font(.custom("Jets.ttf", size: 48, relativeTo: Font.TextStyle.title))
//            Text("gray").font(.custom("Jets.ttf", size: 48, relativeTo: Font.TextStyle.title))

            ForEach(JetBrainsFont.allCases, id: \.rawValue) { font in
                HStack {
                    Text("gray").customFont(font).background(Color.random())
                    Spacer()
                    Text("\(font.name) \(Int(font.size)) \(font.weight.0)\nblad").lineLimit(nil).lineSpacing(100).font(.jetBrains(font)).background(Color.random())
                }
            }
        }
    }
}

struct TestPage_Previews: PreviewProvider {
    static var previews: some View {
        TestPage()
    }
}

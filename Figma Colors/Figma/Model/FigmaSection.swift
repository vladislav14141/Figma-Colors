//
//  FigmaSection.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation

//class FigmaSection: Identifiable {
//    var id: String {
//        return name
//    }
//    let name: String
//    var colors = [FigmaRow]()
//    
//    internal init(name: String, colors: [FigmaRow] = [FigmaRow]()) {
//        self.name = name
//        self.colors = colors
//    }
//}

class FigmaSection: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var colors = [FigmaRow]()
    
    internal init(name: String, colors: [FigmaRow] = [FigmaRow]()) {
        self.name = name
        self.colors = colors
    }
}

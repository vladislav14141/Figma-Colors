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

class FigmaSection<Row: Identifiable>: Identifiable where Row.ID == String {
    var id: String {
        return name
    }
    
    /// "danger"
    let name: String

    private(set) var colorsName = Set<Row.ID>()
    private(set) var rows: [Row] = []
    
    internal init(name: String, colors: [Row] = [Row]()) {
        self.name = name
        self.rows = colors
    }
    
    func append(_ object: Row) {
        if colorsName.contains(object.id) == false {
            rows.append(object)
            colorsName.insert(object.id)
        }
    }
    
    func sortColors() {
        rows.sort(by: {$0.id < $1.id})
    }
}

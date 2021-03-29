//
//  ExportModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 28.03.2021.
//

import SwiftUI

class ExportModel: Identifiable, Hashable {
    
    var id = UUID()
    var buttons:  [ExportButtonModel] {return []}
    var title: String { "Unknown" }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
//
    static func == (lhs: ExportModel, rhs: ExportModel) -> Bool {
        return lhs.id > rhs.id
    }
    
}

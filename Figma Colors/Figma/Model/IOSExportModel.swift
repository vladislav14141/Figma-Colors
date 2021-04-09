//
//  IOSExportModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 28.03.2021.
//

import SwiftUI

class ExportStorage {
    static let shared = ExportStorage()
    var colors = [FigmaSection<ColorItem>]()
    var gradient = [FigmaSection<GradientItem>]()
    
    init() {
        
    }
}

struct ExportButtonModel: Identifiable {
    var id = UUID()
    let title: String
    let handle: ()->()
}

class ExportModel: Identifiable, Hashable {
    
    var id = UUID()
    var buttons:  [MRButton] {return []}
    var title: String { "Unknown" }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
//
    static func == (lhs: ExportModel, rhs: ExportModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}

class IOSExportModel: ExportModel {
    override var title: String { "iOS" }
    override var buttons: [MRButton] {
        return [
            MRButton(iconName: nil, title: "Code") {
                
            }
        ]
    }
}
class IOSAssetsExportModel: ExportModel {
    
    override var title: String { "iOS Assets" }
    
    let directoryHelper = DirectoryHelper()
    
    override var buttons: [MRButton] {
        return [
            MRButton(iconName: nil, title: "Code") {
                print("Code")
            },
            MRButton(iconName: nil, title: "Download Assets") { [weak self] in
                self?.directoryHelper.downloadAssets()
            }
        
        ]
    }
}

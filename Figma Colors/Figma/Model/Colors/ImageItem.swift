//
//  ImageItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import Foundation

class ImageItem: Identifiable, FigmaSectionProtocol {
    var fullName: String {
        var name = ""
        switch settings.nameCase {
        case .camelcase:
            name = figmaNameComponents.enumerated().map{
                if $0 == 0 {
                    return $1
                } else {
                    return $1.capitalized
                }
            }.joined()
        case .snakecase:
            name = figmaNameComponents.joined(separator: "_")
        }
        return name
    }
    
    
    let id = UUID()

//    var id: String {
//        return name
//    }
    var groupName: String
    let figmaNameComponents: [String]

    let figmaName: String
    var x3: String?
    var x2: String?
    var x1: String?
    @Published var size: CGSize?

    internal init(figmaName: String) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        self.figmaNameComponents = nameComponents
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : ""

        self.figmaName = figmaName
    }
}

//
//  FigmaModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import Foundation


// MARK: - ObjectModel
struct FigmaModel: Codable {
//    let document: Document
    let components: [String: FigmaComponent]
//    let schemaVersion: Int
    let styles: [String: FigmaComponent]
    let name: String
//    let lastModified: Date
//    let thumbnailURL: String
//    let version, role: String

//    enum CodingKeys: String, CodingKey {
//        case document, components, schemaVersion, styles, name, lastModified
//        case thumbnailURL
//        case version, role
//    }
}

// MARK: - Component
struct FigmaComponent: Codable {
    let key, name, description: String
    let styleType: FigmaStyleType?
}

enum FigmaStyleType: String, Codable {
    case fill = "FILL"
    case text = "TEXT"
    case effect = "EFFECT"
    case grid = "GRID"

}
// MARK: - Component
//struct StyleModel: Codable {
//    let key, name, description, nodeId: String
//    let styleType: String?
//    
//}
//struct FigmaModel: Codable {
//    let error: Bool
//    let status: Int
//    let meta: MetaModel
//}

//struct MetaModel: Codable {
//    let styles: [StyleModel]
//}

//FILL
//TEXT
//EFFECT
//GRID

//SOLID
//GRADIENT_LINEAR
//GRADIENT_RADIAL
//GRADIENT_ANGULAR
//GRADIENT_DIAMOND
//IMAGE
//EMOJI

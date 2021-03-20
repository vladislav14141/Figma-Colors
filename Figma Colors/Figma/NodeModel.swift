//
//  NodeModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 20.03.2021.
//

import Foundation

// MARK: - ObjectModel
struct NodeModel: Codable {
//    let name: String
//    let lastModified: Date
//    let thumbnailURL: String
//    let version, role: String
    let nodes: [String: Node]

//    enum CodingKeys: String, CodingKey {
//        case name, lastModified
//        case thumbnailURL
//        case version, role, nodes
//    }
    
    // MARK: - Node
    struct Node: Codable {
        let document: Document
//        let components: Components
//        let schemaVersion: Int
//        let styles: Components
    }

//    // MARK: - Components
//    struct Components: Codable {
//    }
//
    // MARK: - Document
    struct Document: Codable {
//        let name: String?
        let id, name: String
        let blendMode: String?
        let type: String

//        let absoluteBoundingBox: AbsoluteBoundingBox
//        let constraints: Constraints
        let fills: [Fill]
        let strokes: [Fill]
        let strokeWeight: Int
        let strokeAlign: String
        let effects: [Fill]
    }
//
//    // MARK: - AbsoluteBoundingBox
//    struct AbsoluteBoundingBox: Codable {
//        let x, y, width, height: Double
//    }
//
//    // MARK: - Constraints
//    struct Constraints: Codable {
//        let vertical, horizontal: String
//    }

    // MARK: - Fill
    struct Fill: Codable {
        let blendMode, type: String
        let color: Color?
    }

    // MARK: - Color
    struct Color: Codable {
        let r, g, b: Double
        let a: Double
    }
}




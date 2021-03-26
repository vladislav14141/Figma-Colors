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
    }

//    // MARK: - Components
//    struct Components: Codable {
//    }
//
    
    enum FillType: String, Codable {
        case linearG = "GRADIENT_LINEAR"
        case solid = "SOLID"
    }
    // MARK: - Document
    struct Document: Codable {

        let id, name: String
        let blendMode: String?
        let type: String

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
    struct Point: Codable {
        let x: Double
        let y: Double
    }
    
    struct GradienColor: Codable {
        let position: Double
        let color: Color
    }
    
    struct Fill: Codable {
        let opacity: Double?
        let type: FillType
        let blendMode: String
        let color: Color?
        let gradientHandlePositions: [Point]?
        let gradientStops: [GradienColor]?
    }

    // MARK: - Color
    struct Color: Codable {
        let r, g, b: Double
        let a: Double
    }
}




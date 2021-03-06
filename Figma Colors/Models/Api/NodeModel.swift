
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
        case solid = "SOLID"
        case linearG = "GRADIENT_LINEAR"
        case radialG = "GRADIENT_RADIAL"
        case angularG = "GRADIENT_ANGULAR"
        case diamonG = "GRADIENT_DIAMOND"
        case image = "IMAGE"
        case emoji = "EMOJI"
    }
    
    // MARK: - Document
    struct Document: Codable {

        let id, name: String
        let blendMode: String?
        let type: DocumentType
        let absoluteBoundingBox: BoundingBox?

        let fills: [Fill]
        let strokes: [Fill]
        let strokeWeight: Float
        let strokeAlign: String
        let effects: [Fill]
        
        
    }
    
    struct BoundingBox: Codable {
        let width: CGFloat
        let height: CGFloat
    }
    
    enum DocumentType: String, Codable {
        case component = "COMPONENT"
        case rectangle = "RECTANGLE"
        case text = "TEXT"
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
        let position: Float
        var color: Color
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
        var a: Double
    }
}



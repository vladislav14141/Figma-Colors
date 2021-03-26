//
//  FigmaViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import Combine
import SwiftUI
class FigmaGradientColor: Identifiable {
    var id: String {
        return name
    }
    
    var name: String
    let figmaName: String
    var groupName: String?
    var light: [FigmaColor]?
    var dark: [FigmaColor]?
    
    internal init(figmaName: String, light: [FigmaColor]? = nil, dark: [FigmaColor]? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        let name = nameComponents.joined(separator: "-")
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.light = light
        self.dark = dark
    }
}
class FigmaRow: Identifiable {
    var id: String {
        return name
    }

    var name: String
    let figmaName: String
    var groupName: String?
    var light: FigmaColor?
    var dark: FigmaColor?
    
    internal init(figmaName: String, light: FigmaColor? = nil, dark: FigmaColor? = nil) {
        let nameComponents = figmaName.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        let name = nameComponents.joined(separator: "-")
        self.name = name
        self.figmaName = figmaName
        self.groupName = nameComponents.count > 1 ? nameComponents[0] : nil
        self.light = light
        self.dark = dark
    }
}

class FigmaColor: Identifiable {
    let color: Color
    let hex: String
    
    let red: Double
    let blue: Double
    let green: Double
    let alpha: Double
    
    init(r: Double, g: Double, b: Double, a: Double) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
        self.color = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
        self.hex = FigmaColor.rgbToHex(r: r, g: g, b: b, a: a)
    }
    
    static func rgbToHex(r: Double, g: Double, b: Double, a: Double) -> String {
        if a == 1 {
            
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "%06x", rgb)
        } else {
            let rgba:Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0
            return String(format: "%08x", rgba)
        }

    }
}

enum FigmaSheme {
    case light
    case dark
}

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

class FigmaViewModel: ObservableObject {
    // MARK: - Public Properties
    @AppStorage("fileKeyLight") var fileKeyLight: String = ""
    @AppStorage("fileKeyDark") var fileKeyDark: String = ""
    @AppStorage("X-Figma-Token") var figmaToken: String = ""
    
    @Published var isLoading = false

    // MARK: - Private Methods
    let dataFetcher = NetworkDataFetcher()

    @Published var figmaColors = [FigmaSection]()
    var sections: [String: FigmaSection] = [:]
    var colors: [String: FigmaRow] = [:]
    
    // MARK: - Lifecycle
    init() {
        
    }
    
    func clearData() {
        figmaColors.removeAll()
        colors.removeAll()
        sections.removeAll()
    }
    
    fileprivate func fetchFigmaStyles(sheme: FigmaSheme) {
        isLoading = true
        let url = "https://api.figma.com/v1/files/\(keyFor(sheme: sheme))/styles"
        print(url)
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: FigmaModel.self, completion: { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
            case .success(let success):
                
                let styles: [String] = success.meta.styles.compactMap({
                    if $0.styleType == "FILL" {
                        return $0.nodeId
                    } else {
                        return nil
                    }
                })
                self.getNode(nodeIds: styles.joined(separator: ","), sheme: sheme)
                print(success)
                
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func getData() {
        clearData()
        if fileKeyLight.isEmpty == false {
            fetchFigmaStyles(sheme: .light)
        }
        
        if fileKeyDark.isEmpty == false {
            fetchFigmaStyles(sheme: .dark)
        }
    }
    
    fileprivate func getFigmaColor(name: String, rgb: NodeModel.Color, sheme: FigmaSheme) -> FigmaRow {
        switch sheme {
     
        case .light:
            return FigmaRow(figmaName: name, light: .init(r: rgb.r, g: rgb.g, b: rgb.b, a: rgb.a))
        case .dark:
            return FigmaRow(figmaName: name, dark: .init(r: rgb.r, g: rgb.g, b: rgb.b, a: rgb.a))

        }
    }
    
    fileprivate func getColorSection(name: String, rgb: NodeModel.Color, sheme: FigmaSheme) {
        let figmaColor = getFigmaColor(name: name, rgb: rgb, sheme: sheme)
        let groupName = figmaColor.groupName
        DispatchQueue.main.async {
            if let section = self.sections[groupName ?? ""] {
                if let row = self.colors[figmaColor.name] {
                    switch sheme {
                    case .light:
                        row.light = figmaColor.light
                    case .dark:
                        row.dark = figmaColor.dark
                    }
                    
                } else {
                    self.colors[figmaColor.name] = figmaColor
                    section.colors.append(figmaColor)
                }
            } else {
                self.sections[groupName ?? ""] = FigmaSection(name: groupName ?? "", colors: [figmaColor])
                self.colors[figmaColor.name] = figmaColor
            }
        }
    }
    
//    fileprivate func getGradientSection(_ value: NodeModel.Node, sheme: FigmaSheme) {
//        guard let figmaColor = getFigmaColor(value.document, sheme: sheme) else { return }
//        let groupName = figmaColor.groupName
//        DispatchQueue.main.async {
//            if let section = self.sections[groupName ?? ""] {
//                if let row = self.colors[figmaColor.name] {
//                    switch sheme {
//                    case .light:
//                        row.light = figmaColor.light
//                    case .dark:
//                        row.dark = figmaColor.dark
//                    }
//
//                } else {
//                    self.colors[figmaColor.name] = figmaColor
//                    section.colors.append(figmaColor)
//                }
//            } else {
//                self.sections[groupName ?? ""] = FigmaSection(name: groupName ?? "", colors: [figmaColor])
//                self.colors[figmaColor.name] = figmaColor
//            }
//        }
//    }
    
    func keyFor(sheme: FigmaSheme) -> String {
        switch sheme {
       
        case .light:
            return fileKeyLight
        case .dark:
            return fileKeyDark

        }
    }
    
    func getNode(nodeIds: String, sheme: FigmaSheme) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let url = "https://api.figma.com/v1/files/\(keyFor(sheme: sheme))/nodes?ids=\(nodeIds)"
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: NodeModel.self) {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch $0 {
            
            case .success(let responce):
                
                responce.nodes.forEach { key, value in
                    
                    let fills = value.document.fills
                    
                    for (i, fill) in fills.enumerated() {
                        
                        let subname = fills.count == 1 ? "" : "-\(i)"
                        
                        switch fill.type {
                        
                        case .linearG:
                            if let colors = fill.gradientStops {
                                for (i, color) in colors.enumerated() {
                                    let subname2 = colors.count == 1 ? "" : "-\(i)"

                                    self.getColorSection(name: value.document.name + subname + subname2, rgb: color.color, sheme: sheme)
                                }
                            }
                            
                        case .solid:
                            if let color = fill.color {
                                
                                self.getColorSection(name: value.document.name, rgb: color, sheme: sheme)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    let keysSorted = self.sections.keys.sorted(by: >)
                    let sortedSection: [FigmaSection] = keysSorted.compactMap {
                        let section = self.sections[$0]
                        section?.colors.sort(by: {$0.name < $1.name })
                        return section
                    }
                    self.figmaColors = sortedSection
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    // MARK: - Public methods

    
    // MARK: - Private Methods
    
}
import Cocoa
extension Color {
    static let label = Color(NSColor.labelColor)
    func labelText() -> Color {
        if let rgb = rgb() {
            var sum = 0
            [rgb.blue, rgb.red, rgb.green].forEach({
                sum += $0
            })
            return sum > (255 * 3) / 2 ? .black : .white
        }
        return .label
    }
    
    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        let color = NSColor(self)
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
//        if  {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
//        } else {
//            // Could not extract RGBA components:
//            return nil
//        }
    }
    
    public func rgbToHex() -> String {
        let color = NSColor(self)
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
}


extension String {
    func hexStringToUIColor() -> (CGFloat, CGFloat, CGFloat, CGFloat){
        let r, g, b, a: CGFloat
        let hex = self.hasPrefix("#") ? String(self.dropFirst()) : self
        
        if hex.count == 8 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                return (r,g,b,a)
            }
        } else if hex.count == 6 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                a = 1
                return (r,g,b,a)
            }
        }
        return (0,0,0,1)
    }
}

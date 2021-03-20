//
//  FigmaViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import Combine
import SwiftUI
struct FigmaColor1: Identifiable {
    var id: String {
        return name
    }
    var hex: String
    var rgbLight: (Double, Double, Double, Double)
    var rgbDark: (CGFloat, CGFloat, CGFloat, CGFloat)?

    var name: String
    let figmaName: String
    var groupName: String?
    var light: Color
    var dark: Color?
}

class FigmaViewModel: ObservableObject {
    // MARK: - Public Properties
    @AppStorage("fileKeyLight") var fileKeyLight: String = ""
    @AppStorage("fileKeyDark") var fileKeyDark: String = ""
    @AppStorage("X-Figma-Token") var figmaToken: String = ""
    
    @Published var isLoading = false

    // MARK: - Private Methods
    let dataFetcher = NetworkDataFetcher()
    @Published var colors = [Color]()
    @Published var figmaColors = [FigmaColor1]()
    // MARK: - Lifecycle
    init() {
        
    }
    
    func getData() {
        isLoading = true
        dataFetcher.fetchGenericJsonData(urlString: "https://api.figma.com/v1/files/\(fileKeyLight)", decodeBy: FigmaModel.self, completion: { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
            case .success(let success):
                
                let styles = success.styles.map({$0.key})//.filter({$0.description.count == 6 && $0.styleType == "FILL"})
                self.getNode(nodeIds: styles.joined(separator: ","))
                print(success)
                
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func getNode(nodeIds: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let url = "https://api.figma.com/v1/files/\(fileKeyLight)/nodes?ids=\(nodeIds)"
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: NodeModel.self) {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch $0 {
            
            case .success(let responce):
                var colors = [FigmaColor1]()
                
                responce.nodes.forEach { key, value in
                    if let rgb = value.document.fills.first?.color, value.document.type == "RECTANGLE"{
//                        let rgb = fill.color
                        let color = Color(.sRGB, red: rgb.r, green: rgb.g, blue: rgb.b, opacity: rgb.a)
                        let nameComponents = value.document.name.components(separatedBy: #"/"#).map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
                        let name = nameComponents.joined(separator: "-")
                        let groupName = nameComponents.count > 1 ? nameComponents[0] : nil
                        let figmaColor = FigmaColor1(hex: "", rgbLight: (rgb.r, rgb.g,rgb.b,rgb.a), rgbDark: nil, name: name, figmaName: value.document.name, groupName: groupName, light: color, dark: nil)
//                        colors.append(Color(.sRGB, red: rgb.r, green: rgb.g, blue: rgb.b, opacity: rgb.a))
                        colors.append(figmaColor)
                        
                    }
                }
                colors.sort(by: {$0.name > $1.name})
                
                DispatchQueue.main.async {
                    self.figmaColors = colors
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    // MARK: - Public methods

    
    // MARK: - Private Methods
    
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

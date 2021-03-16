//
//  MainViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021.
//

import SwiftUI

struct FigmaColor: Identifiable {
    var id: String {
        return name
    }
    var hex: String
    var rgbLight: (CGFloat, CGFloat, CGFloat, CGFloat)
    var rgbDark: (CGFloat, CGFloat, CGFloat, CGFloat)

    var name: String
    var groupName: String {
        name.components(separatedBy: "-").first ?? ""
    }
    var light: Color
    var dark: Color
}

class MainViewModel: ObservableObject {
    let fileManager = FileManager.default
    @AppStorage("lightColors") var lightColors: String = ""
    @AppStorage("darkColors") var darkColors: String = ""
    @AppStorage("folderName") var folderName: String = "Figma Colors"
    @Published var parsedColors = [FigmaColor]()

    
    func createFolder(name: String? = nil) -> String? {
        let name = name ?? folderName
        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let downloadsDirectoryWithFolder = downloadsDirectory.appendingPathComponent(name).path

        do {
            if fileManager.fileExists(atPath: downloadsDirectoryWithFolder) {
                return createFolder(name: name + " 1")
            }
            try fileManager.createDirectory(atPath: downloadsDirectoryWithFolder, withIntermediateDirectories: true, attributes: nil)

            printInConsole("Folder created - \(downloadsDirectoryWithFolder)")
            return downloadsDirectoryWithFolder
        } catch let error as NSError {
            printInConsole("Folder created Error - \(error.localizedDescription)")
            return nil
        }
    }
    
    func createColorset(name: String, directoryPath: String) -> String? {
        let colorName = name.components(separatedBy: "-")[0]
        
        do {
            let path = "\(directoryPath)/\(colorName)"
            let fullPath = "\(path)/\(name).colorset"
            
            if fileManager.fileExists(atPath: path) == false {

                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            print("creating colorSet", fullPath)
            try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            
            return fullPath
            
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            return nil
        }
    }
    
    func printInConsole(_ message:Any){
        print("====================================")
        print("\(message)")
        print("====================================")
    }
    
    func removeData() {
        parsedColors.removeAll()
    }
    
    fileprivate func saveGradient(_ color: String, _ colorDark: String, _ name: String, _ folder: String) {
        let firstColor = color.components(separatedBy: " ")[1]
        let secondColor = color.components(separatedBy: " ")[3]
        
        let firstColorBlack = colorDark.components(separatedBy: " ")[1]
        let secondColorBlack = colorDark.components(separatedBy: " ")[3]

        saveColor(name + "_1", folder, firstColor, firstColorBlack)
        saveColor(name + "_2", folder, secondColor, secondColorBlack)
    }
    
    
    fileprivate func saveColor(_ name: String, _ folder: String, _ color: String, _ colorDark: String) {
        if let dir = createColorset(name: name, directoryPath: folder) {
            let light = hexStringToUIColor(hex: color)
            let dark = hexStringToUIColor(hex: colorDark)
            
            let colorLight = Color(red: Double(light.0), green: Double(light.1), blue: Double(light.2), opacity: Double(light.3))
            let colorDark = Color(red: Double(dark.0), green: Double(dark.1), blue: Double(dark.2), opacity: Double(dark.3))
            
            let figmaColors = FigmaColor(hex: color, rgbLight: light, rgbDark: dark, name: name, light: colorLight, dark: colorDark)
            parsedColors.append(figmaColors)
            createContentsJSON(folderPath: dir,
                               data: getJson(light: light,
                                             dark: dark))
        }
    }
    
    func generateColor() {
        guard let folder = createFolder() else { return }
        removeData()
        let lines = lightColors.components(separatedBy: "\n").filter({$0.isEmpty == false})
        let linesDark = darkColors.components(separatedBy: "\n").filter({$0.isEmpty == false})
        
        for i in 0..<lines.count {
            let components = lines[i].components(separatedBy: ": ")
            let name = components[0]
            let color = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let colorDark = linesDark[i].components(separatedBy: ": ")[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if color.prefix(6) == "linear" {
                saveGradient(color, colorDark, name, folder)
                
            } else {
                
                saveColor(name, folder, color, colorDark)
            }
        }
    }
    
    func getJson(light: (CGFloat, CGFloat,CGFloat, CGFloat), dark: (CGFloat, CGFloat,CGFloat, CGFloat)) -> Data? {
        let json = """
    {
      "colors" : [
        {
          "color" : {
            "color-space" : "srgb",
            "components" : {
              "alpha" : "\(light.3)",
              "blue" : "\(light.2)",
              "green" : "\(light.1)",
              "red" : "\(light.0)"
            }
          },
          "idiom" : "universal"
        },
        {
          "appearances" : [
            {
              "appearance" : "luminosity",
              "value" : "dark"
            }
          ],
          "color" : {
            "color-space" : "srgb",
            "components" : {
              "alpha" : "\(dark.3)",
              "blue" : "\(dark.2)",
              "green" : "\(dark.1)",
              "red" : "\(dark.0)"
            }
          },
          "idiom" : "universal"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """
        return json.data(using: .utf8)
    }
    
    func createContentsJSON(folderPath: String, data: Data?) {
        fileManager.createFile(atPath: "\(folderPath)/Contents.json", contents: data, attributes: nil)
        print("Writing \(folderPath)")
    }
    
    func hexStringToUIColor(hex: String) -> (CGFloat, CGFloat, CGFloat, CGFloat){
        let r, g, b, a: CGFloat
        let hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
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
/*
//let templateName = "MVVM SwiftUI.xctemplate"
//let destinationPath = "/Users/vladislavmironov/Downloads/Figma-Colors"










let colors =
    """
gray-01: #FFFFFF
gray-02: #FFFFFF
gray-03: #FFFFFF
gray-04: #FFFFFF
gray-05: #FAFAFA
gray-06: #F5F5F5
gray-07: #E5E5E5
gray-08: #D9D9D9
gray-09: #D1D1D1
gray-10: #BFBFBF
gray-11: #C7C7C7
gray-12: #A6A6A6
gray-13: #999999
gray-14: #808080
gray-15: #666666
gray-16: #4D4D4D
gray-17: #333333
gray-18: #212121
gray-19: #0D0D0D
gray-20: #0D0D0D

primary-01: #F2F8FF
primary-02: #E6F1FE
primary-03: #CCE3FE
primary-04: #B3D5FD
primary-05: #99C7FD
primary-06: #80B9FC
primary-07: #66ABFC
primary-08: #4096FB
primary-09: #2688FB
primary-10: #1A81FA

success-01: #F3FBF7
success-02: #E7F6F0
success-03: #CFEDE1
success-04: #B8E5D2
success-05: #A0DCC3
success-06: #88D3B3
success-07: #70CAA4
success-08: #41B986
success-09: #29B077
success-10: #11A768

warning-01: #FEF9F2
warning-02: #FDF3E6
warning-03: #FBE8CC
warning-04: #F9DCB3
warning-05: #F7D199
warning-06: #F5C580
warning-07: #F3BA66
warning-08: #EFA333
warning-09: #ED971A
warning-10: #EB8C00

danger-01: #FFF5F5
danger-02: #FFECEB
danger-03: #FFD8D6
danger-04: #FFC5C2
danger-05: #FFB1AD
danger-06: #FF9E99
danger-07: #FF8B85
danger-08: #FF645C
danger-09: #FF5047
danger-10: #FF3D33

info-01: #F2F9FC
info-02: #E6F3FA
info-03: #CCE8F5
info-04: #B3DCF0
info-05: #99D1EB
info-06: #80C5E5
info-07: #66B9E0
info-08: #33A2D6
info-09: #1A97D1
info-10: #008BCC

violet-01: #F6F4FA
violet-02: #ECE9F5
violet-03: #DAD4EB
violet-04: #C7BEE0
violet-05: #B5A9D6
violet-06: #A293CC
violet-07: #8F7DC2
violet-08: #6A52AD
violet-09: #583DA3
violet-10: #452799

purple-01: #F9F4FA
purple-02: #F3E9F5
purple-03: #E7D3EB
purple-04: #DCBEE0
purple-05: #D0A8D6
purple-06: #C492CC
purple-07: #B87CC2
purple-08: #A151AD
purple-09: #953BA3
purple-10: #892599

yellow-01: #FFFDF2
yellow-02: #FFFCE6
yellow-03: #FFF8CC
yellow-04: #FFF5B3
yellow-05: #FFF199
yellow-06: #FFEE80
yellow-07: #FFEB66
yellow-08: #FFE433
yellow-09: #FFE01A
yellow-10: #FFDD00

cyan-01: #F2F9FA
cyan-02: #E6F4F5
cyan-03: #CCE9EB
cyan-04: #B3DEE1
cyan-05: #99D3D7
cyan-06: #80C8CD
cyan-07: #66BDC3
cyan-08: #33A7AF
cyan-09: #1A9CA5
cyan-10: #00919B

g-01: linear-gradient(135deg, #ff3459 0%, #b9493c 100%)

g-02: linear-gradient(135deg, #5b3cdc 0%, #0ca9b3 100%)

g-03: linear-gradient(135deg, #0ce6e2 0%, #5b1220 100%)

g-04: linear-gradient(135deg, #3e1451 0%, #a788f5 100%)

g-05: linear-gradient(135deg, #98d9e4 0%, #ee32b9 100%)

g-06: linear-gradient(135deg, #0aad75 0%, #617d85 100%)

g-07: linear-gradient(135deg, #415e8d 0%, #d160d8 100%)

g-08: linear-gradient(135deg, #5371d4 0%, #55e7d2 100%)

g-09: linear-gradient(135deg, #5e56f0 0%, #1d2fa0 100%)

g-10: linear-gradient(135deg, #e23817 0%, #fc7411 100%)

g-11: linear-gradient(270deg, #485563 50%, #29323c 50%)

g-12: linear-gradient(270deg, #457fca 50%, #5691c8 50%)

g-13: linear-gradient(270deg, #fe8c00 50%, #f83600 50%)

g-14: linear-gradient(135deg, #af5941 0%, #7253a7 100%)

g-15: linear-gradient(135deg, #3875e4 0%, #e124aa 100%)

g-16: linear-gradient(135deg, #558dec 0%, #2db0d6 100%)

g-17: linear-gradient(135deg, #0718b6 0%, #1e674a 100%)

g-18: linear-gradient(270deg, #1d976c 50%, #93f9b9 50%)

g-19: linear-gradient(270deg, #f09819 50%, #edde5d 50%)

g-20: linear-gradient(270deg, #314755 50%, #26a0da 50%)
"""

let colorsDark =
    """
gray-01: #1A1A1A
gray-02: #2D2D2D
gray-03: #3B3B3B
gray-04: #FAFAFA
gray-05: #2E2E2E
gray-06: #363636
gray-07: #404040
gray-08: #3D3D3D
gray-09: #4D4D4D
gray-10: #999999
gray-11: #4D4D4D
gray-12: #A6A6A6
gray-13: #B2B2B2
gray-14: #BFBFBF
gray-15: #CCCCCC
gray-16: #D9D9D9
gray-17: #E5E5E5
gray-18: #F2F2F2
gray-19: #1A1A1A
gray-20: #FAFAFA

primary-01: #19242F
primary-02: #192F45
primary-03: #193A5A
primary-04: #194570
primary-05: #194F86
primary-06: #195A9C
primary-07: #1965B2
primary-08: #1970C7
primary-09: #197BDD
primary-10: #1986F3

success-01: #1B2823
success-02: #1D372C
success-03: #1F4636
success-04: #21553F
success-05: #236449
success-06: #257353
success-07: #27825C
success-08: #299166
success-09: #2BA06F
success-10: #2DAF79

warning-01: #2C2517
warning-02: #403114
warning-03: #533C12
warning-04: #67480F
warning-05: #7A540D
warning-06: #8D600B
warning-07: #A16C08
warning-08: #B47706
warning-09: #C78303
warning-10: #DB8F01

danger-01: #2A1D1C
danger-02: #3B211F
danger-03: #4C2522
danger-04: #5D2925
danger-05: #6D2D27
danger-06: #7E322A
danger-07: #8F362D
danger-08: #A03A30
danger-09: #B13E33
danger-10: #C24236

info-01: #18252B
info-02: #17303D
info-03: #173C4F
info-04: #164761
info-05: #155372
info-06: #145F84
info-07: #136A96
info-08: #1376A8
info-09: #1281BA
info-10: #118DCC

violet-01: #23172C
violet-02: #2D1440
violet-03: #371253
violet-04: #411067
violet-05: #4A0E7A
violet-06: #540B8D
violet-07: #5E09A1
violet-08: #6807B4
violet-09: #7204C7
violet-10: #7C02DB

purple-01: #261B28
purple-02: #341C38
purple-03: #411E47
purple-04: #4F2056
purple-05: #5C2165
purple-06: #692375
purple-07: #772584
purple-08: #842793
purple-09: #9128A3
purple-10: #9F2AB2

yellow-01: #2F2B17
yellow-02: #463E15
yellow-03: #5C5013
yellow-04: #736311
yellow-05: #89750F
yellow-06: #A0880C
yellow-07: #B69A0A
yellow-08: #CDAD08
yellow-09: #E3BF06
yellow-10: #FAD204

cyan-01: #1A2927
cyan-02: #1B3936
cyan-03: #1C4944
cyan-04: #1D5953
cyan-05: #1E6861
cyan-06: #20786F
cyan-07: #21887E
cyan-08: #22988C
cyan-09: #23A89B
cyan-10: #24B8A9

g-01: linear-gradient(135deg, #99001c 0%, #1f0c0a 100%)

g-02: linear-gradient(135deg, #331b97 0%, #097a81 100%)

g-03: linear-gradient(135deg, #078381 0%, #5b1220 100%)

g-04: linear-gradient(135deg, #1f0a29 0%, #622bed 100%)

g-05: linear-gradient(135deg, #257e8d 0%, #aa0e7e 100%)

g-06: linear-gradient(135deg, #044d34 0%, #0b0e0f 100%)

g-07: linear-gradient(135deg, #101723 0%, #791f7f 100%)

g-08: linear-gradient(135deg, #121f49 0%, #138676 100%)

g-09: linear-gradient(135deg, #06042f 0%, #1d2fa0 100%)

g-10: linear-gradient(135deg, #8b220e 0%, #d95d03 100%)

g-11: linear-gradient(270deg, #15191e 50%, #343f4c 50%)

g-12: linear-gradient(270deg, #254e83 50%, #3a77b1 50%)

g-13: linear-gradient(135deg, #c99101 0%, #8f1f00 100%)

g-14: linear-gradient(135deg, #8a4633 0%, #5b4285 100%)

g-15: linear-gradient(135deg, #1647a2 0%, #8b1368 100%)

g-16: linear-gradient(135deg, #1657c5 0%, #11495a 100%)

g-17: linear-gradient(135deg, #051185 0%, #1e674a 100%)

g-18: linear-gradient(270deg, #082b1f 50%, #088c39 50%)

g-19: linear-gradient(270deg, #995f0a 50%, #e5d01a 50%)

g-20: linear-gradient(270deg, #314755 50%, #26a0da 50%)
"""



//func hexStringToUIColor (hex:String) -> (Double, Double, Double, Double) {
//    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//    if (cString.hasPrefix("#")) {
//        cString.remove(at: cString.startIndex)
//    }
//
////    if ((cString.count) != 6) {
////        return
////    }
//
//    var rgbValue:UInt64 = 0
//    Scanner(string: cString).scanHexInt64(&rgbValue)
//
//    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
//    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
//    let blue = Double(rgbValue & 0x0000FF) / 255.0
//
//    return (red, green, blue, 1)
//}


*/

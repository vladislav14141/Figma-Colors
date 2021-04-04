//
//  DirectoryHelper.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 28.03.2021.
//

import Foundation

struct DirectoryHelper {
    
    let fileManager = FileManager.default
    var folderName: String = "Figma Colors"
    
    func exportColors(colors: [ColorItem], directoryPath: String) {
        
        guard let assets = createAssets(directoryPath: directoryPath) else { return }//createColorset(name: "bla bla", directoryPath: directoryPath) else { return }
        guard let folder = createFolder(name: "colors", atPath: assets) else { return }
        saveColors(colors: colors, at: folder)
    }
    
    func saveColors(colors: [ColorItem], at path: String) {
        colors.forEach { color in
            let components = color.figmaNameComponents
            var path = path
            for i in 0..<components.count {
                let name = components[i]
                let isLast = (i + 1) == components.count
                if isLast {
                    saveColor(color: color, at: path)
                } else {
                    if let newPath = createFolder(name: name, atPath: path) {
                        path = newPath
                    } else {
                        printInConsole("Error - can't create folder")
                    }
                }
            }
        }
    }
    
    func createFolder(name: String? = nil, atPath: String) -> String? {
        let name = name ?? folderName
        let downloadsDirectoryWithFolder = atPath + "/" + name

        do {
            if fileManager.fileExists(atPath: downloadsDirectoryWithFolder) {
                return downloadsDirectoryWithFolder
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
        
        do {
            let fullPath = "\(directoryPath)/\(name).colorset"

            try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            
            return fullPath
            
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            return nil
        }
    }
    
    func createAssets(name: String = "Assets", directoryPath: String) -> String? {
        
        do {
            let path = "\(directoryPath)"
            
            let fullPath = "\(path)/\(name).xcassets"
            var increment = 1
            var incrementPath: String {
                return "\(path)/\(name)\(increment).xcassets"
            }
            if fileManager.fileExists(atPath: fullPath) {
                while fileManager.fileExists(atPath: incrementPath) {
                    
                    increment += 1
                }
                try fileManager.createDirectory(atPath: incrementPath, withIntermediateDirectories: false, attributes: nil)
                return incrementPath
            }
            
            print("creating assets", fullPath)
            try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: false, attributes: nil)
            
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
    

    
    fileprivate func saveGradient(colors: [ColorItem], at path: String) {
        colors.forEach{
            saveColor(color: $0, at: path)
        }
    }
    
    
    fileprivate func saveColor(color: ColorItem, at path: String) {
        guard let colorSet = createColorset(name: color.fullName, directoryPath: path) else { return }
        createContentsJSON(folderPath: colorSet, data: getJson(color: color))
    }
    
    func getJson(color: ColorItem) -> Data? {
        
        var dictionary: [String: Any] = ["info": ["author": "xcode", "version": 1]]
        var colors: [[String: Any]] = []
        if let color = color.light {
            let color: [String: Any] = [
                "color":[
                "color-space": "srgb",
                    "components": [
                        "alpha": color.alpha,
                        "blue": color.blue,
                        "green": color.green,
                        "red": color.red
                    ]
            
            ], "idiom": "universal"]
            colors.append(color)
        }

        if let color = color.dark {
            let color: [String: Any] = [
                "color":[
                "color-space": "srgb",
                    "components": [
                        "alpha": color.alpha,
                        "blue": color.blue,
                        "green": color.green,
                        "red": color.red
                    ]
            
            ],
                "idiom": "universal",
                "appearances" : [
                    [
                        "appearance" : "luminosity",
                        "value" : "dark"
                    ]
                    
                ]
            ]
            colors.append(color)
        }
        dictionary["colors"] = colors
        
        return dictionary.toJSON()
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

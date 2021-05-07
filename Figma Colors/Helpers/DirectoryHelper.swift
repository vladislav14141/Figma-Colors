//
//  DirectoryHelper.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 28.03.2021.
//

import Foundation
import Cocoa
struct DirectoryHelper {
    
    let fileManager = FileManager.default
    var folderName: String = "Figma Colors"
////    let storage = ExportStorage.shared
//    init(facto) {
//        <#statements#>
//    }
    
    func pathSelector(completion: (String)->()) {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose a file| Our Code World"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.prompt = "Save"

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                
                let path: String = result!.path
                completion(path)
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func downloadAssets(factory: FigmaFactory) {
        let storage = factory.storage
        pathSelector { (directoryPath) in
            guard let assets = createAssets(directoryPath: directoryPath) else { return }
            
            let colors = storage.colors.flatMap({$0.selectedRows})
            let gradients = storage.gradients.flatMap({$0.selectedRows.flatMap({$0.colors.map({$0})})})
            let components: [ComponentItem] = storage.components.flatMap({$0.selectedRows})
            if colors.isEmpty == false, let folder = createFolder(name: "colors", atPath: assets) {
                saveColors(colors: colors, at: folder)
            }
//
            if gradients.isEmpty == false, let folder = createFolder(name: "gradients", atPath: assets) {
                saveColors(colors: gradients, at: folder)
            }
            
            if components.isEmpty == false, let folder = createFolder(name: "components", atPath: assets) {
//                saveColors(colors: gradients, at: folder)
                saveComponents(components: components, at: folder)
            }
//
//            if storage.
        }
    }
    
    func exportColors(colors: [ColorItem], directoryPath: String) {
        
        guard let assets = createAssets(directoryPath: directoryPath) else { return }//createColorset(name: "bla bla", directoryPath: directoryPath) else { return }
        guard let folder = createFolder(name: "colors", atPath: assets) else { return }
        saveColors(colors: colors, at: folder)
    }
    
    fileprivate func saveComponents(components: [ComponentItem], at path: String) {
        components.forEach { (component) in
            let components = component.figmaNameComponents
            var path = path
            for i in 0..<components.count {
                let name = components[i]
                let isLast = (i + 1) == components.count
                if isLast {
                    saveComponent(component: component, at: path)
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
    
    fileprivate func saveColors(colors: [ColorItem], at path: String) {
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
    
    fileprivate func saveColor(color: ColorItem, at path: String) {
        guard let colorSet = createColorset(name: color.fullName, directoryPath: path) else { return }
        createContentsJSON(folderPath: colorSet, data: getJson(color: color))
    }
    
    fileprivate func saveComponent(component: ComponentItem, at path: String) {
        guard let componentSet = createImageset(name: component.fullName, directoryPath: path) else { return }
        fileManager.createFile(atPath: "\(componentSet)/\(component.fullName)@3x.png", contents: component.imageX3?.sd_imageData(), attributes: nil)
        fileManager.createFile(atPath: "\(componentSet)/\(component.fullName)@2x.png", contents: component.imageX2?.sd_imageData(as: .PNG), attributes: nil)
        fileManager.createFile(atPath: "\(componentSet)/\(component.fullName).png", contents: component.imageX1?.sd_imageData(as: .PNG), attributes: nil)
        createContentsJSON(folderPath: componentSet, data: component.json())
    }

    
    fileprivate func createFolder(name: String? = nil, atPath: String) -> String? {
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
    
    fileprivate func createColorset(name: String, directoryPath: String) -> String? {
        
        do {
            let fullPath = "\(directoryPath)/\(name).colorset"

            try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            
            return fullPath
            
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            return nil
        }
    }
    
    fileprivate func createImageset(name: String, directoryPath: String) -> String? {
        
        do {
            let fullPath = "\(directoryPath)/\(name).imageset"

            try fileManager.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            
            return fullPath
            
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            return nil
        }
    }
    
    fileprivate func createAssets(name: String = "Assets", directoryPath: String) -> String? {
        
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
    
    fileprivate func printInConsole(_ message:Any){
        print("====================================")
        print("\(message)")
        print("====================================")
    }
    

    
    fileprivate func saveGradient(colors: [ColorItem], at path: String) {
        colors.forEach{
            saveColor(color: $0, at: path)
        }
    }
    
    fileprivate func getJson(color: ColorItem) -> Data? {
        
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
    
    fileprivate func createContentsJSON(folderPath: String, data: Data?) {
        fileManager.createFile(atPath: "\(folderPath)/Contents.json", contents: data, attributes: nil)
        print("Writing \(folderPath)")
    }
    
    fileprivate func hexStringToUIColor(hex: String) -> (CGFloat, CGFloat, CGFloat, CGFloat){
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

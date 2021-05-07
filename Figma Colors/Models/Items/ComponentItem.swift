//
//  ImageItem.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 08.04.2021.
//

import Foundation
import Cocoa

class ComponentItem: FigmaItem {
    var x3: String? {
        didSet {
            downloadImage(from: x3) { [weak self] (image) in
                guard let img = image else { return }
                self?.imageX3 = img
                self?.imageX2 = self?.resize(image: img, scale: 2)
                self?.imageX1 = self?.resize(image: img, scale: 1)
            }
        }
    }
    
    @Published var imageX3: NSImage?
    @Published var imageX2: NSImage?
    @Published var imageX1: NSImage?
    
    @Published var size: CGSize?
    
    override var swftUICode: String {
        uiKitCode
    }
    
    override var uiKitCode: String {
        "    static let \(fullName) = UIImage(named: \"\(fullName)\")!"
    }
    
    func json() -> Data {
        var dict: [String: Any] = ["images": []]
        let info: [String: Any] = ["author" : "xcode", "version" : 1]
        var images: [[String: String]] = []
        
        (1...3).forEach { (scale) in
            images.append(imageDict(scale: scale))
        }
        dict["info"] = info
        dict["images"] = images
        return dict.toJSON()
    }
    
    func imageDict(scale: Int) -> [String: String] {
        if scale == 1 {
            return ["filename": fullName + ".png", "idiom": "universal", "scale": "1x"]

        } else {
            
            return ["filename": "\(fullName)@\(scale)x.png", "idiom": "universal", "scale": "\(scale)x"]
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: String?, completion: @escaping (NSImage?) -> ()) {
        guard let urlS = url, let url = URL(string: urlS) else { return }
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                completion(NSImage(data: data, scale: 1))
            }
        }
    }
    
    func resize(image: NSImage, w: CGFloat, h: CGFloat) -> NSImage {
        var destSize = NSMakeSize(w, h)
        var newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    func resize(image:NSImage, scale: CGFloat) -> NSImage {
        resize(image: image, w: image.size.width / 3 * scale / 2, h: image.size.height / 3 * scale / 2)
    }
//    {
//      "images" : [
//        {
//          "filename" : "ic.png",
//          "idiom" : "universal",
//          "scale" : "1x"
//        },
//        {
//          "filename" : "ic@2x.png",
//          "idiom" : "universal",
//          "scale" : "2x"
//        },
//        {
//          "filename" : "ic@3x.png",
//          "idiom" : "universal",
//          "scale" : "3x"
//        }
//      ],
//      "info" : {
//        "author" : "xcode",
//        "version" : 1
//      }
//    }
}

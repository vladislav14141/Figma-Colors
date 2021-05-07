//
//  CacheHelper.swift
//  AppConstructor
//
//  Created by Владислав Миронов on 04.05.2021.
//
import Foundation
import Cache
import Cocoa
class CacheHelper {
    static var shared = CacheHelper()
    let diskConfig = DiskConfig(
      name: "Floppy",
      expiry: .date(Date().addingTimeInterval(96000 * 7)),
      maxSize: 1000,
      directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
        appropriateFor: nil, create: true).appendingPathComponent("MyPreferences")
    )
    
    let memoryConfig = MemoryConfig(
        expiry: .date(Date().addingTimeInterval(96000 * 7)),
        countLimit: 1000,
        totalCostLimit: 0
    )
    let imageStorage: Storage<String, NSImage>
    
    init() {
        let imgStor = try! Storage<String, Data>(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forData())
        imageStorage = imgStor.transformImage()
    }
    
    func storage<Y:Codable>(decodeBy: Y.Type) -> Storage<String, Y> {
        return try! Storage<String, Y>(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Y.self)
          )
    }
    
//    func objectForKey
}

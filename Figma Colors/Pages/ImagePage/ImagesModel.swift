//
//  ImagesModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import Foundation

struct ImagesModel: Codable {
    let error: Bool
    let status: Int
    let meta: ImageModel
    struct ImageModel: Codable {
        let images: [String: String]
    }
}


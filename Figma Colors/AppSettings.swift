//
//  AppSettings.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
import SwiftUI


var settings = AppSettings()

enum NameCase: String, Equatable, CaseIterable {
    case camelcase
    case snakecase
}

class AppSettings {
    @AppStorage("NameCase") var nameCase: NameCase = NameCase.camelcase
    @AppStorage("FolderSeparator") var folderSeparator: String = "-"
    @AppStorage("Uppercased") var uppercased: Bool = false
    @AppStorage("GradientSeparator") var gradientSeparator: String = ""
    @AppStorage("fileKeyLight") var fileKeyLight: String = ""
    @AppStorage("fileKeyDark") var fileKeyDark: String = ""
    @AppStorage("X-Figma-Token") var figmaToken: String = ""
}


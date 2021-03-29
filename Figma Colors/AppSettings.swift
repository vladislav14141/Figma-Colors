//
//  AppSettings.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("fileKeyLight") var fileKeyLight: String = ""
    @AppStorage("fileKeyDark") var fileKeyDark: String = ""
    @AppStorage("X-Figma-Token") var figmaToken: String = ""
    
    @Published var figmaColors = [FigmaSection]()
}

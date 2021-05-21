//
//  AppSettings.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 29.03.2021.
//

import Foundation
import SwiftUI


var settings = AppSettings()
var figmaStorageDefault = FigmaStorage()

enum NameCase: String, Equatable, CaseIterable {
    case camelcase
    case snakecase
    case kebabcase
}

class AppSettings {
    @AppStorage("fileKeyLight") var fileKeyLight: String = ""
    @AppStorage("fileKeyDark") var fileKeyDark: String = ""
    @AppStorage("X-Figma-Token") var figmaToken: String = ""
}

import Combine
class FigmaStorage: ObservableObject {
    @Published var nameCase: NameCase = NameCase.camelcase
    @Published var colors = [FigmaSection<ColorItem>]()
    @Published var gradients = [FigmaSection<GradientItem>]()
    @Published var components = [FigmaSection<ComponentItem>]()
    
//    @Published var selectedComponentsCount = 0
//    @Published var selectedColorsCount = 0
//    @Published var selectedGradientsCount = 0
//
//    @Published var componentsCount = 0
//    @Published var colorsCount = 0
//    @Published var gradientsCount = 0
    
    @Published var images: [MRWebImage] = []
    @Published var isLoading = false
    @Published var navigationLink: NavigationTabItem? = .colors
    @Published var gradientSeparator: String = "-"
    
    var bag = [AnyCancellable]()
    
    init() {


    }
    
    var storageIsEmpty: Bool {
        colors.isEmpty && gradients.isEmpty && components.isEmpty
    }
    func removeAll() {
        bag.removeAll()
        colors.removeAll()
        gradients.removeAll()
        components.removeAll()
        images.removeAll()
    }
}

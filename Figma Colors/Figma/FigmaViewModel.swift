//
//  FigmaViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import Combine
import SwiftUI






enum FigmaSheme {
    case light
    case dark
}

class FigmaBlocks {
    var colors = [FigmaSection<ColorItem>]()
    var gradient = [FigmaSection<ColorItem>]()

    init(colors:[FigmaSection<ColorItem>] = [], gradient: [FigmaSection<ColorItem>] = []) {
        self.colors = colors
        self.gradient = gradient
    }
}



class FigmaViewModel: ObservableObject {
    // MARK: - Public Properties
    @Published var fileKeyLight: String
    @Published var fileKeyDark: String
    @Published var figmaToken: String
    
    @Published var figmaColors = [FigmaSection<ColorItem>]()
    @Published var figmaGradient = [FigmaSection<GradientItem>]()

    @Published var figmaData = FigmaBlocks()
    @Published var isLoading = false
    @Published var showCode: Bool = false
    @Published var showSettings = false
    
    @Published var fileDark: FigmaModel?
    @Published var fileLight: FigmaModel?

    var bag = [AnyCancellable]()
    // MARK: - Private Properties
    private let directoryHelper = DirectoryHelper()
    private let dataFetcher = NetworkDataFetcher()

    private var gradientSection: [String: FigmaSection<ColorItem>] = [:]
    private var sections: [String: FigmaSection<ColorItem>] = [:]
    private var colors: [String: ColorItem] = [:]
    private var gradientItem: [String: GradientItem] = [:]
    private var gradientItems = [GradientItem]()
    private var colorItems = [ColorItem]()

    
    // MARK: - Lifecycle
    init() {
        fileKeyLight = settings.fileKeyLight
        fileKeyDark = settings.fileKeyDark
        figmaToken = settings.figmaToken
        
        Notifications.showCode.publisher().sink {[weak self] g in
            self?.showCode = true
        }.store(in: &bag)
        
        $fileKeyLight.dropFirst().sink { key in
            settings.fileKeyLight = key
        }.store(in: &bag)
        
        $fileKeyDark.dropFirst().sink { key in
            settings.fileKeyDark = key
        }.store(in: &bag)
        
        $figmaToken.dropFirst().sink { key in
            settings.figmaToken = key
        }.store(in: &bag)
        

    }
    
    

    // MARK: - Public methods
    func clearData() {
        figmaColors.removeAll()
        colors.removeAll()
        sections.removeAll()
    }
    
    func onExportAll() {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;
        dialog.prompt = "Save"
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                
                let path: String = result!.path
                var colors: [ColorItem] = []
//                figmaColors.forEach {
//                    $0.colors.forEach {
//                        colors.append($0)
//                    }
//                }
//                directoryHelper.exportColors(colors: colors, directoryPath: path)
//                print("path", path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    
    
    
    func getData() {
        clearData()
        if fileKeyLight.isEmpty == false {
            fetchFigmaStyles(sheme: .light)
        }
        
        if fileKeyDark.isEmpty == false {
            fetchFigmaStyles(sheme: .dark)
        }
    }

    
    // MARK: - Private Methods
    fileprivate func fetchFigmaStyles(sheme: FigmaSheme) {
        isLoading = true
        let url = "https://api.figma.com/v1/files/\(keyFor(sheme: sheme))/styles"
        print(url)
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: FigmaModel.self, completion: { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    switch sheme {
                    case .dark: self.fileDark = success
                    case .light: self.fileLight = success
                    }
                }
                
                let styles: [String] = success.meta.styles.compactMap({
                    if $0.styleType == "FILL" {
                        return $0.nodeId
                    } else {
                        return nil
                    }
                })
                self.getNode(nodeIds: styles.joined(separator: ","), sheme: sheme)
                print(success)
                
            case .failure(let err):
                print(err)
            }
        })
    }
    
    fileprivate func onFetchedColor(fill: NodeModel.Fill, value: NodeModel.Node, sheme: FigmaSheme) {
        if let color = fill.color {
            if let opacity = fill.opacity {
                let color = NodeModel.Color(r: color.r, g: color.g, b: color.b, a: color.a * opacity)
                let row = self.getFigmaColorRow(name: value.document.name, rgb: color, sheme: sheme)
                colorRows.append(row)
                
            } else {
                
                let row = self.getFigmaColorRow(name: value.document.name, rgb: color, sheme: sheme)
                colorRows.append(row)
                
            }
        }
    }
    
    fileprivate func onFetchedGradient(value: NodeModel.Node, fill: NodeModel.Fill, sheme: FigmaSheme, subname: String) {
        //                            var gradients = [GradientItem]()
        var gradientsColors = [ColorItem]()
        var positions = [Float]()
        let start: UnitPoint = fill.gradientHandlePositions?.first.map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 0, y: 0)
        let end = fill.gradientHandlePositions?[safe:1].map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 1, y: 1)
        
        if let stops = fill.gradientStops {
            for (i, stop) in stops.enumerated() {
                positions.append(stop.position)
                
                let subname2 = stops.count == 1 ? "" : "\(i + 1)"
                if let opacity = fill.opacity {
                    let color = NodeModel.Color(r: stop.color.r, g: stop.color.g, b: stop.color.b, a: stop.color.a * opacity)
                    let row = self.getFigmaColorRow(name: value.document.name, gradientNameComponents: [subname, subname2].filter({!$0.isEmpty}),rgb: color, sheme: sheme)
                    gradientsColors.append(row)
                } else {
                    let row = self.getFigmaColorRow(name: value.document.name, gradientNameComponents: [subname, subname2].filter({!$0.isEmpty}),rgb: stop.color, sheme: sheme)
                    gradientsColors.append(row)
                    
                }
            }
        }
        
        if let item = self.gradientItem[value.document.name] {
            gradients.append(item)
        } else {
            
            let gradientItem = GradientItem(figmaName: value.document.name, colors: gradientsColors, colorLocation: positions, start: start, end: end)
            self.gradientItem[value.document.name] = gradientItem
            gradients.append(gradientItem)
        }
    }
    
    fileprivate func onFetchedNode(_ nodes: [String: NodeModel.Node], sheme: FigmaSheme) {
        nodes.forEach { key, value in
            
            let fills = value.document.fills
            for (i, fill) in fills.enumerated() {
                
                let subname = fills.count == 1 ? "" : "\(i + 1)"
                
                switch fill.type {
                
                case .linearG:
                    self.onFetchedGradient(value: value, fill: fill, sheme: sheme, subname: subname)
                case .solid:
                    self.onFetchedColor(fill: fill, value: value, sheme: sheme)
                }
            }
        }
    }
    
    fileprivate func getNode(nodeIds: String, sheme: FigmaSheme) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let url = "https://api.figma.com/v1/files/\(keyFor(sheme: sheme))/nodes?ids=\(nodeIds)"
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: NodeModel.self) {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            switch $0 {
            
            case .success(let responce):
                var colorRows = [ColorItem]()
//                var gradientSections = [FigmaSection<GradientItem>]()
                var gradients = [GradientItem]()
                
                self.onFetchedNode(responce.nodes, sheme: sheme)

                var sections: [String : FigmaSection<ColorItem>] = [:]
                
                for value in colorRows {
                    if let section = sections[value.groupName ?? "Colors"]  {
                        section.append(value)
                    } else {
                        sections[value.groupName ?? "Colors"] = .init(name: value.groupName ?? "Colors", colors: [value])
                    }
                }
                
                let sectionArray: [FigmaSection<ColorItem>] = sections.map({
                    let section = $0.value
                    section.sortColors()
                    return section
                }).sorted(by: {$0.name < $1.name})
                
                gradients.sort(by: {$0.name < $1.name})
                DispatchQueue.main.async {
                    self.figmaColors = sectionArray
                    var dict = [String: FigmaSection<GradientItem>]()
                    
                    gradients.forEach {
                        let value: FigmaSection<GradientItem> = dict[$0.groupName ?? ""] ?? FigmaSection(name: $0.groupName ?? "", colors: [])
                        value.append($0)
                        dict[$0.groupName ?? ""] = value
                    }
                    
                    self.figmaGradient = dict.values.sorted(by: {$0.name > $1.name})
                }
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    fileprivate func getFigmaColorRow(name: String, gradientNameComponents: [String] = [],rgb: NodeModel.Color, sheme: FigmaSheme) -> ColorItem {
        let figmaRow = ColorItem(figmaName: name)
        figmaRow.gradientComponents = gradientNameComponents
        
        var row: ColorItem = colors[figmaRow.fullName] ?? figmaRow
        let figmaColor = FigmaColor(r: rgb.r, g: rgb.g, b: rgb.b, a: rgb.a)
        switch sheme {
        case .light:
            row.light = figmaColor
        case .dark:
            row.dark = figmaColor
        }
        colors[figmaRow.fullName] = row
        return row
    }
    
    fileprivate func keyFor(sheme: FigmaSheme) -> String {
        
        switch sheme {
       
        case .light:
            if let url = URL(string: fileKeyLight) {
                let components = url.pathComponents
                guard let index = components.firstIndex(of: "file") else { return "a" }
                guard components.count > index + 2 else { return "b"}
                let key = components[index + 1]
                return key
            } else {
                
                return fileKeyLight
            }
        case .dark:
            if let url = URL(string: fileKeyDark) {
                let components = url.pathComponents
                guard let index = components.firstIndex(of: "file") else { return "a" }
                guard components.count > index + 2 else { return "b"}
                let key = components[index + 1]
                return key
            } else {
                return fileKeyDark
            }

        }
    }
}

//extension Array {
//    func groupBy(key: (Element)->Bool) -> [Element] {
//
//    }
//}

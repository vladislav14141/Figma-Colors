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
enum FigmaNodeType {
    case components
    case styles
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
    @Published var figmaImages = [FigmaSection<ImageItem>]()

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
    private let queue = DispatchQueue(label: "fetch.queue")

    private var gradientSection: [String: FigmaSection<ColorItem>] = [:]

    private var colors: [String: ColorItem] = [:]
    private var gradientItem: [String: GradientItem] = [:]
    private var imageItemDict: [String: ImageItem] = [:]
    private var imageItemNameDict: [String: ImageItem] = [:]

    private var gradientItems = [GradientItem]()
    private var colorItems = [ColorItem]()
    private var imageItems = [ImageItem]()
    
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
        
        $figmaColors.sink { sections in
            ExportStorage.shared.colors = sections
        }.store(in: &bag)

        $figmaGradient.sink { sections in
            ExportStorage.shared.gradient = sections
        }.store(in: &bag)
    }
    
    

    // MARK: - Public methods
    func clearData() {
        figmaGradient.removeAll()
        figmaColors.removeAll()
        colors.removeAll()
        gradientItems.removeAll()
        gradientItem.removeAll()
        colorItems.removeAll()
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
        let url = "https://api.figma.com/v1/files/\(keyFor(sheme: sheme))"
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
                
                let styles: String = success.styles.compactMap({
                    if $1.styleType == .fill {
                        return $0
                    } else {
                        return nil
                    }
                }).joined(separator: ",")
                
                let components: String = success.components.compactMap({ key, value in
                    let image = ImageItem(figmaName: value.name)
                    self.imageItemDict[key] = image
                    self.imageItemNameDict[value.name] = image
                    return key
                }).joined(separator: ",")

                self.getImages(nodeIds: components, sheme: sheme)
                self.getNode(nodeIds: components, nodeType: .components, sheme: sheme)
                self.getNode(nodeIds: styles, nodeType: .styles, sheme: sheme)
                print(success)
                
            case .failure(let err):
                print(err)
            }
        })
    }

    fileprivate func getImages(nodeIds: String, sheme: FigmaSheme) {
        
        let url = "https://api.figma.com/v1/images/\(keyFor(sheme: sheme))?scale=3&ids=\(nodeIds)"
        
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: FigmaImagesModel.self) { result in
            switch result {
            
            case .success(let responce):
                responce.images.forEach {
                    self.imageItemDict[$0]?.x3 = $1
                }
                self.imageItems = self.imageItemDict.compactMap({$0.value})
                DispatchQueue.main.async {
                    self.figmaImages = self.getSections(rows: self.imageItems)//self.imageItemNameDict.compactMap({$0.value})
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    fileprivate func onFetchedColor(fill: NodeModel.Fill, value: NodeModel.Node, sheme: FigmaSheme) {
        if let color = fill.color {
            if let opacity = fill.opacity {
                let color = NodeModel.Color(r: color.r, g: color.g, b: color.b, a: color.a * opacity)
                let row = self.getFigmaColorRow(name: value.document.name, rgb: color, sheme: sheme)
                colorItems.append(row)
                
            } else {
                
                let row = self.getFigmaColorRow(name: value.document.name, rgb: color, sheme: sheme)
                colorItems.append(row)
                
            }
        }
    }
    
    fileprivate func onFetchedGradient(value: NodeModel.Node, fill: NodeModel.Fill, sheme: FigmaSheme, subname: String) {
        //                            var gradients = [GradientItem]()
        var gradientsColors = [ColorItem]()
        var gradientsColorses = [FigmaColor]()

        var positions = [Float]()
        let start: UnitPoint = fill.gradientHandlePositions?.first.map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 0, y: 0)
        let end = fill.gradientHandlePositions?[safe:1].map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 1, y: 1)
        
        if let stops = fill.gradientStops {
            for (i, stop) in stops.enumerated() {
                positions.append(stop.position)
                
                let subname2 = stops.count == 1 ? "" : "\(i + 1)"
                let viewOpacity = fill.opacity ?? 1
                let color = NodeModel.Color(r: stop.color.r, g: stop.color.g, b: stop.color.b, a: stop.color.a * viewOpacity)
                let row = self.getFigmaColorRow(name: value.document.name, gradientNameComponents: [subname, subname2].filter({!$0.isEmpty}),rgb: color, sheme: sheme)
                gradientsColors.append(row)
            }
        }
        
        let gradient = FigmaGradient(figmaName: value.document.name, colors: gradientsColorses, location: positions, start: start, end: end)
        
        if let item = self.gradientItem[value.document.name] {
            gradientItems.append(item)
        } else {
            
            let gradientItem = GradientItem(figmaName: value.document.name, colors: gradientsColors)
            gradientItem.setGradient(gradient, for: sheme)
            self.gradientItem[value.document.name] = gradientItem
            gradientItems.append(gradientItem)
        }
    }
    
    fileprivate func onFetchedImageNode(_ nodes: [String: NodeModel.Node], sheme: FigmaSheme) {
        nodes.forEach { key, value in
            if let size = value.document.absoluteBoundingBox {
                self.imageItemDict[key]?.size = .init(width: size.width, height: size.height)
            }
        }
    }
    
    fileprivate func onFetchedNode(_ nodes: [String: NodeModel.Node], sheme: FigmaSheme) {
        nodes.forEach { key, value in
            switch value.document.type {
            case .component:
                print(value)
            case .rectangle:
                let fills = value.document.fills
                for (i, fill) in fills.enumerated() {
                    
                    let subname = fills.count == 1 ? "" : "\(i + 1)"
                    
                    switch fill.type {
                    
                    case .linearG:
                        self.onFetchedGradient(value: value, fill: fill, sheme: sheme, subname: subname)
                    case .solid:
                        self.onFetchedColor(fill: fill, value: value, sheme: sheme)
                    default: ()
                    //                case .radialG:
                    //                    <#code#>
                    //                case .angularG:
                    //                    <#code#>
                    //                case .diamonG:
                    //                    <#code#>
                    //                case .image:
                    //                    <#code#>
                    //                case .emoji:
                    //                    <#code#>
                    }
                }
                
            default: ()
            }
        }
    }
    
    
    
    fileprivate func getNode(nodeIds: String, nodeType: FigmaNodeType, sheme: FigmaSheme) {
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
                
                switch nodeType {
                case .components:
                    self.onFetchedImageNode(responce.nodes, sheme: sheme)
                case .styles:
                    self.queue.async {
                        self.onFetchedNode(responce.nodes, sheme: sheme)
                        let colors = self.getSections(rows: self.colorItems)
                        let gradients = self.getSections(rows: self.gradientItems)
                        
                        DispatchQueue.main.async {
                            self.figmaColors = colors
                            self.figmaGradient = gradients
                        }
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    fileprivate func getSections<Row: FigmaItem>(rows: [Row]) -> [FigmaSection<Row>]{
        var dict = [String: FigmaSection<Row>]()

        rows.forEach {
            let value: FigmaSection<Row> = dict[$0.groupName] ?? FigmaSection(name: $0.groupName, colors: [])
            value.append($0)
            dict[$0.groupName] = value
        }
        return dict.values.compactMap({
            $0.sortColors()
            return $0
        }).sorted(by: {$0.name < $1.name})
    }
    
    fileprivate func getFigmaColorRow(name: String, gradientNameComponents: [String] = [],rgb: NodeModel.Color, sheme: FigmaSheme) -> ColorItem {
        let figmaRow = ColorItem(figmaName: name)
        figmaRow.gradientNameComponents = gradientNameComponents
        
        let row: ColorItem = colors[figmaRow.fullName] ?? figmaRow
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

//
//  GradientViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021.
//

import SwiftUI

import Combine
enum FigmaSheme {
    case light
    case dark
}
enum FigmaNodeType {
    case components
    case styles
}

class FigmaFactory: ObservableObject {
    // MARK: - Public Properties
    @Published var fileKeyLight: String
    @Published var fileKeyDark: String
    @Published var figmaToken: String

    @Published var storage: FigmaStorage

    var isLoading: Bool {
        get {
            storage.isLoading
        }
        set {
            storage.isLoading = newValue
        }
    }
    
    @Published var fileDark: FigmaModel?
    @Published var fileLight: FigmaModel?

    var bag = [AnyCancellable]()
    
    // MARK: - Private Properties
    private let directoryHelper = DirectoryHelper()
    private let dataFetcher = NetworkCachedDataFetcher()
    private let queue = DispatchQueue(label: "fetch.queue")
    
    private let group = DispatchGroup()

    private var gradientSection: [String: FigmaSection<ColorItem>] = [:]

    private var colorsCache: [String: ColorItem] = [:]
    private var gradientsCache: [String: GradientItem] = [:]
    private var gradientsColorsCache: [String: ColorItem] = [:]

    private var imageItemDict: [String: ComponentItem] = [:]
    private var imageItemNameDict: [String: ComponentItem] = [:]



    private var imageItems = [ComponentItem]()
    
    // MARK: - Lifecycle
    init(storage: FigmaStorage) {
        self.storage = storage
        fileKeyLight = settings.fileKeyLight
        fileKeyDark = settings.fileKeyDark
        figmaToken = settings.figmaToken
        
//        Notifications.showCode.publisher().sink {[weak self] g in
//            self?.showCode = true
//        }.store(in: &bag)
        
        $fileKeyLight.dropFirst().sink { key in
            settings.fileKeyLight = key
        }.store(in: &bag)
        
        $fileKeyDark.dropFirst().sink { key in
            settings.fileKeyDark = key
        }.store(in: &bag)
        
        $figmaToken.dropFirst().sink { key in
            settings.figmaToken = key
        }.store(in: &bag)
        fetchFigmaStyles(sheme: .light)
        fetchFigmaStyles(sheme: .dark)
    }
    

    // MARK: - Public methods
    func clearData() {
        storage.removeAll()
        colorsCache.removeAll()
        gradientsCache.removeAll()
        gradientsColorsCache.removeAll()
        imageItemDict.removeAll()
        imageItemNameDict.removeAll()
        imageItems.removeAll()
    }
    
    func getData() {
        clearData()
        if fileKeyLight.isEmpty == false {
            fetchFigmaStyles(sheme: .light)
        }
        
        if fileKeyDark.isEmpty == false {
            fetchFigmaStyles(sheme: .dark)
        }
        self.isLoading = true
//        fetchImages()
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    
    // MARK: - Private Methods
    fileprivate func onFetchedColor(fill: NodeModel.Fill, value: NodeModel.Node, sheme: FigmaSheme, subname: String) {
        if let color = fill.color {
            let opacity = fill.opacity ?? 1
            let color = NodeModel.Color(r: color.r, g: color.g, b: color.b, a: color.a * opacity)
            let _ = self.getFigmaColorRow(cache: &colorsCache, name: value.document.name, fillNameComponents: [subname], rgb: color, sheme: sheme)
        }
    }
    
    fileprivate func onFetchedGradient(value: NodeModel.Node, fill: NodeModel.Fill, sheme: FigmaSheme, subname: String) {
        var gradientsColors = [ColorItem]()
        var figmaColors = [FigmaColor]()

        var positions = [Float]()
        let start: UnitPoint = fill.gradientHandlePositions?.first.map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 0, y: 0)
        let end = fill.gradientHandlePositions?[safe:1].map({UnitPoint(x: CGFloat($0.x), y: CGFloat($0.y))}) ?? UnitPoint.init(x: 1, y: 1)
        
        if let stops = fill.gradientStops {
            for (i, stop) in stops.enumerated() {
                positions.append(stop.position)
                
                let subname2 = stops.count == 1 ? "" : "\(i + 1)"
                let viewOpacity = fill.opacity ?? 1
                let figmaColor = FigmaColor(r: stop.color.r, g: stop.color.g, b: stop.color.b, a: stop.color.a * viewOpacity)
                let row = self.getFigmaColorRow(cache: &gradientsColorsCache,
                                                name: value.document.name,
                                                fillNameComponents: [subname, subname2].filter({!$0.isEmpty}),
                                                rgb: figmaColor, sheme: sheme)
                figmaColors.append(figmaColor)
                gradientsColors.append(row)
            }
        }
        
        let gradient = FigmaGradient(figmaName: value.document.name, colors: figmaColors, location: positions, start: start, end: end)
        gradient.fillSubnames = [subname].filter { $0.isEmpty == false }

        if let item = self.gradientsCache[gradient.fullName] {
            item.setGradient(gradient, for: sheme)
        } else {
            
            let gradientItem = GradientItem(figmaName: value.document.name, colors: gradientsColors)
            gradientItem.setGradient(gradient, for: sheme)
            self.gradientsCache[gradient.fullName] = gradientItem
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
                        self.onFetchedColor(fill: fill, value: value, sheme: sheme, subname: subname)
                    default: ()
                    }
                }
                
            default: ()
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
    
    fileprivate func getSections<Row: FigmaItem>(rows: [String: Row]) -> [FigmaSection<Row>]{
        var dict = [String: FigmaSection<Row>]()

        rows.forEach { key, value in
            let section: FigmaSection<Row> = dict[value.groupName] ?? FigmaSection(name: value.groupName)
            section.append(value)
            dict[value.groupName] = section
        }
        return dict.values.compactMap({
            $0.sortColors()
            return $0
        }).sorted(by: {$0.name < $1.name})
    }
    
    fileprivate func getFigmaColorRow(cache: inout [String: ColorItem], name: String, fillNameComponents: [String], rgb: NodeModel.Color, sheme: FigmaSheme) -> ColorItem {
        let figmaColor = FigmaColor(r: rgb.r, g: rgb.g, b: rgb.b, a: rgb.a)
        return getFigmaColorRow(cache: &cache, name: name, fillNameComponents: fillNameComponents, rgb: figmaColor, sheme: sheme)
    }
    
    fileprivate func getFigmaColorRow(cache: inout [String: ColorItem], name: String, fillNameComponents: [String], rgb: FigmaColor, sheme: FigmaSheme) -> ColorItem {
        let figmaRow = ColorItem(figmaName: name)
        figmaRow.fillSubnames = fillNameComponents.filter { $0.isEmpty == false}
        
        let row: ColorItem = cache[figmaRow.fullName] ?? figmaRow
        row.setColor(rgb, for: sheme)
        cache[figmaRow.fullName] = row
        return row
    }
    
    fileprivate func urlComponents(sheme: FigmaSheme) -> (token: String, nodeId: String?)? {
        
        func keyFor(url: String) -> (token: String, nodeId: String?)? {
            if let url = URL(string: url) {
                let components = url.pathComponents
                guard let index = components.firstIndex(of: "file") else { return nil }
                guard components.count > index + 2 else { return nil }
                let queryParams = url.queryParameters
                let key = components[index + 1]
                return (key, queryParams["node-id"])
            } else {
                return (url, nil)
            }
        }
        
        switch sheme {
        case .light: return keyFor(url: fileKeyLight)
        case .dark: return keyFor(url: fileKeyDark)
        }
    }
}

//MARK: - Requests
extension FigmaFactory {
    fileprivate func getNode(nodeIds: String, nodeType: FigmaNodeType, sheme: FigmaSheme) {
        guard let components = urlComponents(sheme: sheme) else { return }

        let url = "https://api.figma.com/v1/files/\(components.token)/nodes?ids=\(nodeIds)"
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: NodeModel.self) {

            switch $0 {
            
            case .success(let responce):
                
                switch nodeType {
                case .components:
                    self.onFetchedImageNode(responce.nodes, sheme: sheme)
                case .styles:
                    self.queue.async(group: self.group) {
                        self.onFetchedNode(responce.nodes, sheme: sheme)
                        let colors = self.getSections(rows: self.colorsCache)
                        let gradients = self.getSections(rows: self.gradientsCache)
                        
                        DispatchQueue.main.async {
                            self.storage.colors = colors
                            self.storage.gradients = gradients
                        }
                    }
                }
            case .failure(let err):
                print(err)

            }
        }
    }
    
    fileprivate func fetchFigmaStyles(sheme: FigmaSheme) {
        guard let components = urlComponents(sheme: sheme) else { return }

        var url = "https://api.figma.com/v1/files/\(components.token)"
        if let nodeId = components.nodeId {
            url += "?ids=\(nodeId)"
        }
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: FigmaModel.self, completion: { result in
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
                    let image = ComponentItem(figmaName: value.name)
                    self.imageItemDict[key] = image
                    self.imageItemNameDict[value.name] = image
                    return key
                }).joined(separator: ",")

                self.getComponents(nodeIds: components, sheme: sheme)
                self.getNode(nodeIds: components, nodeType: .components, sheme: sheme)
                self.getNode(nodeIds: styles, nodeType: .styles, sheme: sheme)
                print(success)
                
            case .failure(let err):
                print(err)
            }        
        })
    }
    
    fileprivate func getComponents(nodeIds: String, sheme: FigmaSheme) {
        guard let components = urlComponents(sheme: sheme) else { return }

        let url = "https://api.figma.com/v1/images/\(components.token)?scale=3&ids=\(nodeIds)"
        
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: FigmaImagesModel.self) { result in
            switch result {
            
            case .success(let responce):
                responce.images.forEach {
                    self.imageItemDict[$0]?.x3 = $1
                }
                self.imageItems = self.imageItemDict.compactMap({$0.value})
                DispatchQueue.main.async {
                    self.storage.components = self.getSections(rows: self.imageItems)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
//    func fetchImages() {
//        guard let components = urlComponents(sheme: .light) else { return }
//        isLoading = true
//        dataFetcher.fetchGenericJsonData(urlString: "https://api.figma.com/v1/files/\(components.token)/images", decodeBy: ImagesModel.self) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//
//            case .success(let responce):
//                let images = responce.meta.images.reduce(into: []) { (result, dict) in
//                    result.append(Image1Item(key: dict.key, url: dict.value))
//                }
//                DispatchQueue.main.async {
//                    self.storage.images = images.map({MRWebImage(url: $0.url)})
//                }
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
}

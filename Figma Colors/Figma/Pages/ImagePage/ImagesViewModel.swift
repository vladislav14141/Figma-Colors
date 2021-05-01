//
//  ImagesViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import Combine
import Foundation

class Image1Item: Identifiable {
    
    var id: String {
        key
    }
    let key: String
    let url: String
    init(key: String, url: String) {
        self.key = key
        self.url = url
    }
}
class ImagesViewModel: ObservableObject {
    // MARK: - Public Properties
    @Published var isLoading = false
    @Published var webImages: [MRWebImage] = []
    var images: [Image1Item] = [] {
        didSet {
            webImages = images.compactMap({MRWebImage(url: $0.url)})
        }
    }

    // MARK: - Private Methods
    fileprivate let dataFetcher = NetworkDataFetcher()

    // MARK: - Lifecycle
    init() {
        
    }
    
    // MARK: - Public methods
    func fetchData() {
        isLoading = true
        dataFetcher.fetchGenericJsonData(urlString: "https://api.figma.com/v1/files/BEjfU0kCVnPqXdRLfoLvkf/images", decodeBy: ImagesModel.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let responce):
                let images = responce.meta.images.reduce(into: []) { (result, dict) in
                    result.append(Image1Item(key: dict.key, url: dict.value))
                }
                DispatchQueue.main.async {
                    self.images = images
                }
            case .failure(let err):
                print(err)
            }
            DispatchQueue.main.async { self.isLoading = false }
        }
    }
    
    // MARK: - Private Methods
    
}


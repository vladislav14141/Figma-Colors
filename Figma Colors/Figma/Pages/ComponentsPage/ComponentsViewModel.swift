//
//  ComponentsViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.04.2021.
//

import Foundation
class ComponentViewModel: ObservableObject {
    
    let dataFetcher = NetworkDataFetcher()
    @Published var items = [Component]()
    func fetchComponents() {
        let url = "https://api.figma.com/v1/files/BEjfU0kCVnPqXdRLfoLvkf/components"
        dataFetcher.fetchGenericJsonData(urlString: url, decodeBy: Model.self) { result in
            switch result {
            
            case .success(let responce):
                DispatchQueue.main.async {
                    self.items = responce.meta.components
                }
            case .failure(let err):
                ()
            }
        }
    }
    
    struct Model: Codable {
        let meta: Components
    }
    
    struct Components: Codable {
        let components: [Component]
    }
    
    struct Component: Codable, Identifiable {
        let id: UUID = UUID()
        let thumbnailUrl: String
        let name: String
    }
}

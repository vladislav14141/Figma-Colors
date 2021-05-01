//
//  SideBarViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import Combine
import Foundation

class SideBarViewModel: ObservableObject {
    // MARK: - Public Properties
    @Published var isLoading = false
    
    // MARK: - Private Methods
    fileprivate let dataFetcher = NetworkDataFetcher()

    // MARK: - Lifecycle
    init() {
        
    }
    
    // MARK: - Public methods
//    func fetchData() {
//        isLoading = true
//        dataFetcher.fetchGenericJsonData(urlString: "", decodeBy: SideBarModel.self) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async { self.isLoading = false }
//            
//            switch result {
//            
//            case .success(let responce):
//                DispatchQueue.main.async {
//                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
//                }
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
    
    // MARK: - Private Methods
    
}


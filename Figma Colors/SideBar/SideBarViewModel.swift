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
    var bag = [AnyCancellable]()
    // MARK: - Private Methods
    fileprivate let dataFetcher = NetworkDataFetcher()

    // MARK: - Lifecycle
    init() {
        
    }
    
    // MARK: - Public methods

    
    // MARK: - Private Methods
    
}


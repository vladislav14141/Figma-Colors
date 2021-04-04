//
//  SettingsViewModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 30.03.2021. All rights reserved.
//

import Combine
import Foundation

class SettingsViewModel: ObservableObject {
    // MARK: - Public Properties
    @Published var nameCase: NameCase
    @Published var gradientSeparator: String

    var bag = [AnyCancellable]()
    // MARK: - Private Methods

    // MARK: - Lifecycle
    init() {
        nameCase = settings.nameCase
        gradientSeparator = settings.gradientSeparator
        
        $nameCase.dropFirst().sink { nameCase in
            settings.nameCase = nameCase
        }.store(in: &bag)
        
        $gradientSeparator.dropFirst().sink { gradientSeparator in
            settings.gradientSeparator = gradientSeparator
        }.store(in: &bag)
    }
    
    // MARK: - Public methods
    func fetchData() {
   
    }
    
    // MARK: - Private Methods
    
}


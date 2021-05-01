//
//  ProjectsSideBarController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 30.04.2021. All rights reserved.
//

import SwiftUI

struct ProjectsSideBarController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: ProjectsSideBarViewModel = ProjectsSideBarViewModel()
    
    // MARK: - Private Properties
    
    // MARK: - Lifecycle
    init() {

    }
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 16) {
                
            }.onAppear {
                viewModel.fetchData()
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct ProjectsSideBarController_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsSideBarController()
    }
}

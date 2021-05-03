//
//  SideBarController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import SwiftUI

struct SideBarController: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: SideBarViewModel = SideBarViewModel()
    @StateObject var factory = FigmaFactory()
    @StateObject var storage = FigmaStorage.shared
    // MARK: - Private Properties
    
    // MARK: - Lifecycle
    init() {

    }
    
        var body: some View {
            HStack(spacing: 0) {
                
                NavigationView {
                    List {
                        
                        SideBarColorButton(figmaColors: $storage.colors)
                        SideBarGradientButton(items: $storage.gradients)
                        SideBarComponentButton(items: $storage.components)

                        
//                        NavigationLink(destination: ComponentsPage(items: $storage.components)) {
//                            Text("Components")
//                        }
//                        
//                        NavigationLink(destination: ImagesPage(images: $storage.images)) {
//                            Text("Images")
//                        }
                    }
                    .listStyle(SidebarListStyle())
                    .navigationTitle("Main")
                }
                InfoPage(viewModel: factory)
            
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct SideBarController_Previews: PreviewProvider {
    static var previews: some View {
        SideBarController()
    }
}






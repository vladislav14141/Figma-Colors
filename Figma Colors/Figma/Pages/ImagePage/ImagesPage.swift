//
//  ImagesController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Grid
import URLImage
struct ImagesPage: View {
    
    // MARK: - Public Properties
    @StateObject private var viewModel: ImagesViewModel = ImagesViewModel()
    fileprivate let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    fileprivate let lazyStackSpacing: CGFloat = 16
    // MARK: - Private Properties
    @State var hoveredIndex: Int? = 2
    @State var style = StaggeredGridStyle(.vertical, tracks: .min(200), spacing: 1)

    // MARK: - Lifecycle
    init() {

    }
    
    @State var items: [Int] = (1...69).map { $0 }

    var body: some View {
        ScrollView {
            Grid(viewModel.webImages) { image in
                image
            }
            .animation(.easeInOut)
            .gridStyle(
                self.style
            )
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct ImagesController_Previews: PreviewProvider {
    static var previews: some View {
        ImagesPage()
    }
}

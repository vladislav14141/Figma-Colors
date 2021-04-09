//
//  ContentPage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 09.04.2021.
//

import SwiftUI


struct ContentPage: View {
    @StateObject var viewModel: FigmaViewModel
    @Binding var currentType: FigmaContentType
    var body: some View {
        ScrollView {
            VStack {
                ColorsPage(items: $viewModel.figmaColors).isHidden(hide(view: .colors))
                GradientsPage(items: $viewModel.figmaGradient).isHidden(hide(view: .gradients))
                ComponentsPage(items: $viewModel.figmaImages).isHidden(hide(view: .images))
                MockPage().isHidden(!viewModel.isLoading)
                
            }.padding()
        }
    }
    
    func hide(view type: FigmaContentType) -> Bool {
        !(currentType == type || currentType == .all)
    }
}

//struct ContentPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentPage()
//    }
//}

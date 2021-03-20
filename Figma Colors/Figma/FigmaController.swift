//
//  FigmaController.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021. All rights reserved.
//

import SwiftUI

struct FigmaController: View {

    // MARK: - Public Properties
    @StateObject private var viewModel: FigmaViewModel = FigmaViewModel()
    
    // MARK: - Private Properties


    // MARK: - Lifecycle
    init() {

    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("X-Figma-Token", text: viewModel.$figmaToken)
            HStack(alignment: .center, spacing: 16) {
                TextField("Figma file light", text: viewModel.$fileKeyLight)
                TextField("Figma file dark", text: viewModel.$fileKeyDark)
            }
            Button("Получить") {
                viewModel.getData()
            }
            ScrollView {
                if viewModel.isLoading { ProgressView() }
                
                if viewModel.figmaColors.isEmpty == false {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.figmaColors.indices) { i in
                                let color = viewModel.figmaColors[i]
                                let previus: FigmaColor1? = i > 0 ? viewModel.figmaColors[i - 1] : nil
                                let newSection = previus?.groupName != color.groupName
                                
                                if newSection, let group = color.groupName {
                                    Text(group).font(.title2).bold().padding(.top).padding(.leading, 100 + 8)
                                }
                                
                                HStack(spacing: 8) {
                                    Text(color.name)
                                        .font(.headline)
                                        .bold()
                                        .frame(width: 100)
                                    
                                    color.light
                                        .frame(width: 60,
                                               height: 60)
                                        .cornerRadius(16)
                                    
                                    color.dark
                                        .frame(width: 60,
                                               height: 60)
                                        .cornerRadius(16)
                                    Spacer()
                                }
                            }
                        }.padding()
                    }
                }
            }.onAppear {
                viewModel.getData()
            }
//            .padding()
            .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, idealHeight: 1000, maxHeight: .infinity, alignment: .top)
            .padding()

    }
    
    // MARK: - Public methods
    
    // MARK: - Private Methods
    
}

struct FigmaController_Previews: PreviewProvider {
    static var previews: some View {
        FigmaController()
    }
}

struct SafariPreview: View {
    @ObservedObject var model: WebViewModel
    init(mesgURL: String) {
        self.model = WebViewModel(link: mesgURL)
    }
    
    var body: some View {
        //Create a VStack that contains the buttons in a preview as well a the webpage itself
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Spacer()
                //The title of the webpage
                Text(self.model.didFinishLoading ? self.model.pageTitle : "")
                Spacer()
                //The "Open with Safari" button on the top right side of the preview
                Button(action: {
                    if let url = URL(string: self.model.link) {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Open with Safari")
                }
            }
            //The webpage itself
            SwiftUIWebView(viewModel: model)
        }.frame(width: 800, height: 450, alignment: .bottom)
            .padding(5.0)
    }
}
}

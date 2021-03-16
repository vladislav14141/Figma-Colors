//
//  ContentView.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Text("Название папки").font(.headline)

                TextField("Название папки", text: $viewModel.folderName)
            }
            HStack {
                VStack {
                    Text("Light").font(.title3)
                    TextEditor(text: $viewModel.lightColors)
                }
                
                VStack {
                    Text("Dark").font(.title3)
                    TextEditor(text: $viewModel.darkColors)
                }
            }
            
            HStack {
                Button("Очистить") {
                    viewModel.darkColors = ""
                    viewModel.lightColors = ""
                }
                
                Button (action: {
                    viewModel.generateColor()
                }, label: {
                    Text("Сгенерировать").frame(minWidth: 200)
                }).accentColor(.blue)
            }
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

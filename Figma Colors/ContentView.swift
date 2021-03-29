//
//  ContentView.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MainViewModel()
    @State var openCode = false
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
                
                if viewModel.parsedColors.isEmpty == false {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(viewModel.parsedColors.indices) { i in
                                let color = viewModel.parsedColors[i]
                                let previus: FigmaColorTest? = i > 0 ? viewModel.parsedColors[i - 1] : nil
                                let newSection = previus?.groupName != color.groupName
                                
                                if newSection {
                                    Text(color.groupName).font(.title2).bold().padding(.top).padding(.leading, 100 + 8)
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
                                }
                            }
                        }.padding()
                    }
                }
            }
            
            HStack {
                Button("Очистить") {
                    viewModel.darkColors = ""
                    viewModel.lightColors = ""
                    viewModel.removeData()
                }
                
                Button (action: {
                    viewModel.generateColor()
                }, label: {
                    Text("Сгенерировать").frame(minWidth: 200)
                }).accentColor(.blue)


                Button (action: {
                    openCode = true
                }, label: {
                    Text("Код").frame(minWidth: 200)
                }).accentColor(.blue)
                .disabled(viewModel.parsedColors.isEmpty)
            }.sheet(isPresented: $openCode, content: {
                
            })
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

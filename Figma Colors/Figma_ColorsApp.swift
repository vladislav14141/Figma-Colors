//
//  Figma_ColorsApp.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 16.03.2021.
//

import SwiftUI

@main
struct Figma_ColorsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViews().frame(minWidth: 1300, minHeight: 600)
                //.aspectRatio(1.6, contentMode: .fill)
//            1440x900 2560x1600
        }

    }
}
struct ContentViews: View {
    @StateObject var storage: FigmaStorage
    @StateObject var factory: FigmaFactory
    
    init() {
//        let storage: FigmaStorage = storage
        let factory = FigmaFactory(storage: figmaStorageDefault)
        self._storage = StateObject(wrappedValue: figmaStorageDefault)
        self._factory = StateObject(wrappedValue: factory)
    }
    var body: some View {
        NavigationView {
            SideBarController()
            if storage.isLoading {
                MockPage()
            } else if !storage.storageIsEmpty {
                ColorSideBar(items: .constant([]))
            }
            Spacer()
            InfoPage()
        }.onAppear {
            factory.storage = storage
        }.environmentObject(factory).environmentObject(storage)
        
    }
}

//
//  IOSExportModel.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 28.03.2021.
//

import SwiftUI

class IOSExportModel: ExportModel {
    override var title: String { "iOS" }
    override var buttons: [ExportButtonModel] {
        return [.init(title: "Code", handle: {print("Code")})]
    }
}
struct ExportButtonModel {
    let title: String
    let handle: ()->()
}
class IOSAssetsExportModel: ExportModel {
    override var title: String { "iOS Assets" }
    override var buttons: [ExportButtonModel] {
        
        return [.init(title: "Code", handle: {Notifications.showCode.post()}), .init(title: "Download Assets", handle: {self.onExportAll(figmaColors: [])})]
    }
    let directoryHelper = DirectoryHelper()
    
    func onExportAll(figmaColors: [FigmaSection<ColorItem>]) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;
        dialog.prompt = "Save"

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                
                let path: String = result!.path
//                var colors: [ColorItem] = []
//                figmaColors.forEach {
//                    $0.colors.forEach {
//                        colors.append($0)
//                    }
//                }
//                directoryHelper.exportColors(colors: colors, directoryPath: path)
                print("path", path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
}

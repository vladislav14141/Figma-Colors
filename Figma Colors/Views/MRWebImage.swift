//
//  MRWebImage.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 15.04.2021.
//

import SwiftUI
import URLImage
struct MRWebImage: View, Identifiable {

    let url: URL
    let id: UUID = UUID()

    init(url: URL) {
        self.url = url

        formatter = NumberFormatter()
        formatter.numberStyle = .percent
    }
    
    init(url: String?) {
        self.url = URL(string: url ?? "")!
        formatter = NumberFormatter()
        formatter.numberStyle = .percent
    }
    
    private let formatter: NumberFormatter // Used to format download progress as percentage. Note: this is only for example, better use shared formatter to avoid creating it for every view.
    
    var body: some View {
        URLImage(url: url,
                 options: URLImageOptions(
                    identifier: url.absoluteString,      // Custom identifier
                    expireAfter: 600.0,             // Expire after 5 minutes
                    cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25) // Return cached image or download after delay
                 ),
                 empty: {
                    Image("1")            // This view is displayed before download starts
                 },
                 inProgress: { progress -> Text in  // Display progress
                    if let progress = progress {
                        return Text(formatter.string(from: progress as NSNumber) ?? "Loading...")
                    }
                    else {
                        return Text("Loading...")
                    }
                 },
                 failure: { error, retry in         // Display error and retry button
                    VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: retry)
                    }
                 },
                 content: { image in                // Content view
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                 })
    }
}

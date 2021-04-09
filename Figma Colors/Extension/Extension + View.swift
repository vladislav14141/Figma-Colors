//
//  Extension + View.swift
//  AppConstructor
//
//  Created by Владислав Миронов on 28.01.2021.
//

import SwiftUI

extension View {

    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
    
    @ViewBuilder func redacted(_ condition: Bool = true) -> some View {
        if !condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
}

//
//  MRButton.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 07.05.2021.
//

import SwiftUI

struct RSTButtonAppereance {
    var backgroundColor = Color.clear
    var hoveredBackground = Color.clear
    var selectedBackgroundColor = Color.clear
    var textColor = Color.clear
    var disabledBackground = Color.clear
    var disabledText = Color.clear
    var alignment: Alignment = .center
}

enum RSTButtonAppereanceType {
    case primaryOpacity2
    case primaryOpacity
    case primary
    var appereance: RSTButtonAppereance {
        switch self {
        case .primary:
            return RSTButtonAppereance(backgroundColor: Color.primary08,
                                       hoveredBackground: Color.primary06,
                                       selectedBackgroundColor: Color.primary04,
                                       textColor: .white,
                                       disabledBackground: .grey06,
                                       disabledText: .grey11)
        case .primaryOpacity:
            return RSTButtonAppereance(backgroundColor: Color.primary03,
                                       hoveredBackground: Color.primary02,
                                       selectedBackgroundColor: Color.primary01,
                                       textColor: .white,
                                       disabledBackground: .grey06,
                                       disabledText: .grey11)
        case .primaryOpacity2:
            return RSTButtonAppereance(backgroundColor: Color.clear,
                                       hoveredBackground: Color.primary02,
                                       selectedBackgroundColor: Color.primary04,
                                       textColor: .white,
                                       disabledBackground: .grey06,
                                       disabledText: .grey11)

        }
    }
}

struct RSTButton: View {

    private let title: String?
    private let iconName: String?
    private var onTap: (()->())? = nil
    private var font: Font
    private var enabled: Bool
    @Binding private var loading: Bool
    @State var isHovered = false
    @State var isPressed = false
    private var type: RSTButtonAppereanceType
    private var appereance: RSTButtonAppereance {
        type.appereance
    }
    
    init(iconName: String? = nil, title: String? = nil, enabled: Bool = true, loading:  Binding<Bool>? = nil, appereance: RSTButtonAppereanceType = .primaryOpacity, onTap: (()->())? = nil) {
        self.title = title
        self.iconName = iconName
        self.font = .subheadline
        self.enabled = enabled
        self.onTap = onTap
        self.type = appereance
        self._loading = loading ?? Binding.constant(false)
    }
    
    var loadingTitle: String? {
        loading ? "" : title
    }
    
    var loadingEnabled: Bool {
        loading ? false : enabled
    }
    
    var body: some View {

        Button(action: {
            onTap?()
        }, label: {
            HStack {
                if let icon = iconName {
                    Image(systemName: icon).font(.title3)
                }
                
                if let title = title {
                    Text(title).font(font)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .frame(minWidth: 32, maxWidth: .infinity)
            .frame(height: 32)
            .background(backgroundColor())
        })
        .font(font.weight(.semibold))
        .foregroundColor(enabled ? appereance.textColor : appereance.disabledText)
        .buttonStyle(MRButtonStyle(type: .opacity) { isPressed = $0 })
        .disabled(!enabled)
        .whenHovered({ (isHovered) in
            self.isHovered = isHovered
        })
        .clipShape(RoundedRectangle(cornerRadius: 8))

    }

    @ViewBuilder func loadingIndicator() -> some View {
        if loading {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    private func backgroundColor() -> Color {
        if enabled {
            if isPressed {
                return appereance.selectedBackgroundColor
            } else if isHovered {
                return appereance.hoveredBackground
            } else {
                return appereance.backgroundColor
            }
        } else {
            return appereance.disabledBackground
        }
    }
}

//struct RSTButtonStyle: ButtonStyle {
//    private let appereance: RSTButtonAppereance
//    private let enabled: Bool
//
//    init(appereance: RSTButtonAppereance, enabled: Bool = true) {
//        self.enabled = enabled
//        self.appereance = appereance
//    }
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .frame(maxWidth: .infinity)
//            .frame(height: 40)
//            .foregroundColor(enabled ? appereance.textColor : appereance.disabledText)
//            .background(backgroundColor(configuration))
//            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
//            .disabled(!enabled)
//
//    }
//
//    private func backgroundColor(_ configuration: Self.Configuration) -> Color {
//        if enabled {
//            if configuration.isPressed {
//                return appereance.selectedBackgroundColor
//            } else {
//                return appereance.backgroundColor
//            }
//        } else {
//            return appereance.disabledBackground
//        }
//    }
//}

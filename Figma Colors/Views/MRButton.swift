//
//  MRButton.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 07.05.2021.
//

import SwiftUI

struct RSTButtonAppereance {
    var backgroundColor = Color.clear
    var selectedBackgroundColor = Color.clear
    var textColor = Color.clear
    var disabledBackground = Color.clear
    var disabledText = Color.clear
    var alignment: Alignment = .center
}

enum RSTButtonAppereanceType {
    case primaryOpacity
    case primary
    var appereance: RSTButtonAppereance {
        switch self {
        case .primary:
            return RSTButtonAppereance(backgroundColor: Color.buttonBackground, selectedBackgroundColor: Color.buttonBackground.opacity(0.8), textColor: .white, disabledBackground: .disabledButtonBackground, disabledText: .disabledButtonText)
        case .primaryOpacity:
            return RSTButtonAppereance(backgroundColor: Color.buttonBackground.opacity(0.5), selectedBackgroundColor: Color.buttonBackground.opacity(0.25), textColor: .white, disabledBackground: .disabledButtonBackground, disabledText: .disabledButtonText)

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

    private var type: RSTButtonAppereanceType
    private var appereance: RSTButtonAppereance {
        type.appereance
    }
    
    init(iconName: String? = nil, title: String? = nil, enabled: Bool = true, loading:  Binding<Bool>? = nil, appereance: RSTButtonAppereanceType = .primaryOpacity, onTap: (()->())? = nil) {
        self.title = title
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
        })
            .font(font.weight(.semibold))
            .buttonStyle(RSTButtonStyle(appereance: appereance, enabled: enabled))
            .disabled(!enabled)
        
    }

    @ViewBuilder func loadingIndicator() -> some View {
        if loading {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct RSTButtonStyle: ButtonStyle {
    private let appereance: RSTButtonAppereance
    private let enabled: Bool
    
    init(appereance: RSTButtonAppereance, enabled: Bool = true) {
        self.enabled = enabled
        self.appereance = appereance
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .foregroundColor(enabled ? appereance.textColor : appereance.disabledText)
            .background(backgroundColor(configuration))
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
            .disabled(!enabled)
        
    }
    
    private func backgroundColor(_ configuration: Self.Configuration) -> Color {
        if enabled {
            if configuration.isPressed {
                return appereance.selectedBackgroundColor
            } else {
                return appereance.backgroundColor
            }
        } else {
            return appereance.disabledBackground
        }
    }
}

//
//  AppButton.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Button

/// Reusable button component with consistent styling
struct AppButton: View {
    
    // MARK: - Properties
    
    let title: String
    let icon: String?
    let style: ButtonStyle
    let size: ButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    // MARK: - Initialization
    
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        size: ButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xSmall) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .font(size.font)
                }
            }
            .frame(maxWidth: size.maxWidth)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .foregroundColor(style.foregroundColor)
            .background(style.backgroundColor)
            .cornerRadius(AppRadius.button)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - Button Style

extension AppButton {
    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
        case destructive
        case success
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color.appPrimary
            case .secondary:
                return .clear
            case .tertiary:
                return .clear
            case .destructive:
                return Color.appError
            case .success:
                return Color.appSuccess
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .destructive, .success:
                return .white
            case .secondary:
                return Color.appPrimary
            case .tertiary:
                return Color.appText
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary, .destructive, .success:
                return .clear
            case .secondary:
                return Color.appPrimary
            case .tertiary:
                return .clear
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .secondary:
                return 2
            default:
                return 0
            }
        }
    }
}

// MARK: - Button Size

extension AppButton {
    enum ButtonSize {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small:
                return Font.appButtonSmall
            case .medium:
                return Font.appButtonSecondary
            case .large:
                return Font.appButton
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return AppSpacing.medium
            case .medium:
                return AppSpacing.large
            case .large:
                return AppSpacing.xLarge
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small:
                return AppSpacing.xSmall
            case .medium:
                return AppSpacing.small
            case .large:
                return AppSpacing.medium
            }
        }
        
        var maxWidth: CGFloat? {
            switch self {
            case .large:
                return .infinity
            default:
                return nil
            }
        }
    }
}

// MARK: - Previews

#Preview("Button Styles") {
    VStack(spacing: AppSpacing.large) {
        AppButton("Primary Button", style: .primary, size: .large) {
            print("Primary tapped")
        }
        .tint(Color.appPrimary)
        
        AppButton("Secondary Button", style: .secondary, size: .medium) {
            print("Secondary tapped")
        }
        
        AppButton("Tertiary Button", style: .tertiary, size: .small) { }
        AppButton("Success Button", style: .success) { }
    }
    .padding()
}

#Preview("Button Sizes") {
    VStack(spacing: AppSpacing.medium) {
        AppButton("Small Button", size: .small) { }
        AppButton("Medium Button", size: .medium) { }
        AppButton("Large Button", size: .large) { }
    }
    .padding()
}

#Preview("Button States") {
    VStack(spacing: AppSpacing.medium) {
        AppButton("With Icon", icon: "star.fill", style: .primary, size: .medium) {
            print("Icon button tapped")
        }
        .tint(Color.appPrimary)
        
        AppButton("Loading", style: .primary, size: .medium, isLoading: true) {}
            .tint(Color.appText)
        
        AppButton("Disabled", style: .primary, size: .medium) {}
            .disabled(true)
            .tint(Color.appPrimary)
    }
    .padding()
}

#Preview("Button with Icon") {
    VStack(spacing: AppSpacing.medium) {
        AppButton("Continue", icon: "arrow.right", style: .primary) { }
        AppButton("Delete", icon: "trash", style: .destructive) { }
        AppButton("Save", icon: "checkmark", style: .success) { }
    }
    .padding()
}

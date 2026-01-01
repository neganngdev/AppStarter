//
//  AppCard.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Card

/// Reusable card container component
struct AppCard<Content: View>: View {
    
    // MARK: - Properties
    
    let variant: CardVariant
    let padding: CGFloat
    let cornerRadius: CGFloat
    let content: Content
    
    // MARK: - Initialization
    
    init(
        variant: CardVariant = .elevated,
        padding: CGFloat = AppSpacing.cardPadding,
        cornerRadius: CGFloat = AppRadius.card,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .padding(padding)
            .background(variant.backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(variant.borderColor, lineWidth: variant.borderWidth)
            )
            .appShadow(variant.shadow)
    }
}

// MARK: - Card Variant

extension AppCard {
    enum CardVariant {
        case flat
        case elevated
        case outlined
        
        var backgroundColor: Color {
            switch self {
            case .flat, .elevated:
                return .appSecondaryBackground
            case .outlined:
                return .clear
            }
        }
        
        var borderColor: Color {
            switch self {
            case .outlined:
                return .appBorder
            default:
                return .clear
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .outlined:
                return 1
            default:
                return 0
            }
        }
        
        var shadow: AppShadow {
            switch self {
            case .elevated:
                return .medium
            default:
                return .none
            }
        }
    }
}

// MARK: - Convenience Initializers

extension AppCard {
    
    /// Create a flat card
    static func flat(@ViewBuilder content: () -> Content) -> AppCard {
        AppCard(variant: .flat, content: content)
    }
    
    /// Create an elevated card
    static func elevated(@ViewBuilder content: () -> Content) -> AppCard {
        AppCard(variant: .elevated, content: content)
    }
    
    /// Create an outlined card
    static func outlined(@ViewBuilder content: () -> Content) -> AppCard {
        AppCard(variant: .outlined, content: content)
    }
}

// MARK: - Previews

#Preview("Card Variants") {
    VStack(spacing: AppSpacing.large) {
        AppCard(variant: .flat) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("Flat Card")
                    .font(.appHeadline)
                Text("No shadow, solid background")
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
            }
        }
        
        AppCard(variant: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("Elevated Card")
                    .font(.appHeadline)
                Text("With shadow for depth")
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
            }
        }
        
        AppCard(variant: .outlined) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text("Outlined Card")
                    .font(.appHeadline)
                Text("Border with no background")
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
            }
        }
    }
    .padding()
    .background(.appBackground)
}

#Preview("Card Content") {
    AppCard {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.appPrimary)
                Text("Premium Feature")
                    .font(.appHeadline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.appSecondaryText)
            }
            
            Text("Unlock all premium features with a subscription")
                .font(.appBody)
                .foregroundColor(.appSecondaryText)
            
            AppButton("Upgrade Now", style: .primary, size: .large) { }
        }
    }
    .padding()
}

//
//  AppShadow.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Shadow

/// Consistent shadow styles for the app
/// Use these for elevation and depth
enum AppShadow {
    
    // MARK: - Shadow Styles
    
    /// No shadow
    case none
    
    /// Small shadow (subtle elevation)
    case small
    
    /// Medium shadow (moderate elevation)
    case medium
    
    /// Large shadow (prominent elevation)
    case large
    
    /// Extra large shadow (maximum elevation)
    case xLarge
    
    // MARK: - Shadow Properties
    
    var color: Color {
        Color.black.opacity(opacity)
    }
    
    var opacity: Double {
        switch self {
        case .none:
            return 0
        case .small:
            return 0.1
        case .medium:
            return 0.15
        case .large:
            return 0.2
        case .xLarge:
            return 0.25
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .none:
            return 0
        case .small:
            return 4
        case .medium:
            return 8
        case .large:
            return 12
        case .xLarge:
            return 16
        }
    }
    
    var x: CGFloat {
        0
    }
    
    var y: CGFloat {
        switch self {
        case .none:
            return 0
        case .small:
            return 2
        case .medium:
            return 4
        case .large:
            return 6
        case .xLarge:
            return 8
        }
    }
}

// MARK: - View Extensions

extension View {
    
    /// Apply shadow style
    /// - Parameter style: Shadow style to apply
    /// - Returns: Modified view
    func appShadow(_ style: AppShadow = .medium) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
    
    /// Apply small shadow
    func smallShadow() -> some View {
        self.appShadow(.small)
    }
    
    /// Apply medium shadow
    func mediumShadow() -> some View {
        self.appShadow(.medium)
    }
    
    /// Apply large shadow
    func largeShadow() -> some View {
        self.appShadow(.large)
    }
    
    /// Apply card shadow (medium elevation)
    func cardShadow() -> some View {
        self.appShadow(.medium)
    }
    
    /// Apply button shadow (small elevation)
    func buttonShadow() -> some View {
        self.appShadow(.small)
    }
    
    /// Apply modal shadow (large elevation)
    func modalShadow() -> some View {
        self.appShadow(.large)
    }
}

// MARK: - Card Style Modifier

struct CardStyle: ViewModifier {
    var backgroundColor: Color = .appSecondaryBackground
    var cornerRadius: CGFloat = AppRadius.card
    var shadow: AppShadow = .medium
    var padding: CGFloat = AppSpacing.cardPadding
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .appShadow(shadow)
    }
}

extension View {
    
    /// Apply card style with shadow
    /// - Parameters:
    ///   - backgroundColor: Background color
    ///   - cornerRadius: Corner radius
    ///   - shadow: Shadow style
    ///   - padding: Content padding
    /// - Returns: Modified view
    func cardStyle(
        backgroundColor: Color = .appSecondaryBackground,
        cornerRadius: CGFloat = AppRadius.card,
        shadow: AppShadow = .medium,
        padding: CGFloat = AppSpacing.cardPadding
    ) -> some View {
        self.modifier(CardStyle(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadow: shadow,
            padding: padding
        ))
    }
}

// MARK: - Button Style Modifier

struct ElevatedButtonStyle: ButtonStyle {
    var backgroundColor: Color = .appPrimary
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = AppRadius.button
    var shadow: AppShadow = .small
    var padding: EdgeInsets = EdgeInsets(
        top: AppSpacing.small,
        leading: AppSpacing.large,
        bottom: AppSpacing.small,
        trailing: AppSpacing.large
    )
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadius)
            .appShadow(shadow)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension View {
    
    /// Apply elevated button style
    /// - Parameters:
    ///   - backgroundColor: Button background color
    ///   - foregroundColor: Button text color
    /// - Returns: Modified view
    func elevatedButtonStyle(
        backgroundColor: Color = .appPrimary,
        foregroundColor: Color = .white
    ) -> some View {
        self.buttonStyle(ElevatedButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        ))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Basic shadows:
 
 ```swift
 Rectangle()
     .fill(.white)
     .frame(width: 200, height: 100)
     .smallShadow()
 
 Rectangle()
     .fill(.white)
     .frame(width: 200, height: 100)
     .mediumShadow()
 
 Rectangle()
     .fill(.white)
     .frame(width: 200, height: 100)
     .largeShadow()
 ```
 
 2. Card with shadow:
 
 ```swift
 VStack(alignment: .leading, spacing: AppSpacing.small) {
     Text("Card Title")
         .font(.appHeadline)
     Text("Card description goes here")
         .font(.appBody)
 }
 .cardStyle()
 
 // Custom card style
 VStack {
     Text("Custom Card")
 }
 .cardStyle(
     backgroundColor: .appPrimary,
     cornerRadius: AppRadius.large,
     shadow: .large
 )
 ```
 
 3. Button with shadow:
 
 ```swift
 Button("Primary Action") { }
     .elevatedButtonStyle()
 
 Button("Secondary") { }
     .elevatedButtonStyle(
         backgroundColor: .appSecondary,
         foregroundColor: .white
     )
 ```
 
 4. Floating action button:
 
 ```swift
 Button(action: {}) {
     Image(systemName: "plus")
         .font(.title2)
         .foregroundColor(.white)
 }
 .frame(width: 56, height: 56)
 .background(.appPrimary)
 .cornerRadius(AppRadius.pill)
 .largeShadow()
 ```
 
 5. Modal/sheet with shadow:
 
 ```swift
 VStack {
     // Modal content
 }
 .padding()
 .background(.appBackground)
 .cornerRadius(AppRadius.modal, corners: [.topLeft, .topRight])
 .modalShadow()
 ```
 
 6. List item with subtle shadow:
 
 ```swift
 HStack {
     Image(systemName: "person.fill")
     Text("John Doe")
     Spacer()
 }
 .padding()
 .background(.appSecondaryBackground)
 .cornerRadius(AppRadius.small)
 .smallShadow()
 ```
 
 7. Elevation hierarchy:
 
 ```swift
 ZStack {
     // Background (no shadow)
     Color.appBackground
         .ignoresSafeArea()
     
     VStack(spacing: AppSpacing.large) {
         // Level 1 (small shadow)
         Text("Level 1")
             .padding()
             .background(.white)
             .cornerRadius(AppRadius.medium)
             .smallShadow()
         
         // Level 2 (medium shadow)
         Text("Level 2")
             .padding()
             .background(.white)
             .cornerRadius(AppRadius.medium)
             .mediumShadow()
         
         // Level 3 (large shadow)
         Text("Level 3")
             .padding()
             .background(.white)
             .cornerRadius(AppRadius.medium)
             .largeShadow()
     }
 }
 ```
 
 8. Custom shadow:
 
 ```swift
 Rectangle()
     .fill(.white)
     .appShadow(.xLarge)
 ```
 
 */

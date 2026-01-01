//
//  AppColors.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Colors

/// Centralized color system for the app
/// CUSTOMIZE: Modify these colors to match your app's brand
extension Color {
    
    // MARK: - Brand Colors
    
    /// Primary brand color
    /// CUSTOMIZE: Change to your brand color
    static let appPrimary = Color(hex: AppConfig.primaryColor)
    
    /// Secondary brand color
    /// CUSTOMIZE: Change to complement your primary color
    static let appSecondary = Color(hex: AppConfig.accentColor)
    
    /// Accent color for highlights and CTAs
    static let appAccent = Color.appPrimary
    
    // MARK: - Background Colors
    
    /// Primary background color (adapts to light/dark mode)
    static let appBackground = Color(uiColor: .systemBackground)
    
    /// Secondary background color for cards, sections
    static let appSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    
    /// Tertiary background color for grouped content
    static let appTertiaryBackground = Color(uiColor: .tertiarySystemBackground)
    
    /// Grouped background (for grouped lists)
    static let appGroupedBackground = Color(uiColor: .systemGroupedBackground)
    
    // MARK: - Text Colors
    
    /// Primary text color
    static let appText = Color(uiColor: .label)
    
    /// Secondary text color (less prominent)
    static let appSecondaryText = Color(uiColor: .secondaryLabel)
    
    /// Tertiary text color (even less prominent)
    static let appTertiaryText = Color(uiColor: .tertiaryLabel)
    
    /// Disabled text color
    static let appDisabledText = Color(uiColor: .quaternaryLabel)
    
    /// Placeholder text color
    static let appPlaceholder = Color(uiColor: .placeholderText)
    
    // MARK: - Semantic Colors
    
    /// Success color (green)
    static let appSuccess = Color.dynamic(
        light: Color(hex: "#34C759"),
        dark: Color(hex: "#30D158")
    )
    
    /// Warning color (orange/yellow)
    static let appWarning = Color.dynamic(
        light: Color(hex: "#FF9500"),
        dark: Color(hex: "#FF9F0A")
    )
    
    /// Error/destructive color (red)
    static let appError = Color.dynamic(
        light: Color(hex: "#FF3B30"),
        dark: Color(hex: "#FF453A")
    )
    
    /// Info color (blue)
    static let appInfo = Color.dynamic(
        light: Color(hex: "#007AFF"),
        dark: Color(hex: "#0A84FF")
    )
    
    // MARK: - UI Element Colors
    
    /// Border color
    static let appBorder = Color(uiColor: .separator)
    
    /// Separator color
    static let appSeparator = Color(uiColor: .separator)
    
    /// Fill color for buttons, controls
    static let appFill = Color(uiColor: .systemFill)
    
    /// Secondary fill color
    static let appSecondaryFill = Color(uiColor: .secondarySystemFill)
    
    /// Tertiary fill color
    static let appTertiaryFill = Color(uiColor: .tertiarySystemFill)
    
    // MARK: - Overlay Colors
    
    /// Overlay for modals, sheets
    static let appOverlay = Color.black.opacity(0.4)
    
    /// Scrim for dimming background
    static let appScrim = Color.black.opacity(0.3)
    
    // MARK: - Tint Colors
    
    /// Link color
    static let appLink = Color.appInfo
    
    /// Destructive action color
    static let appDestructive = Color.appError
    
    // MARK: - Custom Colors (Add your own)
    
    /// Premium/gold color
    static let appPremium = Color.dynamic(
        light: Color(hex: "#FFD700"),
        dark: Color(hex: "#FFC700")
    )
    
    /// Verified badge color
    static let appVerified = Color.dynamic(
        light: Color(hex: "#1DA1F2"),
        dark: Color(hex: "#1DA1F2")
    )
}

// MARK: - Color Utilities

extension Color {
    
    /// Create color from hex string
    /// - Parameter hex: Hex string (e.g., "#FF5733" or "FF5733")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Create dynamic color for light/dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    /// - Returns: Dynamic color
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(uiColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        }))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Using predefined colors:
 
 ```swift
 Text("Hello")
     .foregroundColor(.appText)
     .background(.appBackground)
 
 Button("Primary") { }
     .foregroundColor(.white)
     .background(.appPrimary)
 
 Text("Error message")
     .foregroundColor(.appError)
 ```
 
 2. Semantic colors:
 
 ```swift
 // Success message
 Label("Success!", systemImage: "checkmark.circle")
     .foregroundColor(.appSuccess)
 
 // Warning banner
 HStack {
     Image(systemName: "exclamationmark.triangle")
     Text("Warning")
 }
 .foregroundColor(.appWarning)
 .padding()
 .background(.appWarning.opacity(0.1))
 
 // Error state
 Text("Error occurred")
     .foregroundColor(.appError)
 ```
 
 3. Background hierarchy:
 
 ```swift
 VStack {
     // Card on secondary background
     VStack {
         Text("Card content")
     }
     .padding()
     .background(.appSecondaryBackground)
     .cornerRadius(12)
 }
 .padding()
 .background(.appBackground)
 ```
 
 4. Custom colors:
 
 ```swift
 // Premium badge
 Label("Premium", systemImage: "crown.fill")
     .foregroundColor(.appPremium)
 
 // Verified badge
 Image(systemName: "checkmark.seal.fill")
     .foregroundColor(.appVerified)
 ```
 
 5. Customizing for your app:
 
 In AppConfig.swift:
 ```swift
 static let primaryColor = "#007AFF"  // Your brand color
 static let accentColor = "#5856D6"   // Your accent color
 ```
 
 Or directly in this file:
 ```swift
 static let appPrimary = Color(hex: "#FF5733")
 static let appSecondary = Color(hex: "#33C3FF")
 ```
 
 */

//
//  Color+Extensions.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Color Extensions

extension Color {
    
    // MARK: - Hex Initialization
    
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (with or without #)
    ///
    /// Supported formats:
    /// - "#RGB" (12-bit)
    /// - "#RRGGBB" (24-bit)
    /// - "#RRGGBBAA" (32-bit with alpha)
    /// - "RGB", "RRGGBB", "RRGGBBAA" (without #)
    ///
    /// Example:
    /// ```swift
    /// Color(hex: "#FF5733")
    /// Color(hex: "FF5733")
    /// Color(hex: "#FF5733AA") // With alpha
    /// Color(hex: "F00") // Short form for #FF0000
    /// ```
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RRGGBB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // RRGGBBAA (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Initialize Color from RGB values (0-255)
    /// - Parameters:
    ///   - red: Red component (0-255)
    ///   - green: Green component (0-255)
    ///   - blue: Blue component (0-255)
    ///   - opacity: Opacity (0-1), default 1
    ///
    /// Example:
    /// ```swift
    /// Color(red: 255, green: 87, blue: 51)
    /// Color(red: 255, green: 87, blue: 51, opacity: 0.8)
    /// ```
    init(red: Int, green: Int, blue: Int, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: opacity
        )
    }
    
    // MARK: - Hex String Conversion
    
    /// Convert Color to hex string
    /// - Parameter includeAlpha: Whether to include alpha channel
    /// - Returns: Hex string representation
    ///
    /// Example:
    /// ```swift
    /// Color.red.toHex() // "#FF0000"
    /// Color.red.toHex(includeAlpha: true) // "#FF0000FF"
    /// ```
    func toHex(includeAlpha: Bool = false) -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = components.count >= 4 ? Float(components[3]) : Float(1.0)
        
        if includeAlpha {
            return String(format: "#%02lX%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255),
                         lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255))
        }
    }
    
    // MARK: - Dynamic Colors (Light/Dark Mode)
    
    /// Create a dynamic color that adapts to light/dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    /// - Returns: Dynamic color
    ///
    /// Example:
    /// ```swift
    /// Color.dynamic(light: .white, dark: .black)
    /// Color.dynamic(light: Color(hex: "FFFFFF"), dark: Color(hex: "000000"))
    /// ```
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ?
                UIColor(dark) : UIColor(light)
        })
    }
    
    // MARK: - Color Manipulation
    
    /// Lighten color by percentage
    /// - Parameter percentage: Percentage to lighten (0-1)
    /// - Returns: Lightened color
    ///
    /// Example:
    /// ```swift
    /// Color.blue.lighter(by: 0.2) // 20% lighter
    /// ```
    func lighter(by percentage: Double = 0.2) -> Color {
        adjust(by: abs(percentage))
    }
    
    /// Darken color by percentage
    /// - Parameter percentage: Percentage to darken (0-1)
    /// - Returns: Darkened color
    ///
    /// Example:
    /// ```swift
    /// Color.blue.darker(by: 0.2) // 20% darker
    /// ```
    func darker(by percentage: Double = 0.2) -> Color {
        adjust(by: -abs(percentage))
    }
    
    /// Adjust color brightness
    /// - Parameter percentage: Percentage to adjust (-1 to 1)
    /// - Returns: Adjusted color
    private func adjust(by percentage: Double) -> Color {
        guard let components = UIColor(self).cgColor.components else { return self }
        
        let r = min(max(components[0] + CGFloat(percentage), 0), 1)
        let g = min(max(components[1] + CGFloat(percentage), 0), 1)
        let b = min(max(components[2] + CGFloat(percentage), 0), 1)
        let a = components.count >= 4 ? components[3] : 1.0
        
        return Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    /// Adjust opacity/alpha
    /// - Parameter opacity: New opacity value (0-1)
    /// - Returns: Color with adjusted opacity
    ///
    /// Example:
    /// ```swift
    /// Color.blue.withOpacity(0.5) // 50% opacity
    /// ```
    func withOpacity(_ opacity: Double) -> Color {
        self.opacity(opacity)
    }
    
    // MARK: - Common Color Palette
    
    /// App-specific colors from AppConfig
    static var appPrimary: Color {
        AppConfig.primaryColor
    }
    
    static var appAccent: Color {
        AppConfig.accentColor
    }
    
    static var appBackground: Color {
        AppConfig.backgroundColor
    }
    
    static var appSecondaryBackground: Color {
        AppConfig.secondaryBackgroundColor
    }
    
    static var appText: Color {
        AppConfig.textColor
    }
    
    static var appSecondaryText: Color {
        AppConfig.secondaryTextColor
    }
    
    // MARK: - Semantic Colors
    
    /// Success color (green)
    static var success: Color {
        Color(red: 52, green: 199, blue: 89)
    }
    
    /// Warning color (orange/yellow)
    static var warning: Color {
        Color(red: 255, green: 204, blue: 0)
    }
    
    /// Error/Danger color (red)
    static var error: Color {
        Color(red: 255, green: 59, blue: 48)
    }
    
    /// Info color (blue)
    static var info: Color {
        Color(red: 0, green: 122, blue: 255)
    }
    
    // MARK: - Gradient Helpers
    
    /// Create linear gradient from this color to another
    /// - Parameters:
    ///   - to: End color
    ///   - startPoint: Start point of gradient
    ///   - endPoint: End point of gradient
    /// - Returns: LinearGradient
    ///
    /// Example:
    /// ```swift
    /// Color.blue.gradient(to: .purple)
    /// Color.blue.gradient(to: .purple, startPoint: .top, endPoint: .bottom)
    /// ```
    func gradient(
        to color: Color,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> LinearGradient {
        LinearGradient(
            colors: [self, color],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    /// Create radial gradient from this color to another
    /// - Parameters:
    ///   - to: End color
    ///   - center: Center point of gradient
    ///   - startRadius: Start radius
    ///   - endRadius: End radius
    /// - Returns: RadialGradient
    func radialGradient(
        to color: Color,
        center: UnitPoint = .center,
        startRadius: CGFloat = 0,
        endRadius: CGFloat = 200
    ) -> RadialGradient {
        RadialGradient(
            colors: [self, color],
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }
    
    // MARK: - Random Color
    
    /// Generate random color
    /// - Returns: Random color
    ///
    /// Example:
    /// ```swift
    /// Color.random() // Random color
    /// ```
    static func random() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// MARK: - Common Color Presets

extension Color {
    
    /// Material Design inspired colors
    struct Material {
        static let red = Color(hex: "#F44336")
        static let pink = Color(hex: "#E91E63")
        static let purple = Color(hex: "#9C27B0")
        static let deepPurple = Color(hex: "#673AB7")
        static let indigo = Color(hex: "#3F51B5")
        static let blue = Color(hex: "#2196F3")
        static let lightBlue = Color(hex: "#03A9F4")
        static let cyan = Color(hex: "#00BCD4")
        static let teal = Color(hex: "#009688")
        static let green = Color(hex: "#4CAF50")
        static let lightGreen = Color(hex: "#8BC34A")
        static let lime = Color(hex: "#CDDC39")
        static let yellow = Color(hex: "#FFEB3B")
        static let amber = Color(hex: "#FFC107")
        static let orange = Color(hex: "#FF9800")
        static let deepOrange = Color(hex: "#FF5722")
    }
    
    /// Pastel color palette
    struct Pastel {
        static let pink = Color(hex: "#FFB3BA")
        static let orange = Color(hex: "#FFDFBA")
        static let yellow = Color(hex: "#FFFFBA")
        static let green = Color(hex: "#BAFFC9")
        static let blue = Color(hex: "#BAE1FF")
        static let purple = Color(hex: "#E0BBE4")
    }
}

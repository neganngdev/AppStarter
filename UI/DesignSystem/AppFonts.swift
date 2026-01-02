//
//  AppFonts.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Fonts

/// Centralized typography system for the app
/// CUSTOMIZE: Modify font names, sizes, and weights to match your app's design
extension Font {
    
    // MARK: - Display Fonts
    
    /// Extra large title (34pt, bold)
    static let appLargeTitle = Font.system(size: 34, weight: .bold, design: .default)
    
    /// Title 1 (28pt, bold)
    static let appTitle = Font.system(size: 28, weight: .bold, design: .default)
    
    /// Title 2 (22pt, bold)
    static let appTitle2 = Font.system(size: 22, weight: .bold, design: .default)
    
    /// Title 3 (20pt, semibold)
    static let appTitle3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    // MARK: - Heading Fonts
    
    /// Headline (17pt, semibold)
    static let appHeadline = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// Subheadline (15pt, regular)
    static let appSubheadline = Font.system(size: 15, weight: .regular, design: .default)
    
    // MARK: - Body Fonts
    
    /// Body text (17pt, regular)
    static let appBody = Font.system(size: 17, weight: .regular, design: .default)
    
    /// Body emphasized (17pt, semibold)
    static let appBodyEmphasized = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// Callout (16pt, regular)
    static let appCallout = Font.system(size: 16, weight: .regular, design: .default)
    
    // MARK: - Small Text
    
    /// Footnote (13pt, regular)
    static let appFootnote = Font.system(size: 13, weight: .regular, design: .default)
    
    /// Caption 1 (12pt, regular)
    static let appCaption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// Caption 2 (11pt, regular)
    static let appCaption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    // MARK: - Button Fonts
    
    /// Primary button text (17pt, semibold)
    static let appButton = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// Secondary button text (15pt, medium)
    static let appButtonSecondary = Font.system(size: 15, weight: .medium, design: .default)
    
    /// Small button text (14pt, medium)
    static let appButtonSmall = Font.system(size: 14, weight: .medium, design: .default)
    
    // MARK: - Custom Fonts (Add your own)
    
    /// Custom font for your app
    /// CUSTOMIZE: Replace with your custom font
    /// Example: static let appCustom = Font.custom("YourFont-Bold", size: 20)
    
    // MARK: - Monospaced Fonts
    
    /// Monospaced body (for code, numbers)
    static let appMono = Font.system(size: 17, weight: .regular, design: .monospaced)
    
    /// Monospaced small (for code snippets)
    static let appMonoSmall = Font.system(size: 14, weight: .regular, design: .monospaced)
}

// MARK: - Custom Font Support

extension Font {
    
    /// Create custom font with fallback to system font
    /// - Parameters:
    ///   - name: Custom font name
    ///   - size: Font size
    ///   - weight: Font weight (fallback)
    /// - Returns: Custom font or system font fallback
    static func custom(_ name: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Try to load custom font, fallback to system font
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size)
        } else {
            return Font.system(size: size, weight: weight)
        }
    }
}

// MARK: - Text Styles

/// Predefined text styles for common use cases
enum AppTextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case bodyEmphasized
    case callout
    case footnote
    case caption
    case caption2
    case button
    case buttonSecondary
    case buttonSmall
    
    var font: Font {
        switch self {
        case .largeTitle: return .appLargeTitle
        case .title: return .appTitle
        case .title2: return .appTitle2
        case .title3: return .appTitle3
        case .headline: return .appHeadline
        case .subheadline: return .appSubheadline
        case .body: return .appBody
        case .bodyEmphasized: return .appBodyEmphasized
        case .callout: return .appCallout
        case .footnote: return .appFootnote
        case .caption: return .appCaption
        case .caption2: return .appCaption2
        case .button: return .appButton
        case .buttonSecondary: return .appButtonSecondary
        case .buttonSmall: return .appButtonSmall
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .largeTitle, .title, .title2, .title3:
            return 2
        case .body, .bodyEmphasized, .callout:
            return 4
        default:
            return 0
        }
    }
}

// MARK: - View Extension

extension View {
    
    /// Apply text style
    /// - Parameter style: Text style to apply
    /// - Returns: Modified view
    func textStyle(_ style: AppTextStyle) -> some View {
        self
            .font(style.font)
            .lineSpacing(style.lineSpacing)
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Using predefined fonts:
 
 ```swift
 Text("Large Title")
     .font(Font.appLargeTitle)
 
 Text("Headline")
     .font(Font.appHeadline)
 
 Text("Body text")
     .font(Font.appBody)
 
 Text("Caption")
     .font(Font.appCaption)
 ```
 
 2. Using text styles:
 
 ```swift
 Text("Title with spacing")
     .textStyle(.title)
 
 Text("Body with spacing")
     .textStyle(.body)
 ```
 
 3. Button text:
 
 ```swift
 Button("Primary Action") { }
     .font(Font.appButton)
 
 Button("Secondary") { }
     .font(Font.appButtonSecondary)
 ```
 
 4. Hierarchy example:
 
 ```swift
 VStack(alignment: .leading, spacing: 8) {
     Text("Welcome")
         .font(Font.appLargeTitle)
         .foregroundColor(Color.appText)
     
     Text("Get started with your journey")
         .font(Font.appSubheadline)
         .foregroundColor(Color.appSecondaryText)
     
     Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
         .font(Font.appBody)
         .foregroundColor(Color.appText)
     
     Text("Last updated: 2 hours ago")
         .font(Font.appCaption)
         .foregroundColor(Color.appTertiaryText)
 }
 ```
 
 5. Custom fonts:
 
 Add your font files to the project, then:
 
 In Info.plist:
 ```xml
 <key>UIAppFonts</key>
 <array>
     <string>YourFont-Regular.ttf</string>
     <string>YourFont-Bold.ttf</string>
 </array>
 ```
 
 In AppFonts.swift:
 ```swift
 static let appCustomTitle = Font.custom("YourFont-Bold", size: 28)
 static let appCustomBody = Font.custom("YourFont-Regular", size: 17)
 ```
 
 6. Monospaced fonts (for numbers, code):
 
 ```swift
 Text("$1,234.56")
     .font(Font.appMono)
 
 Text("let x = 42")
     .font(Font.appMonoSmall)
 ```
 
 */

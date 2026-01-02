//
//  AppRadius.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Radius

/// Consistent corner radius values for the app
/// Use these for rounded corners on buttons, cards, and containers
enum AppRadius {
    
    // MARK: - Radius Scale
    
    /// No radius (0pt)
    static let none: CGFloat = 0
    
    /// Extra small radius (4pt)
    static let xSmall: CGFloat = 4
    
    /// Small radius (8pt)
    static let small: CGFloat = 8
    
    /// Medium radius (12pt) - Most common
    static let medium: CGFloat = 12
    
    /// Large radius (16pt)
    static let large: CGFloat = 16
    
    /// Extra large radius (20pt)
    static let xLarge: CGFloat = 20
    
    /// Extra extra large radius (24pt)
    static let xxLarge: CGFloat = 24
    
    /// Pill/capsule radius (9999pt)
    static let pill: CGFloat = 9999
    
    // MARK: - Semantic Radius
    
    /// Button corner radius
    static let button: CGFloat = medium
    
    /// Card corner radius
    static let card: CGFloat = medium
    
    /// Input field corner radius
    static let input: CGFloat = small
    
    /// Modal/sheet corner radius
    static let modal: CGFloat = large
    
    /// Badge corner radius
    static let badge: CGFloat = pill
}

// MARK: - View Extensions

extension View {
    
    /// Apply app-standard corner radius
    /// - Parameter radius: Radius value from AppRadius
    /// - Returns: Modified view
    func appCornerRadius(_ radius: CGFloat = AppRadius.medium) -> some View {
        self.cornerRadius(radius)
    }
    
    /// Apply button corner radius
    func buttonCornerRadius() -> some View {
        self.cornerRadius(AppRadius.button)
    }
    
    /// Apply card corner radius
    func cardCornerRadius() -> some View {
        self.cornerRadius(AppRadius.card)
    }
    
    /// Apply pill/capsule shape
    func pillShape() -> some View {
        self.cornerRadius(AppRadius.pill)
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Basic corner radius:
 
 ```swift
 Rectangle()
     .fill(.appPrimary)
     .appCornerRadius()  // Uses medium radius
 
 Rectangle()
     .fill(.appSecondary)
     .appCornerRadius(AppRadius.large)
 ```
 
 2. Button styling:
 
 ```swift
 Button("Primary Action") { }
     .padding()
     .background(Color.appPrimary)
     .foregroundColor(.white)
     .buttonCornerRadius()
 
 Button("Pill Button") { }
     .padding(.horizontal, AppSpacing.large)
     .padding(.vertical, AppSpacing.small)
     .background(Color.appAccent)
     .foregroundColor(.white)
     .pillShape()
 ```
 
 3. Card styling:
 
 ```swift
 VStack {
     Text("Card Content")
 }
 .cardPadding()
 .background(Color.appSecondaryBackground)
 .cardCornerRadius()
 ```
 
 4. Specific corners:
 
 ```swift
 // Round only top corners
 Rectangle()
     .fill(.appBackground)
     .cornerRadius(AppRadius.large, corners: [.topLeft, .topRight])
 
 // Round only bottom corners
 Rectangle()
     .fill(.appBackground)
     .cornerRadius(AppRadius.large, corners: [.bottomLeft, .bottomRight])
 ```
 
 5. Input fields:
 
 ```swift
 TextField("Email", text: $email)
     .padding()
     .background(Color.appSecondaryBackground)
     .cornerRadius(AppRadius.input)
 ```
 
 6. Badges:
 
 ```swift
 Text("New")
     .font(Font.appCaption)
     .padding(.horizontal, AppSpacing.small)
     .padding(.vertical, AppSpacing.xxSmall)
     .background(Color.appPrimary)
     .foregroundColor(.white)
     .cornerRadius(AppRadius.badge)
 ```
 
 7. Modal/sheet:
 
 ```swift
 VStack {
     // Modal content
 }
 .padding()
 .background(Color.appBackground)
 .cornerRadius(AppRadius.modal, corners: [.topLeft, .topRight])
 ```
 
 8. Mixed radius:
 
 ```swift
 VStack(spacing: 0) {
     // Header with top corners rounded
     HeaderView()
         .background(Color.appPrimary)
         .cornerRadius(AppRadius.medium, corners: [.topLeft, .topRight])
     
     // Content with no radius
     ContentView()
         .background(Color.appBackground)
     
     // Footer with bottom corners rounded
     FooterView()
         .background(Color.appSecondaryBackground)
         .cornerRadius(AppRadius.medium, corners: [.bottomLeft, .bottomRight])
 }
 ```
 
 */

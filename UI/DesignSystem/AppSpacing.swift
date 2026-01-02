//
//  AppSpacing.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Spacing

/// Consistent spacing values for the app
/// Use these instead of magic numbers for padding, margins, and gaps
enum AppSpacing {
    
    // MARK: - Spacing Scale
    
    /// Extra extra extra small spacing (2pt)
    static let xxxSmall: CGFloat = 2
    
    /// Extra extra small spacing (4pt)
    static let xxSmall: CGFloat = 4
    
    /// Extra small spacing (8pt)
    static let xSmall: CGFloat = 8
    
    /// Small spacing (12pt)
    static let small: CGFloat = 12
    
    /// Medium spacing (16pt) - Most common
    static let medium: CGFloat = 16
    
    /// Large spacing (24pt)
    static let large: CGFloat = 24
    
    /// Extra large spacing (32pt)
    static let xLarge: CGFloat = 32
    
    /// Extra extra large spacing (48pt)
    static let xxLarge: CGFloat = 48
    
    /// Extra extra extra large spacing (64pt)
    static let xxxLarge: CGFloat = 64
    
    // MARK: - Semantic Spacing
    
    /// Standard padding for content
    static let contentPadding: CGFloat = medium
    
    /// Padding for cards and containers
    static let cardPadding: CGFloat = medium
    
    /// Spacing between sections
    static let sectionSpacing: CGFloat = large
    
    /// Spacing between list items
    static let listItemSpacing: CGFloat = small
    
    /// Spacing between form fields
    static let formFieldSpacing: CGFloat = medium
    
    /// Edge insets for screen content
    static let screenEdgeInsets = EdgeInsets(
        top: medium,
        leading: medium,
        bottom: medium,
        trailing: medium
    )
    
    /// Safe area insets (for custom layouts)
    static let safeAreaPadding: CGFloat = medium
}

// MARK: - View Extensions

extension View {
    
    /// Apply standard content padding
    func contentPadding() -> some View {
        self.padding(AppSpacing.contentPadding)
    }
    
    /// Apply card padding
    func cardPadding() -> some View {
        self.padding(AppSpacing.cardPadding)
    }
    
    /// Apply horizontal content padding
    func horizontalContentPadding() -> some View {
        self.padding(.horizontal, AppSpacing.contentPadding)
    }
    
    /// Apply vertical content padding
    func verticalContentPadding() -> some View {
        self.padding(.vertical, AppSpacing.contentPadding)
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Basic spacing:
 
 ```swift
 VStack(spacing: AppSpacing.medium) {
     Text("Item 1")
     Text("Item 2")
     Text("Item 3")
 }
 .padding(AppSpacing.contentPadding)
 ```
 
 2. Card layout:
 
 ```swift
 VStack(alignment: .leading, spacing: AppSpacing.small) {
     Text("Title")
         .font(Font.appHeadline)
     Text("Description")
         .font(Font.appBody)
 }
 .cardPadding()
 .background(Color.appSecondaryBackground)
 .cornerRadius(AppRadius.medium)
 ```
 
 3. Form layout:
 
 ```swift
 VStack(spacing: AppSpacing.formFieldSpacing) {
     TextField("Email", text: $email)
     SecureField("Password", text: $password)
     Button("Login") { }
 }
 .contentPadding()
 ```
 
 4. Section spacing:
 
 ```swift
 VStack(spacing: AppSpacing.sectionSpacing) {
     // Section 1
     VStack(spacing: AppSpacing.small) {
         Text("Section 1")
         Text("Content")
     }
     
     Divider()
     
     // Section 2
     VStack(spacing: AppSpacing.small) {
         Text("Section 2")
         Text("Content")
     }
 }
 ```
 
 5. List items:
 
 ```swift
 VStack(spacing: AppSpacing.listItemSpacing) {
     ForEach(items) { item in
         ItemRow(item: item)
     }
 }
 ```
 
 6. Screen layout:
 
 ```swift
 ScrollView {
     VStack(spacing: AppSpacing.large) {
         HeaderView()
         ContentView()
         FooterView()
     }
     .padding(AppSpacing.screenEdgeInsets)
 }
 ```
 
 7. Responsive spacing:
 
 ```swift
 @Environment(\.horizontalSizeClass) var sizeClass
 
 var spacing: CGFloat {
     sizeClass == .compact ? AppSpacing.medium : AppSpacing.large
 }
 
 VStack(spacing: spacing) {
     // Content
 }
 ```
 
 */

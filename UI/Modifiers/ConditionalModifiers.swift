//
//  ConditionalModifiers.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Conditional Modifiers

extension View {
    /// Apply modifier conditionally
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - transform: Modifier to apply if condition is true
    /// - Returns: Modified view
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply modifier conditionally with optional value
    /// - Parameters:
    ///   - value: Optional value
    ///   - transform: Modifier to apply if value is not nil
    /// - Returns: Modified view
    @ViewBuilder
    func ifLet<Value, Content: View>(
        _ value: Value?,
        transform: (Self, Value) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    /// Apply one of two modifiers based on condition
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - trueTransform: Modifier if condition is true
    ///   - falseTransform: Modifier if condition is false
    /// - Returns: Modified view
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if trueTransform: (Self) -> TrueContent,
        else falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 // Simple conditional
 Text("Hello")
     .if(isPremium) { view in
         view.foregroundColor(.gold)
     }
 
 // With optional
 Text("User")
     .ifLet(userName) { view, name in
         view.navigationTitle(name)
     }
 
 // If-else
 Rectangle()
     .if(isSelected,
         if: { $0.fill(Color.blue) },
         else: { $0.fill(Color.gray) }
     )
 
 // Multiple conditions
 VStack {
     Text("Content")
 }
 .if(showBorder) { $0.border(Color.gray) }
 .if(addPadding) { $0.padding() }
 .if(isCard) { $0.background(Color.white).cornerRadius(10) }
 
 // Platform-specific
 Text("Hello")
     .if(UIDevice.current.userInterfaceIdiom == .pad) { view in
         view.font(.largeTitle)
     }
 ```
 
 */

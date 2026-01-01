//
//  LoadingModifier.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Loading Modifier

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    let message: String?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.medium) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    if let message = message {
                        Text(message)
                            .font(.appBody)
                            .foregroundColor(.white)
                    }
                }
                .padding(AppSpacing.large)
                .background(.appSecondaryBackground)
                .cornerRadius(AppRadius.medium)
                .shadow(radius: 10)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

// MARK: - View Extension

extension View {
    /// Show loading overlay
    /// - Parameters:
    ///   - isLoading: Whether to show loading
    ///   - message: Optional loading message
    /// - Returns: Modified view
    func loading(_ isLoading: Bool, message: String? = nil) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading, message: message))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 struct ContentView: View {
     @State private var isLoading = false
     
     var body: some View {
         VStack {
             Button("Load Data") {
                 loadData()
             }
         }
         .loading(isLoading)
     }
     
     func loadData() {
         isLoading = true
         Task {
             try? await Task.sleep(nanoseconds: 2_000_000_000)
             isLoading = false
         }
     }
 }
 
 // With message
 .loading(isLoading, message: "Loading...")
 .loading(isSaving, message: "Saving changes...")
 ```
 
 */

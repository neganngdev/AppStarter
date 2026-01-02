//
//  LoadingView.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Loading View

/// Reusable loading indicator component
struct LoadingView: View {
    
    let text: String?
    let style: LoadingStyle
    
    init(text: String? = nil, style: LoadingStyle = .medium) {
        self.text = text
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.appPrimary))
                .scaleEffect(style.scale)
            
            if let text = text {
                Text(text)
                    .font(style.font)
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Loading Style

extension LoadingView {
    enum LoadingStyle {
        case small
        case medium
        case large
        
        var scale: CGFloat {
            switch self {
            case .small:
                return 0.8
            case .medium:
                return 1.0
            case .large:
                return 1.5
            }
        }
        
        var font: Font {
            switch self {
            case .small:
                return Font.appCaption
            case .medium:
                return Font.appBody
            case .large:
                return Font.appHeadline
            }
        }
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    let text: String?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                Color.appOverlay
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.medium) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                    
                    if let text = text {
                        Text(text)
                            .font(Font.appBody)
                            .foregroundColor(.white)
                    }
                }
                .padding(AppSpacing.large)
                .background(Color.appSecondaryBackground)
                .cornerRadius(AppRadius.medium)
                .appShadow(.large)
            }
        }
    }
}

extension View {
    /// Show loading overlay
    /// - Parameters:
    ///   - isLoading: Whether to show loading
    ///   - text: Optional loading text
    /// - Returns: Modified view
    func loadingOverlay(isLoading: Bool, text: String? = nil) -> some View {
        self.modifier(LoadingOverlay(isLoading: isLoading, text: text))
    }
}

// MARK: - Inline Loading

struct InlineLoadingView: View {
    let text: String?
    
    init(_ text: String? = "Loading...") {
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.appPrimary))
            
            if let text = text {
                Text(text)
                    .font(Font.appBody)
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .padding()
    }
}

// MARK: - Previews

#Preview("Loading View") {
    VStack(spacing: AppSpacing.xxLarge) {
        LoadingView(text: "Loading...", style: .small)
        LoadingView(text: "Loading...", style: .medium)
        LoadingView(text: "Loading...", style: .large)
    }
}

#Preview("Loading Overlay") {
    VStack {
        Text("Content")
            .font(Font.appTitle)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.appBackground)
    .loadingOverlay(isLoading: true, text: "Please wait...")
}

#Preview("Inline Loading") {
    VStack(spacing: AppSpacing.large) {
        InlineLoadingView()
        InlineLoadingView("Fetching data...")
    }
    .padding()
}

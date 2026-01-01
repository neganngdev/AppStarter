//
//  AppState.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - App State

/// Represents the current state of the app
enum AppState: Equatable {
    /// Loading initial state
    case loading
    
    /// Showing onboarding flow
    case onboarding
    
    /// Showing paywall
    case paywall
    
    /// Main app content
    case main
    
    /// Requesting permissions (notifications, etc.)
    case permissions
}

// MARK: - App State Extensions

extension AppState {
    
    /// User-friendly description
    var description: String {
        switch self {
        case .loading:
            return "Loading"
        case .onboarding:
            return "Onboarding"
        case .paywall:
            return "Paywall"
        case .main:
            return "Main App"
        case .permissions:
            return "Permissions"
        }
    }
    
    /// Whether state requires user interaction
    var requiresUserAction: Bool {
        switch self {
        case .loading, .main:
            return false
        case .onboarding, .paywall, .permissions:
            return true
        }
    }
}

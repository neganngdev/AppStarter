//
//  OnboardingCoordinator.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Onboarding Coordinator

/// Manages onboarding flow and state
@MainActor
class OnboardingCoordinator: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = OnboardingCoordinator()
    
    // MARK: - Published Properties
    
    /// Whether user should see onboarding
    @Published var shouldShowOnboarding: Bool
    
    // MARK: - Properties
    
    /// Onboarding pages to display
    var pages: [OnboardingPage]
    
    // MARK: - Initialization
    
    private init() {
        // Check if user has seen onboarding
        self.shouldShowOnboarding = !AppStorage.hasSeenOnboarding
        
        // CUSTOMIZE: Set your onboarding pages
        self.pages = OnboardingPage.samplePages
    }
    
    // MARK: - Public Methods
    
    /// Mark onboarding as completed
    func completeOnboarding() {
        AppStorage.hasSeenOnboarding = true
        AppStorage.onboardingVersion = AppConfig.version
        shouldShowOnboarding = false
        
        // Track completion
        Task {
            await AnalyticsManager.shared.trackOnboardingCompleted()
        }
    }
    
    /// Reset onboarding (for testing or re-showing)
    func resetOnboarding() {
        AppStorage.hasSeenOnboarding = false
        shouldShowOnboarding = true
    }
    
    /// Check if onboarding should be shown
    /// - Returns: true if onboarding should be displayed
    func shouldShow() -> Bool {
        // Show if user hasn't seen it
        if !AppStorage.hasSeenOnboarding {
            return true
        }
        
        // CUSTOMIZE: Add logic to re-show onboarding for major updates
        // Example: Show if app version changed
        /*
        if AppStorage.onboardingVersion != AppConfig.version {
            return true
        }
        */
        
        return false
    }
    
    /// Configure custom pages
    /// - Parameter pages: Custom onboarding pages
    func configure(pages: [OnboardingPage]) {
        self.pages = pages
    }
}

// MARK: - Onboarding Container

/// Container view that shows onboarding or main content
struct OnboardingContainer<Content: View>: View {
    
    @StateObject private var coordinator = OnboardingCoordinator.shared
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Group {
            if coordinator.shouldShowOnboarding {
                OnboardingView(
                    pages: coordinator.pages,
                    onComplete: {
                        coordinator.completeOnboarding()
                    }
                )
                .transition(.opacity)
            } else {
                content
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: coordinator.shouldShowOnboarding)
    }
}

// MARK: - View Extension

extension View {
    /// Wrap view with onboarding flow
    /// - Returns: View with onboarding
    func withOnboarding() -> some View {
        OnboardingContainer {
            self
        }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Basic usage in App:
 
 ```swift
 @main
 struct MyApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
                 .withOnboarding()
         }
     }
 }
 ```
 
 2. Manual control:
 
 ```swift
 struct ContentView: View {
     @StateObject private var coordinator = OnboardingCoordinator.shared
     
     var body: some View {
         if coordinator.shouldShowOnboarding {
             OnboardingView(
                 pages: coordinator.pages,
                 onComplete: {
                     coordinator.completeOnboarding()
                 }
             )
         } else {
             MainView()
         }
     }
 }
 ```
 
 3. Custom pages:
 
 ```swift
 // In app initialization
 OnboardingCoordinator.shared.configure(pages: [
     OnboardingPage(
         icon: "star.fill",
         title: "Welcome",
         description: "Welcome to MyApp"
     ),
     OnboardingPage(
         icon: "heart.fill",
         title: "Features",
         description: "Discover amazing features"
     )
 ])
 ```
 
 4. Reset onboarding (for testing):
 
 ```swift
 Button("Reset Onboarding") {
     OnboardingCoordinator.shared.resetOnboarding()
 }
 ```
 
 5. Check if should show:
 
 ```swift
 if OnboardingCoordinator.shared.shouldShow() {
     // Show onboarding
 }
 ```
 
 6. Version-based re-showing:
 
 In OnboardingCoordinator.shouldShow():
 ```swift
 // Show onboarding for major version updates
 let currentVersion = AppConfig.version
 let lastVersion = AppStorage.onboardingVersion
 
 if currentVersion.split(separator: ".").first != lastVersion.split(separator: ".").first {
     return true
 }
 ```
 
 */

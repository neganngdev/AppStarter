//
//  AppCoordinator.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Coordinator

/// Manages overall app navigation flow and state
@MainActor
class AppCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current app state
    @Published private(set) var currentState: AppState = .loading
    
    /// Whether to show settings
    @Published var showSettings = false
    
    /// Whether to show paywall
    @Published var showPaywall = false
    
    // MARK: - Private Properties
    
    private let purchaseManager = PurchaseManager.shared
    private let onboardingCoordinator = OnboardingCoordinator.shared
    private let deepLinkHandler = DeepLinkHandler.shared
    
    // MARK: - Initialization
    
    init() {
        determineInitialState()
    }
    
    // MARK: - Root View
    
    /// Main view based on current state
    var rootView: some View {
        Group {
            switch currentState {
            case .loading:
                LoadingView(text: "Loading...")
                
            case .onboarding:
                OnboardingView(
                    pages: onboardingCoordinator.pages,
                    onComplete: {
                        self.completeOnboarding()
                    }
                )
                
            case .paywall:
                PaywallView(
                    plans: SubscriptionPlan.samplePlans,
                    onPurchase: { planID in
                        try await self.handlePurchase(planID: planID)
                    },
                    onRestore: {
                        try await self.handleRestore()
                    },
                    onDismiss: {
                        self.dismissPaywall()
                    }
                )
                
            case .main:
                MainAppView()
                    .sheet(isPresented: $showSettings) {
                        SettingsView()
                    }
                    .sheet(isPresented: $showPaywall) {
                        PaywallView(
                            plans: SubscriptionPlan.samplePlans,
                            onPurchase: { planID in
                                try await self.handlePurchase(planID: planID)
                            },
                            onRestore: {
                                try await self.handleRestore()
                            },
                            onDismiss: {
                                self.showPaywall = false
                            }
                        )
                    }
                
            case .permissions:
                PermissionsView {
                    self.completePermissions()
                }
            }
        }
        .animation(.easeInOut, value: currentState)
    }
    
    // MARK: - State Management
    
    /// Determine initial app state
    private func determineInitialState() {
        Task {
            // Small delay for splash screen effect
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Check onboarding
            if onboardingCoordinator.shouldShow() {
                currentState = .onboarding
                return
            }
            
            // Check subscription status
            let status = await purchaseManager.checkSubscriptionStatus()
            
            // CUSTOMIZE: Decide if paywall is required
            // For now, go straight to main app
            // Uncomment to require subscription:
            /*
            if !status.isActive && AppConfig.requiresSubscription {
                currentState = .paywall
                return
            }
            */
            
            // Go to main app
            currentState = .main
        }
    }
    
    /// Complete onboarding
    private func completeOnboarding() {
        onboardingCoordinator.completeOnboarding()
        
        // CUSTOMIZE: Add permission request or go to paywall/main
        // currentState = .permissions
        // currentState = .paywall
        currentState = .main
    }
    
    /// Complete permissions
    private func completePermissions() {
        // CUSTOMIZE: Decide next step after permissions
        currentState = .main
    }
    
    /// Dismiss paywall
    private func dismissPaywall() {
        if currentState == .paywall {
            // User dismissed paywall without purchasing
            // CUSTOMIZE: Decide what to do
            // Option 1: Go to main app (freemium model)
            currentState = .main
            
            // Option 2: Exit app (subscription required)
            // exit(0)
        } else {
            showPaywall = false
        }
    }
    
    // MARK: - Purchase Handling
    
    /// Handle purchase
    private func handlePurchase(planID: String) async throws {
        let result = try await purchaseManager.purchase(productID: planID)
        
        if result.isSuccess {
            // Purchase successful
            if currentState == .paywall {
                currentState = .main
            } else {
                showPaywall = false
            }
        }
    }
    
    /// Handle restore purchases
    private func handleRestore() async throws {
        try await purchaseManager.restorePurchases()
        
        // Check if subscription is now active
        let status = await purchaseManager.checkSubscriptionStatus()
        if status.isActive {
            if currentState == .paywall {
                currentState = .main
            } else {
                showPaywall = false
            }
        }
    }
    
    // MARK: - Navigation
    
    /// Show paywall
    func showPaywall() {
        if currentState == .main {
            showPaywall = true
        } else {
            currentState = .paywall
        }
    }
    
    /// Navigate to settings
    func navigateToSettings() {
        if currentState == .main {
            showSettings = true
        }
    }
    
    /// Navigate to specific feature
    func navigateToFeature(id: String) {
        // CUSTOMIZE: Implement feature navigation
        print("Navigate to feature: \(id)")
    }
    
    // MARK: - Deep Link Handling
    
    /// Handle deep link
    func handle(deepLink url: URL) {
        deepLinkHandler.handle(url, coordinator: self)
    }
}

// MARK: - Main App View

/// Placeholder main app view
/// CUSTOMIZE: Replace with your actual main app content
struct MainAppView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

// MARK: - Home View

/// Placeholder home view
/// CUSTOMIZE: Replace with your actual home screen
struct HomeView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppSpacing.large) {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.appPrimary, .appAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Welcome to AppStarter!")
                    .font(.appLargeTitle)
                    .fontWeight(.bold)
                
                Text("Your app is ready to customize")
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
                
                AppButton("Go Premium", style: .primary, size: .large) {
                    coordinator.showPaywall()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Home")
        }
    }
}

// MARK: - Permissions View

/// Placeholder permissions view
/// CUSTOMIZE: Add actual permission requests
struct PermissionsView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.xLarge) {
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 80))
                .foregroundColor(.appPrimary)
            
            Text("Enable Notifications")
                .font(.appTitle)
                .fontWeight(.bold)
            
            Text("Stay updated with important information")
                .font(.appBody)
                .foregroundColor(.appSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            AppButton("Enable Notifications", style: .primary, size: .large) {
                // Request notification permission
                requestNotificationPermission()
                onComplete()
            }
            .padding(.horizontal)
            
            Button("Skip") {
                onComplete()
            }
            .font(.appBody)
            .foregroundColor(.appSecondaryText)
            .padding(.bottom, AppSpacing.xLarge)
        }
    }
    
    private func requestNotificationPermission() {
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            Task {
                await AnalyticsManager.shared.trackEvent("notification_permission", parameters: [
                    "granted": granted
                ])
            }
        }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE IN APP:
 
 ```swift
 @main
 struct AppStarterApp: App {
     @StateObject private var coordinator = AppCoordinator()
     
     var body: some Scene {
         WindowGroup {
             coordinator.rootView
                 .onOpenURL { url in
                     coordinator.handle(deepLink: url)
                 }
         }
     }
 }
 ```
 
 CUSTOMIZATION POINTS:
 
 1. Initial State Logic:
    - Modify `determineInitialState()` to add custom checks
    - Add permission screens, login screens, etc.
 
 2. Paywall Requirement:
    - Uncomment subscription check in `determineInitialState()`
    - Set `AppConfig.requiresSubscription = true`
 
 3. Navigation Flow:
    - Modify `completeOnboarding()` to add permission screens
    - Add custom states to `AppState` enum
 
 4. Main App Content:
    - Replace `MainAppView` with your actual app
    - Customize `HomeView` with your home screen
 
 5. Deep Links:
    - Add custom deep link handling in `DeepLinkHandler`
    - Implement feature navigation in `navigateToFeature()`
 
 */

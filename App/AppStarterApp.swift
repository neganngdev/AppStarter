//
//  AppStarterApp.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

/// Main application entry point
/// This is where the app lifecycle begins
@main
struct AppStarterApp: App {
    
    // MARK: - State
    
    /// App state observer for lifecycle events
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Initialization
    
    init() {
        setupApp()
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    handleAppLaunch()
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(from: oldPhase, to: newPhase)
        }
    }
    
    // MARK: - Setup
    
    /// Initial app setup
    /// Called once when the app is initialized
    private func setupApp() {
        // Print environment info
        Environment.printInfo()
        
        // Validate configuration
        AppConfig.validate()
        
        // CUSTOMIZE: Add your initialization code here
        
        // Setup analytics (if enabled)
        if AppConfig.hasAnalytics && Environment.current.isAnalyticsEnabled {
            setupAnalytics()
        }
        
        // Setup crash reporting (if enabled)
        if AppConfig.hasCrashReporting && Environment.current.isCrashReportingEnabled {
            setupCrashReporting()
        }
        
        // Setup monetization (if enabled)
        if AppConfig.hasSubscription {
            setupMonetization()
        }
        
        // Configure appearance
        configureAppearance()
        
        logInfo("App initialized successfully")
    }
    
    // MARK: - Lifecycle Handlers
    
    /// Handle app launch
    private func handleAppLaunch() {
        logInfo("App launched")
        
        // CUSTOMIZE: Add launch-specific logic here
        // Examples:
        // - Check for app updates
        // - Sync data
        // - Request permissions
        // - Show onboarding if first launch
    }
    
    /// Handle scene phase changes
    private func handleScenePhaseChange(from oldPhase: ScenePhase, to newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            handleAppBecameActive()
        case .inactive:
            handleAppBecameInactive()
        case .background:
            handleAppEnteredBackground()
        @unknown default:
            break
        }
    }
    
    /// Called when app becomes active
    private func handleAppBecameActive() {
        logInfo("App became active")
        
        // CUSTOMIZE: Add logic for when app becomes active
        // Examples:
        // - Refresh data
        // - Resume timers
        // - Check subscription status
    }
    
    /// Called when app becomes inactive
    private func handleAppBecameInactive() {
        logInfo("App became inactive")
        
        // CUSTOMIZE: Add logic for when app becomes inactive
        // Examples:
        // - Pause ongoing tasks
        // - Save state
    }
    
    /// Called when app enters background
    private func handleAppEnteredBackground() {
        logInfo("App entered background")
        
        // CUSTOMIZE: Add logic for when app enters background
        // Examples:
        // - Save data
        // - Cancel network requests
        // - Schedule background tasks
    }
    
    // MARK: - Service Setup
    
    /// Setup analytics service
    private func setupAnalytics() {
        // TODO: Initialize your analytics service
        // Example: Analytics.configure(apiKey: AppConfig.analyticsAPIKey)
        
        logInfo("Analytics configured")
    }
    
    /// Setup crash reporting service
    private func setupCrashReporting() {
        // TODO: Initialize your crash reporting service
        // Example: Crashlytics.configure(apiKey: AppConfig.crashReportingAPIKey)
        
        logInfo("Crash reporting configured")
    }
    
    /// Setup monetization/subscription service
    private func setupMonetization() {
        // TODO: Initialize RevenueCat or your monetization service
        // Example:
        // Purchases.configure(withAPIKey: AppConfig.revenueCatAPIKey)
        // Purchases.logLevel = Environment.current.isLoggingEnabled ? .debug : .error
        
        logInfo("Monetization configured")
    }
    
    /// Configure app appearance
    private func configureAppearance() {
        // CUSTOMIZE: Configure global appearance settings
        
        // Example: Set tint color
        UIView.appearance().tintColor = UIColor(AppConfig.primaryColor)
        
        // Example: Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Example: Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        logInfo("Appearance configured")
    }
    
    // MARK: - Logging
    
    /// Log info message
    private func logInfo(_ message: String) {
        if Environment.current.isLoggingEnabled {
            print("ℹ️ [AppStarterApp] \(message)")
        }
    }
}

// MARK: - Content View

/// Root content view
/// CUSTOMIZE: Replace this with your app's main view
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppConfig.primaryColor)
                
                Text("Welcome to \(AppConfig.appDisplayName)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your app starter template is ready!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: 40)
                
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(title: "Environment", value: Environment.current.name)
                    InfoRow(title: "Version", value: AppConfig.fullVersionString)
                    InfoRow(title: "Bundle ID", value: AppConfig.bundleID)
                }
                .padding()
                .background(AppConfig.secondaryBackgroundColor)
                .cornerRadius(12)
                
                Spacer()
                
                Text("Start building your app in the Features/ directory")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle(AppConfig.appDisplayName)
        }
    }
}

// MARK: - Info Row

/// Simple info row component
private struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

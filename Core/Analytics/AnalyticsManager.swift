//
//  AnalyticsManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Analytics Manager

/// Thread-safe analytics manager that supports multiple providers
/// Handles event tracking, screen views, and user properties across all registered providers
actor AnalyticsManager {
    
    // MARK: - Singleton
    
    static let shared = AnalyticsManager()
    
    // MARK: - Properties
    
    private var providers: [AnalyticsProvider] = []
    private var isEnabled: Bool
    private var eventQueue: [AnalyticsEvent] = []
    private let maxQueueSize = 100
    
    // MARK: - Initialization
    
    private init() {
        // Check if analytics is enabled from storage
        self.isEnabled = AppStorage.analyticsEnabled
        
        // Auto-register console provider in debug mode
        #if DEBUG
        if Environment.current.isLoggingEnabled {
            providers.append(ConsoleAnalyticsProvider())
        }
        #endif
    }
    
    // MARK: - Provider Management
    
    /// Register an analytics provider
    /// - Parameter provider: Provider to register
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.register(FirebaseAnalyticsProvider())
    /// await AnalyticsManager.shared.register(MixpanelAnalyticsProvider())
    /// ```
    func register(_ provider: AnalyticsProvider) {
        // Don't register duplicate providers
        if !providers.contains(where: { $0.name == provider.name }) {
            providers.append(provider)
            print("✅ Registered analytics provider: \(provider.name)")
        }
    }
    
    /// Unregister an analytics provider
    /// - Parameter providerName: Name of provider to remove
    func unregister(_ providerName: String) {
        providers.removeAll { $0.name == providerName }
        print("❌ Unregistered analytics provider: \(providerName)")
    }
    
    /// Get list of registered provider names
    /// - Returns: Array of provider names
    func registeredProviders() -> [String] {
        providers.map { $0.name }
    }
    
    // MARK: - Enable/Disable
    
    /// Enable analytics tracking
    /// Processes queued events when enabled
    func enable() {
        isEnabled = true
        AppStorage.analyticsEnabled = true
        print("✅ Analytics enabled")
        
        // Process queued events
        if !eventQueue.isEmpty {
            print("📤 Processing \(eventQueue.count) queued events")
            for event in eventQueue {
                trackEventInternal(event.name, parameters: event.parameters)
            }
            eventQueue.removeAll()
        }
    }
    
    /// Disable analytics tracking
    /// Events will be queued when disabled
    func disable() {
        isEnabled = false
        AppStorage.analyticsEnabled = false
        print("❌ Analytics disabled")
    }
    
    /// Check if analytics is enabled
    /// - Returns: true if enabled
    func isAnalyticsEnabled() -> Bool {
        isEnabled
    }
    
    // MARK: - Event Tracking
    
    /// Track an analytics event
    /// - Parameters:
    ///   - name: Event name
    ///   - parameters: Event parameters
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.trackEvent("button_tapped", parameters: ["button": "purchase"])
    /// ```
    func trackEvent(_ name: String, parameters: [String: Any]? = nil) {
        if isEnabled {
            trackEventInternal(name, parameters: parameters)
        } else {
            queueEvent(AnalyticsEvent(name: name, parameters: parameters))
        }
    }
    
    /// Track a typed analytics event
    /// - Parameter event: AnalyticsEvent instance
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.track(.appOpened())
    /// await AnalyticsManager.shared.track(.screenViewed("HomeScreen"))
    /// ```
    func track(_ event: AnalyticsEvent) {
        trackEvent(event.name, parameters: event.parameters)
    }
    
    /// Internal event tracking (bypasses enabled check)
    private func trackEventInternal(_ name: String, parameters: [String: Any]?) {
        for provider in providers {
            provider.trackEvent(name, parameters: parameters)
        }
    }
    
    // MARK: - Screen Tracking
    
    /// Track screen view
    /// - Parameter screenName: Name of the screen
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.trackScreen("HomeScreen")
    /// ```
    func trackScreen(_ screenName: String) {
        guard isEnabled else { return }
        
        for provider in providers {
            provider.trackScreen(screenName)
        }
    }
    
    // MARK: - User Properties
    
    /// Set user property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Property value
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.setUserProperty("subscription_status", value: "premium")
    /// await AnalyticsManager.shared.setUserProperty("age_group", value: "25-34")
    /// ```
    func setUserProperty(_ name: String, value: Any?) {
        guard isEnabled else { return }
        
        for provider in providers {
            provider.setUserProperty(name, value: value)
        }
    }
    
    /// Set user ID
    /// - Parameter userID: User identifier
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.setUserID("user_123")
    /// ```
    func setUserID(_ userID: String?) {
        guard isEnabled else { return }
        
        for provider in providers {
            provider.setUserID(userID)
        }
    }
    
    /// Reset all user data (for logout)
    ///
    /// Example:
    /// ```swift
    /// await AnalyticsManager.shared.reset()
    /// ```
    func reset() {
        for provider in providers {
            provider.reset()
        }
        eventQueue.removeAll()
        print("🔄 Analytics reset - all user data cleared")
    }
    
    // MARK: - Event Queue
    
    /// Queue event when analytics is disabled
    private func queueEvent(_ event: AnalyticsEvent) {
        // Limit queue size to prevent memory issues
        if eventQueue.count >= maxQueueSize {
            eventQueue.removeFirst()
        }
        eventQueue.append(event)
    }
    
    /// Get queued event count
    /// - Returns: Number of queued events
    func queuedEventCount() -> Int {
        eventQueue.count
    }
    
    /// Clear event queue
    func clearQueue() {
        eventQueue.removeAll()
        print("🗑️ Analytics queue cleared")
    }
}

// MARK: - Convenience Methods

extension AnalyticsManager {
    
    /// Track app lifecycle events
    func trackAppOpened() {
        track(.appOpened())
    }
    
    func trackAppBackgrounded() {
        track(.appBackgrounded())
    }
    
    /// Track user authentication
    func trackLogin(method: String) {
        track(.login(method: method))
    }
    
    func trackSignup(method: String) {
        track(.signup(method: method))
    }
    
    func trackLogout() {
        track(.logout())
        reset()
    }
    
    /// Track onboarding
    func trackOnboardingStarted() {
        track(.onboardingStarted())
    }
    
    func trackOnboardingCompleted() {
        track(.onboardingCompleted())
    }
    
    /// Track purchases
    func trackPurchaseCompleted(productID: String, price: Double, currency: String = "USD") {
        track(.purchaseCompleted(productID: productID, price: price, currency: currency))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Setup (in app initialization):
 
 ```swift
 // Register providers
 Task {
     await AnalyticsManager.shared.register(ConsoleAnalyticsProvider())
     // await AnalyticsManager.shared.register(FirebaseAnalyticsProvider())
     // await AnalyticsManager.shared.register(MixpanelAnalyticsProvider())
 }
 ```
 
 2. Track events:
 
 ```swift
 Task {
     // Using predefined events
     await AnalyticsManager.shared.track(.appOpened())
     await AnalyticsManager.shared.track(.screenViewed("HomeScreen"))
     await AnalyticsManager.shared.track(.buttonTapped("purchase_button"))
     
     // Using convenience methods
     await AnalyticsManager.shared.trackAppOpened()
     await AnalyticsManager.shared.trackScreen("ProfileScreen")
     
     // Custom events
     await AnalyticsManager.shared.trackEvent("custom_event", parameters: [
         "key": "value",
         "count": 42
     ])
 }
 ```
 
 3. User properties:
 
 ```swift
 Task {
     await AnalyticsManager.shared.setUserID("user_123")
     await AnalyticsManager.shared.setUserProperty("subscription_status", value: "premium")
     await AnalyticsManager.shared.setUserProperty("age_group", value: "25-34")
 }
 ```
 
 4. GDPR compliance:
 
 ```swift
 Task {
     // Disable analytics (user opt-out)
     await AnalyticsManager.shared.disable()
     
     // Enable analytics (user opt-in)
     await AnalyticsManager.shared.enable()
     
     // Check status
     let isEnabled = await AnalyticsManager.shared.isAnalyticsEnabled()
 }
 ```
 
 5. Logout:
 
 ```swift
 Task {
     await AnalyticsManager.shared.trackLogout()
     // This also calls reset() to clear user data
 }
 ```
 
 6. In SwiftUI views:
 
 ```swift
 struct HomeView: View {
     var body: some View {
         VStack {
             Text("Home")
         }
         .onAppear {
             Task {
                 await AnalyticsManager.shared.trackScreen("HomeScreen")
             }
         }
     }
 }
 
 Button("Purchase") {
     Task {
         await AnalyticsManager.shared.track(.buttonTapped("purchase_button", screen: "Home"))
     }
 }
 ```
 
 */

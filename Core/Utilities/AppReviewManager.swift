//
//  AppReviewManager.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import StoreKit
import SwiftUI

// MARK: - App Review Manager

/// Manages app review requests
class AppReviewManager {
    
    // MARK: - Singleton
    
    static let shared = AppReviewManager()
    
    // MARK: - Storage Keys
    
    private enum Keys {
        static let launchCount = "app_launch_count"
        static let lastReviewRequestVersion = "last_review_request_version"
        static let significantActionCount = "significant_action_count"
    }
    
    // MARK: - Configuration
    
    /// Minimum launches before requesting review
    private let minimumLaunchCount = 10
    
    /// Minimum significant actions before requesting review
    private let minimumActionCount = 5
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Public Methods
    
    /// Track app launch
    func trackLaunch() {
        let count = AppStorage.launchCount + 1
        AppStorage.launchCount = count
        
        Logger.shared.debug("App launch count: \(count)")
    }
    
    /// Track significant action
    /// Call this when user completes important actions
    func trackSignificantAction() {
        let count = AppStorage.significantActionCount + 1
        AppStorage.significantActionCount = count
        
        Logger.shared.debug("Significant action count: \(count)")
        
        // Check if should request review
        checkAndRequestReview()
    }
    
    /// Request review if conditions are met
    func checkAndRequestReview() {
        guard shouldRequestReview() else { return }
        
        requestReview()
    }
    
    /// Force request review (use sparingly)
    func requestReview() {
        // Update last request version
        AppStorage.lastReviewRequestVersion = AppConfig.version
        
        // Request review
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
            
            Logger.shared.info("App review requested")
            
            // Track analytics
            Task {
                await AnalyticsManager.shared.trackEvent("app_review_requested")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func shouldRequestReview() -> Bool {
        // Don't request if already requested in this version
        if AppStorage.lastReviewRequestVersion == AppConfig.version {
            return false
        }
        
        // Check launch count
        let hasEnoughLaunches = AppStorage.launchCount >= minimumLaunchCount
        
        // Check action count
        let hasEnoughActions = AppStorage.significantActionCount >= minimumActionCount
        
        return hasEnoughLaunches && hasEnoughActions
    }
}

// MARK: - AppStorage Extension

extension AppStorage {
    static var launchCount: Int {
        get { UserDefaults.standard.integer(forKey: "app_launch_count") }
        set { UserDefaults.standard.set(newValue, forKey: "app_launch_count") }
    }
    
    static var lastReviewRequestVersion: String {
        get { UserDefaults.standard.string(forKey: "last_review_request_version") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "last_review_request_version") }
    }
    
    static var significantActionCount: Int {
        get { UserDefaults.standard.integer(forKey: "significant_action_count") }
        set { UserDefaults.standard.set(newValue, forKey: "significant_action_count") }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Track app launch (in App init or onAppear):
 
 ```swift
 @main
 struct AppStarterApp: App {
     init() {
         AppReviewManager.shared.trackLaunch()
     }
     
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 }
 ```
 
 2. Track significant actions:
 
 ```swift
 // After user completes important action
 Button("Save") {
     saveData()
     AppReviewManager.shared.trackSignificantAction()
 }
 
 // After successful purchase
 func completePurchase() {
     // Purchase logic
     AppReviewManager.shared.trackSignificantAction()
 }
 
 // After user creates content
 func createPost() {
     // Create post
     AppReviewManager.shared.trackSignificantAction()
 }
 ```
 
 3. Manual review request (e.g., in settings):
 
 ```swift
 Button("Rate App") {
     AppReviewManager.shared.requestReview()
 }
 ```
 
 4. Check and request at specific times:
 
 ```swift
 // After onboarding completion
 func completeOnboarding() {
     // Onboarding logic
     AppReviewManager.shared.checkAndRequestReview()
 }
 ```
 
 CUSTOMIZATION:
 
 Adjust thresholds in AppReviewManager:
 - minimumLaunchCount: Number of launches before requesting
 - minimumActionCount: Number of actions before requesting
 
 */

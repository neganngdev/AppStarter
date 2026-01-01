//
//  AppConfig.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

/// Centralized configuration for the app.
/// This file contains all the settings you need to customize when creating a new app from this template.
struct AppConfig {
    
    // MARK: - App Identity
    // CUSTOMIZE: Change these values for each new app
    
    /// Internal app name (used in code)
    static let appName = "AppStarter"
    
    /// Display name shown to users (app icon, launch screen)
    static let appDisplayName = "App Starter"
    
    /// Bundle identifier prefix (e.g., "com.yourcompany")
    /// CUSTOMIZE: Replace with your developer/company identifier
    static let bundleIDPrefix = "com.indiedev"
    
    /// Full bundle identifier
    static var bundleID: String {
        "\(bundleIDPrefix).\(appName.lowercased())"
    }
    
    /// App version (should match Info.plist)
    static let version = "1.0.0"
    
    /// Build number
    static let buildNumber = "1"
    
    // MARK: - Branding
    // CUSTOMIZE: Define your app's visual identity
    
    /// Primary brand color (main theme color)
    static let primaryColor = Color.blue
    
    /// Accent color (highlights, CTAs)
    static let accentColor = Color.purple
    
    /// Background color
    static let backgroundColor = Color(.systemBackground)
    
    /// Secondary background color
    static let secondaryBackgroundColor = Color(.secondarySystemBackground)
    
    /// Text color (primary)
    static let textColor = Color.primary
    
    /// Text color (secondary)
    static let secondaryTextColor = Color.secondary
    
    // MARK: - Typography
    // CUSTOMIZE: Define font styles
    
    /// App font family (nil uses system default)
    static let fontFamily: String? = nil
    
    /// Large title font size
    static let largeTitleSize: CGFloat = 34
    
    /// Title font size
    static let titleSize: CGFloat = 28
    
    /// Headline font size
    static let headlineSize: CGFloat = 17
    
    /// Body font size
    static let bodySize: CGFloat = 17
    
    /// Caption font size
    static let captionSize: CGFloat = 12
    
    // MARK: - Feature Flags
    // CUSTOMIZE: Enable/disable features for your app
    
    /// Show onboarding flow on first launch
    static let hasOnboarding = true
    
    /// Enable subscription/paywall features
    static let hasSubscription = true
    
    /// Enable analytics tracking
    static let hasAnalytics = true
    
    /// Enable crash reporting
    static let hasCrashReporting = true
    
    /// Enable remote notifications
    static let hasNotifications = false
    
    /// Enable dark mode support
    static let supportsDarkMode = true
    
    /// Enable iPad support
    static let supportsIPad = true
    
    // MARK: - External Services
    // CUSTOMIZE: Add your API keys and service identifiers
    
    /// RevenueCat API key for subscription management
    /// Get your key from: https://app.revenuecat.com/
    static let revenueCatAPIKey = "YOUR_REVENUECAT_KEY_HERE"
    
    /// Analytics service API key (e.g., Mixpanel, Amplitude)
    static let analyticsAPIKey = "YOUR_ANALYTICS_KEY_HERE"
    
    /// Crash reporting service key (e.g., Crashlytics, Sentry)
    static let crashReportingAPIKey = "YOUR_CRASH_REPORTING_KEY_HERE"
    
    // MARK: - App Behavior
    // CUSTOMIZE: Configure app behavior
    
    /// Minimum iOS version required
    static let minimumIOSVersion = "16.0"
    
    /// Show debug information in UI
    static let showDebugInfo = Environment.current == .development
    
    /// Enable verbose logging
    static let verboseLogging = Environment.current == .development
    
    /// Maximum number of retry attempts for network requests
    static let maxNetworkRetries = 3
    
    /// Network request timeout in seconds
    static let networkTimeout: TimeInterval = 30
    
    // MARK: - Onboarding
    // CUSTOMIZE: Configure onboarding experience
    
    /// Number of onboarding screens
    static let onboardingScreenCount = 3
    
    /// Show skip button on onboarding
    static let allowSkipOnboarding = true
    
    // MARK: - Subscription
    // CUSTOMIZE: Configure subscription/paywall
    
    /// Show paywall immediately after onboarding
    static let showPaywallAfterOnboarding = false
    
    /// Number of free uses before showing paywall (0 = unlimited)
    static let freeUsageLimit = 0
    
    /// Subscription product identifiers
    static let monthlySubscriptionID = "com.indiedev.appstarter.monthly"
    static let yearlySubscriptionID = "com.indiedev.appstarter.yearly"
    static let lifetimeSubscriptionID = "com.indiedev.appstarter.lifetime"
    
    // MARK: - URLs
    // CUSTOMIZE: Add your app's URLs
    
    /// Privacy policy URL
    static let privacyPolicyURL = URL(string: "https://yourwebsite.com/privacy")!
    
    /// Terms of service URL
    static let termsOfServiceURL = URL(string: "https://yourwebsite.com/terms")!
    
    /// Support/contact URL
    static let supportURL = URL(string: "https://yourwebsite.com/support")!
    
    /// App Store URL (for ratings)
    static var appStoreURL: URL? {
        // TODO: Replace with your actual App Store ID
        URL(string: "https://apps.apple.com/app/id123456789")
    }
    
    // MARK: - Contact
    // CUSTOMIZE: Add your contact information
    
    /// Support email address
    static let supportEmail = "support@yourcompany.com"
    
    /// Developer/company name
    static let developerName = "Your Name"
    
    /// Developer/company website
    static let developerWebsite = URL(string: "https://yourwebsite.com")
    
    // MARK: - Social Media
    // CUSTOMIZE: Add your social media handles (optional)
    
    static let twitterHandle: String? = nil // e.g., "@yourhandle"
    static let instagramHandle: String? = nil
    static let facebookPage: String? = nil
}

// MARK: - Computed Properties

extension AppConfig {
    
    /// Full app version string (e.g., "1.0.0 (1)")
    static var fullVersionString: String {
        "\(version) (\(buildNumber))"
    }
    
    /// User-facing version string
    static var displayVersion: String {
        "Version \(version)"
    }
    
    /// Check if running on iPad
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Check if running on iPhone
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

// MARK: - Validation

extension AppConfig {
    
    /// Validate configuration on app launch
    /// Call this in your app's initialization to catch configuration errors early
    static func validate() {
        #if DEBUG
        // Check for placeholder values that need to be replaced
        if revenueCatAPIKey.contains("YOUR_") {
            print("⚠️ WARNING: RevenueCat API key not configured")
        }
        
        if analyticsAPIKey.contains("YOUR_") {
            print("⚠️ WARNING: Analytics API key not configured")
        }
        
        if supportEmail.contains("yourcompany") {
            print("⚠️ WARNING: Support email not configured")
        }
        
        print("✅ AppConfig validation complete")
        print("   App: \(appDisplayName)")
        print("   Bundle ID: \(bundleID)")
        print("   Version: \(fullVersionString)")
        print("   Environment: \(Environment.current)")
        #endif
    }
}

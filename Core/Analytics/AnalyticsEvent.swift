//
//  AnalyticsEvent.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Analytics Event

/// Type-safe analytics event
struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]?
    let timestamp: Date
    
    init(name: String, parameters: [String: Any]? = nil) {
        self.name = name
        self.parameters = parameters
        self.timestamp = Date()
    }
}

// MARK: - Common Events

/// Predefined common analytics events
/// CUSTOMIZE: Add your app-specific events here
extension AnalyticsEvent {
    
    // MARK: - App Lifecycle
    
    /// App opened event
    static func appOpened() -> AnalyticsEvent {
        AnalyticsEvent(name: "app_opened")
    }
    
    /// App backgrounded event
    static func appBackgrounded() -> AnalyticsEvent {
        AnalyticsEvent(name: "app_backgrounded")
    }
    
    /// App terminated event
    static func appTerminated() -> AnalyticsEvent {
        AnalyticsEvent(name: "app_terminated")
    }
    
    // MARK: - Screen Tracking
    
    /// Screen viewed event
    /// - Parameter screenName: Name of the screen
    static func screenViewed(_ screenName: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "screen_viewed",
            parameters: ["screen_name": screenName]
        )
    }
    
    // MARK: - User Actions
    
    /// Button tapped event
    /// - Parameters:
    ///   - buttonName: Name of the button
    ///   - screenName: Screen where button was tapped
    static func buttonTapped(_ buttonName: String, screen: String? = nil) -> AnalyticsEvent {
        var params: [String: Any] = ["button_name": buttonName]
        if let screen = screen {
            params["screen_name"] = screen
        }
        return AnalyticsEvent(name: "button_tapped", parameters: params)
    }
    
    /// Link tapped event
    /// - Parameters:
    ///   - url: URL that was tapped
    ///   - screenName: Screen where link was tapped
    static func linkTapped(_ url: String, screen: String? = nil) -> AnalyticsEvent {
        var params: [String: Any] = ["url": url]
        if let screen = screen {
            params["screen_name"] = screen
        }
        return AnalyticsEvent(name: "link_tapped", parameters: params)
    }
    
    /// Search performed event
    /// - Parameters:
    ///   - query: Search query
    ///   - resultCount: Number of results
    static func searchPerformed(query: String, resultCount: Int? = nil) -> AnalyticsEvent {
        var params: [String: Any] = ["query": query]
        if let count = resultCount {
            params["result_count"] = count
        }
        return AnalyticsEvent(name: "search_performed", parameters: params)
    }
    
    // MARK: - Onboarding
    
    /// Onboarding started event
    static func onboardingStarted() -> AnalyticsEvent {
        AnalyticsEvent(name: "onboarding_started")
    }
    
    /// Onboarding completed event
    static func onboardingCompleted() -> AnalyticsEvent {
        AnalyticsEvent(name: "onboarding_completed")
    }
    
    /// Onboarding skipped event
    /// - Parameter step: Step where onboarding was skipped
    static func onboardingSkipped(step: Int) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "onboarding_skipped",
            parameters: ["step": step]
        )
    }
    
    // MARK: - Authentication
    
    /// Login event
    /// - Parameter method: Login method (email, google, apple, etc.)
    static func login(method: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "login",
            parameters: ["method": method]
        )
    }
    
    /// Signup event
    /// - Parameter method: Signup method
    static func signup(method: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "signup",
            parameters: ["method": method]
        )
    }
    
    /// Logout event
    static func logout() -> AnalyticsEvent {
        AnalyticsEvent(name: "logout")
    }
    
    // MARK: - Monetization
    
    /// Purchase initiated event
    /// - Parameters:
    ///   - productID: Product identifier
    ///   - price: Product price
    ///   - currency: Currency code
    static func purchaseInitiated(productID: String, price: Double, currency: String = "USD") -> AnalyticsEvent {
        AnalyticsEvent(
            name: "purchase_initiated",
            parameters: [
                "product_id": productID,
                "price": price,
                "currency": currency
            ]
        )
    }
    
    /// Purchase completed event
    /// - Parameters:
    ///   - productID: Product identifier
    ///   - price: Product price
    ///   - currency: Currency code
    ///   - transactionID: Transaction identifier
    static func purchaseCompleted(
        productID: String,
        price: Double,
        currency: String = "USD",
        transactionID: String? = nil
    ) -> AnalyticsEvent {
        var params: [String: Any] = [
            "product_id": productID,
            "price": price,
            "currency": currency
        ]
        if let transactionID = transactionID {
            params["transaction_id"] = transactionID
        }
        return AnalyticsEvent(name: "purchase_completed", parameters: params)
    }
    
    /// Purchase failed event
    /// - Parameters:
    ///   - productID: Product identifier
    ///   - reason: Failure reason
    static func purchaseFailed(productID: String, reason: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "purchase_failed",
            parameters: [
                "product_id": productID,
                "reason": reason
            ]
        )
    }
    
    /// Subscription started event
    /// - Parameters:
    ///   - plan: Subscription plan (monthly, yearly, etc.)
    ///   - price: Subscription price
    static func subscriptionStarted(plan: String, price: Double) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "subscription_started",
            parameters: [
                "plan": plan,
                "price": price
            ]
        )
    }
    
    /// Subscription cancelled event
    /// - Parameter plan: Subscription plan
    static func subscriptionCancelled(plan: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "subscription_cancelled",
            parameters: ["plan": plan]
        )
    }
    
    // MARK: - Engagement
    
    /// Content viewed event
    /// - Parameters:
    ///   - contentType: Type of content
    ///   - contentID: Content identifier
    static func contentViewed(type: String, id: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "content_viewed",
            parameters: [
                "content_type": type,
                "content_id": id
            ]
        )
    }
    
    /// Share event
    /// - Parameters:
    ///   - contentType: Type of content shared
    ///   - method: Share method (twitter, facebook, etc.)
    static func share(contentType: String, method: String) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "share",
            parameters: [
                "content_type": contentType,
                "method": method
            ]
        )
    }
    
    /// Rating given event
    /// - Parameter rating: Rating value
    static func ratingGiven(rating: Int) -> AnalyticsEvent {
        AnalyticsEvent(
            name: "rating_given",
            parameters: ["rating": rating]
        )
    }
    
    // MARK: - Errors
    
    /// Error occurred event
    /// - Parameters:
    ///   - error: Error message
    ///   - screen: Screen where error occurred
    static func errorOccurred(error: String, screen: String? = nil) -> AnalyticsEvent {
        var params: [String: Any] = ["error": error]
        if let screen = screen {
            params["screen_name"] = screen
        }
        return AnalyticsEvent(name: "error_occurred", parameters: params)
    }
}

// MARK: - Event Builder

/// Fluent builder for creating custom events
struct AnalyticsEventBuilder {
    private var name: String
    private var parameters: [String: Any] = [:]
    
    init(name: String) {
        self.name = name
    }
    
    func with(_ key: String, value: Any) -> AnalyticsEventBuilder {
        var builder = self
        builder.parameters[key] = value
        return builder
    }
    
    func build() -> AnalyticsEvent {
        AnalyticsEvent(name: name, parameters: parameters)
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Using predefined events:
 
 ```swift
 AnalyticsManager.shared.track(.appOpened())
 AnalyticsManager.shared.track(.screenViewed("HomeScreen"))
 AnalyticsManager.shared.track(.buttonTapped("purchase_button", screen: "ProductDetail"))
 AnalyticsManager.shared.track(.purchaseCompleted(productID: "premium", price: 9.99))
 ```
 
 2. Creating custom events:
 
 ```swift
 let event = AnalyticsEvent(name: "custom_event", parameters: ["key": "value"])
 AnalyticsManager.shared.track(event)
 ```
 
 3. Using event builder:
 
 ```swift
 let event = AnalyticsEventBuilder(name: "video_played")
     .with("video_id", value: "123")
     .with("duration", value: 120)
     .with("quality", value: "HD")
     .build()
 AnalyticsManager.shared.track(event)
 ```
 
 */

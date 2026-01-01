//
//  AnalyticsProvider.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Analytics Provider Protocol

/// Protocol that all analytics providers must implement
/// Allows easy integration of multiple analytics services (Firebase, Mixpanel, Amplitude, etc.)
protocol AnalyticsProvider {
    
    /// Provider name for identification
    var name: String { get }
    
    /// Track an event
    /// - Parameters:
    ///   - name: Event name
    ///   - parameters: Event parameters
    func trackEvent(_ name: String, parameters: [String: Any]?)
    
    /// Track screen view
    /// - Parameter screenName: Name of the screen
    func trackScreen(_ screenName: String)
    
    /// Set user property
    /// - Parameters:
    ///   - name: Property name
    ///   - value: Property value
    func setUserProperty(_ name: String, value: Any?)
    
    /// Set user ID
    /// - Parameter userID: User identifier
    func setUserID(_ userID: String?)
    
    /// Reset user data (for logout)
    func reset()
}

// MARK: - Default Implementations

extension AnalyticsProvider {
    
    /// Default implementation for screen tracking
    /// Can be overridden by providers that have specific screen tracking
    func trackScreen(_ screenName: String) {
        trackEvent("screen_viewed", parameters: ["screen_name": screenName])
    }
    
    /// Default implementation for reset
    /// Can be overridden by providers that need custom reset logic
    func reset() {
        setUserID(nil)
    }
}

// MARK: - Usage Examples

/*
 
 IMPLEMENTING A CUSTOM PROVIDER:
 
 1. Firebase Analytics Provider:
 
 ```swift
 import FirebaseAnalytics
 
 class FirebaseAnalyticsProvider: AnalyticsProvider {
     var name: String { "Firebase" }
     
     func trackEvent(_ name: String, parameters: [String: Any]?) {
         Analytics.logEvent(name, parameters: parameters)
     }
     
     func trackScreen(_ screenName: String) {
         Analytics.logEvent(AnalyticsEventScreenView, parameters: [
             AnalyticsParameterScreenName: screenName
         ])
     }
     
     func setUserProperty(_ name: String, value: Any?) {
         Analytics.setUserProperty(value as? String, forName: name)
     }
     
     func setUserID(_ userID: String?) {
         Analytics.setUserID(userID)
     }
     
     func reset() {
         Analytics.resetAnalyticsData()
     }
 }
 ```
 
 2. Mixpanel Provider:
 
 ```swift
 import Mixpanel
 
 class MixpanelAnalyticsProvider: AnalyticsProvider {
     var name: String { "Mixpanel" }
     
     private let mixpanel = Mixpanel.mainInstance()
     
     func trackEvent(_ name: String, parameters: [String: Any]?) {
         mixpanel.track(event: name, properties: parameters)
     }
     
     func setUserProperty(_ name: String, value: Any?) {
         mixpanel.people.set(property: name, to: value ?? NSNull())
     }
     
     func setUserID(_ userID: String?) {
         if let userID = userID {
             mixpanel.identify(distinctId: userID)
         }
     }
     
     func reset() {
         mixpanel.reset()
     }
 }
 ```
 
 3. Custom API Provider:
 
 ```swift
 class CustomAPIAnalyticsProvider: AnalyticsProvider {
     var name: String { "CustomAPI" }
     
     func trackEvent(_ name: String, parameters: [String: Any]?) {
         Task {
             try? await NetworkManager.shared.post("/analytics/events", body: [
                 "event": name,
                 "parameters": parameters ?? [:]
             ])
         }
     }
     
     func setUserProperty(_ name: String, value: Any?) {
         // Send to your API
     }
     
     func setUserID(_ userID: String?) {
         // Store user ID
     }
 }
 ```
 
 REGISTERING PROVIDERS:
 
 ```swift
 // In app initialization
 AnalyticsManager.shared.register(FirebaseAnalyticsProvider())
 AnalyticsManager.shared.register(MixpanelAnalyticsProvider())
 AnalyticsManager.shared.register(ConsoleAnalyticsProvider())
 ```
 
 */

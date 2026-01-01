//
//  ConsoleAnalyticsProvider.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Console Analytics Provider

/// Debug analytics provider that prints events to console
/// Useful for development and testing
/// No external dependencies required
class ConsoleAnalyticsProvider: AnalyticsProvider {
    
    var name: String { "Console" }
    
    private var currentUserID: String?
    private var userProperties: [String: Any] = [:]
    
    func trackEvent(_ name: String, parameters: [String: Any]?) {
        print("📊 [Analytics] Event: \(name)")
        if let parameters = parameters, !parameters.isEmpty {
            print("   Parameters:")
            for (key, value) in parameters {
                print("   - \(key): \(value)")
            }
        }
        if let userID = currentUserID {
            print("   User ID: \(userID)")
        }
        print("   Timestamp: \(Date().formatted(style: .dateTime))")
        print("---")
    }
    
    func trackScreen(_ screenName: String) {
        print("📱 [Analytics] Screen: \(screenName)")
        if let userID = currentUserID {
            print("   User ID: \(userID)")
        }
        print("   Timestamp: \(Date().formatted(style: .dateTime))")
        print("---")
    }
    
    func setUserProperty(_ name: String, value: Any?) {
        if let value = value {
            userProperties[name] = value
            print("👤 [Analytics] User Property Set: \(name) = \(value)")
        } else {
            userProperties.removeValue(forKey: name)
            print("👤 [Analytics] User Property Removed: \(name)")
        }
        print("---")
    }
    
    func setUserID(_ userID: String?) {
        currentUserID = userID
        if let userID = userID {
            print("🆔 [Analytics] User ID Set: \(userID)")
        } else {
            print("🆔 [Analytics] User ID Cleared")
        }
        print("---")
    }
    
    func reset() {
        currentUserID = nil
        userProperties.removeAll()
        print("🔄 [Analytics] Reset - All user data cleared")
        print("---")
    }
}

// MARK: - Pretty Console Provider

/// Enhanced console provider with formatted output
class PrettyConsoleAnalyticsProvider: AnalyticsProvider {
    
    var name: String { "PrettyConsole" }
    
    private var currentUserID: String?
    
    func trackEvent(_ name: String, parameters: [String: Any]?) {
        print("\n" + String(repeating: "=", count: 60))
        print("📊 ANALYTICS EVENT")
        print(String(repeating: "=", count: 60))
        print("Event Name: \(name)")
        print("Timestamp:  \(Date().formatted(style: .dateTime))")
        
        if let userID = currentUserID {
            print("User ID:    \(userID)")
        }
        
        if let parameters = parameters, !parameters.isEmpty {
            print("\nParameters:")
            for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
                print("  • \(key): \(value)")
            }
        }
        
        print(String(repeating: "=", count: 60) + "\n")
    }
    
    func trackScreen(_ screenName: String) {
        print("\n" + String(repeating: "-", count: 60))
        print("📱 SCREEN VIEW: \(screenName)")
        print("   Time: \(Date().formatted(style: .time))")
        if let userID = currentUserID {
            print("   User: \(userID)")
        }
        print(String(repeating: "-", count: 60) + "\n")
    }
    
    func setUserProperty(_ name: String, value: Any?) {
        print("👤 User Property: \(name) → \(value ?? "nil")")
    }
    
    func setUserID(_ userID: String?) {
        currentUserID = userID
        print("🆔 User ID: \(userID ?? "cleared")")
    }
    
    func reset() {
        currentUserID = nil
        print("🔄 Analytics Reset")
    }
}

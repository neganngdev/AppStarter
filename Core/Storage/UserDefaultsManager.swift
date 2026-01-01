//
//  UserDefaultsManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - UserDefaults Manager

/// Thread-safe UserDefaults manager with type-safe access
actor UserDefaultsManager {
    
    // MARK: - Singleton
    
    static let shared = UserDefaultsManager()
    
    private let defaults: UserDefaults
    
    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Generic Methods
    
    /// Save value to UserDefaults
    /// - Parameters:
    ///   - value: Value to save
    ///   - key: Storage key
    func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    /// Get value from UserDefaults
    /// - Parameters:
    ///   - key: Storage key
    ///   - defaultValue: Default value if key doesn't exist
    /// - Returns: Stored value or default value
    func get<T>(_ key: String, defaultValue: T) -> T {
        defaults.object(forKey: key) as? T ?? defaultValue
    }
    
    /// Remove value from UserDefaults
    /// - Parameter key: Storage key
    func remove(_ key: String) {
        defaults.removeObject(forKey: key)
    }
    
    /// Check if key exists
    /// - Parameter key: Storage key
    /// - Returns: true if key exists
    func exists(_ key: String) -> Bool {
        defaults.object(forKey: key) != nil
    }
    
    /// Clear all UserDefaults (use with caution!)
    func clearAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
    
    // MARK: - Codable Support
    
    /// Save Codable object to UserDefaults
    /// - Parameters:
    ///   - object: Codable object to save
    ///   - key: Storage key
    /// - Throws: Encoding error
    func setCodable<T: Codable>(_ object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        defaults.set(data, forKey: key)
    }
    
    /// Get Codable object from UserDefaults
    /// - Parameter key: Storage key
    /// - Returns: Decoded object or nil
    /// - Throws: Decoding error
    func getCodable<T: Codable>(_ key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - Property Wrapper

/// Property wrapper for type-safe UserDefaults access
///
/// Usage:
/// ```swift
/// @UserDefault(key: "hasSeenOnboarding", defaultValue: false)
/// static var hasSeenOnboarding: Bool
///
/// @UserDefault(key: "userName", defaultValue: "")
/// static var userName: String
/// ```
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let defaults: UserDefaults
    
    init(key: String, defaultValue: T, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
    }
    
    var wrappedValue: T {
        get {
            defaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}

// MARK: - Codable Property Wrapper

/// Property wrapper for Codable types in UserDefaults
///
/// Usage:
/// ```swift
/// @CodableUserDefault(key: "userProfile")
/// static var userProfile: UserProfile?
/// ```
@propertyWrapper
struct CodableUserDefault<T: Codable> {
    let key: String
    let defaults: UserDefaults
    
    init(key: String, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
    }
    
    var wrappedValue: T? {
        get {
            guard let data = defaults.data(forKey: key) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                defaults.set(data, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

// MARK: - Storage Keys

/// Centralized storage keys for UserDefaults
/// CUSTOMIZE: Add your app-specific keys here
enum StorageKeys {
    
    // MARK: - Onboarding
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let onboardingVersion = "onboardingVersion"
    
    // MARK: - App State
    static let lastAppVersion = "lastAppVersion"
    static let lastLaunchDate = "lastLaunchDate"
    static let appLaunchCount = "appLaunchCount"
    
    // MARK: - User Preferences
    static let isDarkModeEnabled = "isDarkModeEnabled"
    static let notificationsEnabled = "notificationsEnabled"
    static let selectedLanguage = "selectedLanguage"
    
    // MARK: - Feature Flags
    static let hasRatedApp = "hasRatedApp"
    static let hasSubscription = "hasSubscription"
    static let subscriptionExpiryDate = "subscriptionExpiryDate"
    
    // MARK: - Analytics
    static let analyticsEnabled = "analyticsEnabled"
    static let lastAnalyticsSyncDate = "lastAnalyticsSyncDate"
}

// MARK: - AppStorage Helper

/// Convenient storage properties using property wrappers
/// CUSTOMIZE: Add your app-specific storage properties
enum AppStorage {
    
    // MARK: - Onboarding
    
    @UserDefault(key: StorageKeys.hasSeenOnboarding, defaultValue: false)
    static var hasSeenOnboarding: Bool
    
    @UserDefault(key: StorageKeys.onboardingVersion, defaultValue: "1.0")
    static var onboardingVersion: String
    
    // MARK: - App State
    
    @UserDefault(key: StorageKeys.lastAppVersion, defaultValue: "")
    static var lastAppVersion: String
    
    @UserDefault(key: StorageKeys.appLaunchCount, defaultValue: 0)
    static var appLaunchCount: Int
    
    // MARK: - User Preferences
    
    @UserDefault(key: StorageKeys.isDarkModeEnabled, defaultValue: false)
    static var isDarkModeEnabled: Bool
    
    @UserDefault(key: StorageKeys.notificationsEnabled, defaultValue: true)
    static var notificationsEnabled: Bool
    
    @UserDefault(key: StorageKeys.selectedLanguage, defaultValue: "en")
    static var selectedLanguage: String
    
    // MARK: - Feature Flags
    
    @UserDefault(key: StorageKeys.hasRatedApp, defaultValue: false)
    static var hasRatedApp: Bool
    
    @UserDefault(key: StorageKeys.hasSubscription, defaultValue: false)
    static var hasSubscription: Bool
    
    // MARK: - Analytics
    
    @UserDefault(key: StorageKeys.analyticsEnabled, defaultValue: true)
    static var analyticsEnabled: Bool
    
    // MARK: - Helper Methods
    
    /// Reset all app storage (useful for logout or reset)
    static func reset() {
        hasSeenOnboarding = false
        hasRatedApp = false
        hasSubscription = false
        analyticsEnabled = true
        // Add more resets as needed
    }
    
    /// Increment app launch count
    static func incrementLaunchCount() {
        appLaunchCount += 1
    }
    
    /// Update last app version
    static func updateAppVersion() {
        lastAppVersion = AppConfig.version
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Simple property wrapper usage:
 
 ```swift
 // Read
 if AppStorage.hasSeenOnboarding {
     // Show main screen
 } else {
     // Show onboarding
 }
 
 // Write
 AppStorage.hasSeenOnboarding = true
 ```
 
 2. Custom property wrapper:
 
 ```swift
 @UserDefault(key: "customKey", defaultValue: 100)
 static var customValue: Int
 ```
 
 3. Codable objects:
 
 ```swift
 struct UserProfile: Codable {
     let name: String
     let email: String
 }
 
 @CodableUserDefault(key: "userProfile")
 static var userProfile: UserProfile?
 
 // Usage
 userProfile = UserProfile(name: "John", email: "john@example.com")
 ```
 
 4. Using the manager directly:
 
 ```swift
 Task {
     await UserDefaultsManager.shared.set("value", forKey: "key")
     let value = await UserDefaultsManager.shared.get("key", defaultValue: "")
 }
 ```
 
 5. App lifecycle:
 
 ```swift
 // In AppDelegate or App init
 AppStorage.incrementLaunchCount()
 AppStorage.updateAppVersion()
 
 if AppStorage.appLaunchCount == 10 && !AppStorage.hasRatedApp {
     // Show rating prompt
 }
 ```
 
 */

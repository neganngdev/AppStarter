//
//  Environment.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

/// Application environment configuration
/// Manages different build configurations and environment-specific settings
enum Environment: String, CaseIterable {
    case development
    case staging
    case production
    
    // MARK: - Current Environment
    
    /// The current active environment
    /// Automatically detected based on build configuration
    static var current: Environment {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
    
    // MARK: - Environment Properties
    
    /// Human-readable name
    var name: String {
        switch self {
        case .development:
            return "Development"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        }
    }
    
    /// Short identifier
    var identifier: String {
        rawValue
    }
    
    /// Environment-specific API base URL
    /// CUSTOMIZE: Add your API endpoints
    var apiBaseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://dev-api.yourapp.com")!
        case .staging:
            return URL(string: "https://staging-api.yourapp.com")!
        case .production:
            return URL(string: "https://api.yourapp.com")!
        }
    }
    
    /// WebSocket URL (if applicable)
    /// CUSTOMIZE: Add your WebSocket endpoints
    var webSocketURL: URL? {
        switch self {
        case .development:
            return URL(string: "wss://dev-ws.yourapp.com")
        case .staging:
            return URL(string: "wss://staging-ws.yourapp.com")
        case .production:
            return URL(string: "wss://ws.yourapp.com")
        }
    }
    
    // MARK: - Debug Flags
    
    /// Enable verbose logging
    var isLoggingEnabled: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
    
    /// Log level for this environment
    var logLevel: LogLevel {
        switch self {
        case .development:
            return .verbose
        case .staging:
            return .debug
        case .production:
            return .error
        }
    }
    
    /// Enable network request logging
    var logNetworkRequests: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
    
    /// Enable analytics in this environment
    var isAnalyticsEnabled: Bool {
        switch self {
        case .development:
            return false // Don't pollute analytics with dev data
        case .staging:
            return true // Test analytics in staging
        case .production:
            return true
        }
    }
    
    /// Enable crash reporting
    var isCrashReportingEnabled: Bool {
        switch self {
        case .development:
            return false
        case .staging, .production:
            return true
        }
    }
    
    /// Show debug UI elements
    var showDebugUI: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
    
    /// Allow test/mock data
    var allowMockData: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
    
    // MARK: - Network Configuration
    
    /// Request timeout interval
    var requestTimeout: TimeInterval {
        switch self {
        case .development:
            return 60 // Longer timeout for debugging
        case .staging:
            return 45
        case .production:
            return 30
        }
    }
    
    /// Enable SSL certificate pinning
    var useSSLPinning: Bool {
        switch self {
        case .development, .staging:
            return false
        case .production:
            return true // Enable in production for security
        }
    }
    
    // MARK: - Feature Flags
    
    /// Enable experimental features
    var enableExperimentalFeatures: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
    
    /// Enable beta features
    var enableBetaFeatures: Bool {
        switch self {
        case .development:
            return true
        case .staging:
            return true
        case .production:
            return false
        }
    }
}

// MARK: - Log Level

/// Logging verbosity levels
enum LogLevel: Int, Comparable {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case none = 5
    
    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var emoji: String {
        switch self {
        case .verbose:
            return "💬"
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .none:
            return ""
        }
    }
    
    var name: String {
        switch self {
        case .verbose:
            return "VERBOSE"
        case .debug:
            return "DEBUG"
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        case .none:
            return "NONE"
        }
    }
}

// MARK: - Environment Info

extension Environment {
    
    /// Print environment information
    static func printInfo() {
        #if DEBUG
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🚀 Environment: \(current.name)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("📱 App: \(AppConfig.appDisplayName)")
        print("🆔 Bundle ID: \(AppConfig.bundleID)")
        print("📦 Version: \(AppConfig.fullVersionString)")
        print("🌐 API Base URL: \(current.apiBaseURL)")
        print("📊 Analytics: \(current.isAnalyticsEnabled ? "Enabled" : "Disabled")")
        print("🐛 Logging: \(current.logLevel.name)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        #endif
    }
}

// MARK: - Build Configuration Detection

extension Environment {
    
    /// Check if running in development
    static var isDevelopment: Bool {
        current == .development
    }
    
    /// Check if running in staging
    static var isStaging: Bool {
        current == .staging
    }
    
    /// Check if running in production
    static var isProduction: Bool {
        current == .production
    }
    
    /// Check if running in debug mode
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// Check if running in simulator
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// Check if running on physical device
    static var isDevice: Bool {
        !isSimulator
    }
}

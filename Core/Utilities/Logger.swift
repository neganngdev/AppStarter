//
//  Logger.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import Foundation
import os.log

// MARK: - Logger

/// Simple logging wrapper using os.Logger
class Logger {
    
    // MARK: - Singleton
    
    static let shared = Logger()
    
    // MARK: - Properties
    
    private let logger: os.Logger
    private let isEnabled: Bool
    
    // MARK: - Initialization
    
    private init() {
        self.logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "AppStarter", category: "App")
        
        // CUSTOMIZE: Disable logging in production
        #if DEBUG
        self.isEnabled = true
        #else
        self.isEnabled = Environment.current.isLoggingEnabled
        #endif
    }
    
    // MARK: - Public Methods
    
    /// Log debug message
    /// - Parameters:
    ///   - message: Message to log
    ///   - file: Source file (auto-filled)
    ///   - function: Function name (auto-filled)
    ///   - line: Line number (auto-filled)
    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    /// Log info message
    /// - Parameters:
    ///   - message: Message to log
    ///   - file: Source file (auto-filled)
    ///   - function: Function name (auto-filled)
    ///   - line: Line number (auto-filled)
    func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    /// Log warning message
    /// - Parameters:
    ///   - message: Message to log
    ///   - file: Source file (auto-filled)
    ///   - function: Function name (auto-filled)
    ///   - line: Line number (auto-filled)
    func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    /// Log error message
    /// - Parameters:
    ///   - message: Message to log
    ///   - file: Source file (auto-filled)
    ///   - function: Function name (auto-filled)
    ///   - line: Line number (auto-filled)
    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .error, file: file, function: function, line: line)
    }
    
    // MARK: - Private Methods
    
    private func log(
        _ message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int
    ) {
        guard isEnabled else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line)] \(function) - \(message)"
        
        switch level {
        case .verbose:
            logger.debug("\(logMessage)")
        case .debug:
            logger.debug("\(logMessage)")
        case .info:
            logger.info("\(logMessage)")
        case .warning:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        case .none:
            break
        }
        
        // Also print to console in debug builds
        #if DEBUG
        print(logMessage)
        #endif
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 // Debug
 Logger.shared.debug("User tapped button")
 
 // Info
 Logger.shared.info("Data loaded successfully")
 
 // Warning
 Logger.shared.warning("Low storage space")
 
 // Error
 Logger.shared.error("Failed to save data: \(error)")
 
 // In functions
 func fetchData() async {
     Logger.shared.debug("Starting data fetch")
     
     do {
         let data = try await loadData()
         Logger.shared.info("Fetched \(data.count) items")
     } catch {
         Logger.shared.error("Fetch failed: \(error)")
     }
 }
 
 // Network requests
 Logger.shared.debug("GET /api/users")
 Logger.shared.info("Response: 200 OK")
 
 // State changes
 Logger.shared.debug("State changed: \(oldState) -> \(newState)")
 ```
 
 */

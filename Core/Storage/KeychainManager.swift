//
//  KeychainManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation
import Security

// MARK: - Keychain Error

/// Errors that can occur during Keychain operations
enum KeychainError: Error, LocalizedError {
    case itemNotFound
    case duplicateItem
    case invalidData
    case unhandledError(status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found in Keychain"
        case .duplicateItem:
            return "Item already exists in Keychain"
        case .invalidData:
            return "Invalid data format"
        case .unhandledError(let status):
            return "Keychain error with status: \(status)"
        }
    }
}

// MARK: - Keychain Manager

/// Thread-safe Keychain manager for secure storage
/// Use for sensitive data like tokens, passwords, API keys
actor KeychainManager {
    
    // MARK: - Singleton
    
    static let shared = KeychainManager()
    
    private let service: String
    
    private init(service: String = Bundle.main.bundleIdentifier ?? "com.appstarter") {
        self.service = service
    }
    
    // MARK: - String Operations
    
    /// Save string to Keychain
    /// - Parameters:
    ///   - key: Unique key for the item
    ///   - value: String value to save
    /// - Throws: KeychainError
    ///
    /// Example:
    /// ```swift
    /// try await KeychainManager.shared.save("auth_token", value: token)
    /// ```
    func save(_ key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try save(key, data: data)
    }
    
    /// Get string from Keychain
    /// - Parameter key: Unique key for the item
    /// - Returns: String value or nil if not found
    /// - Throws: KeychainError
    ///
    /// Example:
    /// ```swift
    /// let token = try await KeychainManager.shared.getString("auth_token")
    /// ```
    func getString(_ key: String) throws -> String? {
        guard let data = try getData(key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Data Operations
    
    /// Save data to Keychain
    /// - Parameters:
    ///   - key: Unique key for the item
    ///   - data: Data to save
    /// - Throws: KeychainError
    func save(_ key: String, data: Data) throws {
        // Delete existing item if present
        try? delete(key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Get data from Keychain
    /// - Parameter key: Unique key for the item
    /// - Returns: Data or nil if not found
    /// - Throws: KeychainError
    func getData(_ key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        return result as? Data
    }
    
    // MARK: - Codable Operations
    
    /// Save Codable object to Keychain
    /// - Parameters:
    ///   - key: Unique key for the item
    ///   - value: Codable object to save
    /// - Throws: KeychainError or encoding error
    ///
    /// Example:
    /// ```swift
    /// struct Credentials: Codable {
    ///     let username: String
    ///     let password: String
    /// }
    /// try await KeychainManager.shared.saveCodable("credentials", value: creds)
    /// ```
    func saveCodable<T: Codable>(_ key: String, value: T) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        try save(key, data: data)
    }
    
    /// Get Codable object from Keychain
    /// - Parameter key: Unique key for the item
    /// - Returns: Decoded object or nil if not found
    /// - Throws: KeychainError or decoding error
    func getCodable<T: Codable>(_ key: String) throws -> T? {
        guard let data = try getData(key) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Delete Operations
    
    /// Delete item from Keychain
    /// - Parameter key: Unique key for the item
    /// - Throws: KeychainError
    ///
    /// Example:
    /// ```swift
    /// try await KeychainManager.shared.delete("auth_token")
    /// ```
    func delete(_ key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    /// Delete all items from Keychain for this service
    /// - Throws: KeychainError
    func deleteAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    // MARK: - Existence Check
    
    /// Check if key exists in Keychain
    /// - Parameter key: Unique key for the item
    /// - Returns: true if item exists
    func exists(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}

// MARK: - Common Keychain Keys

/// Centralized keys for Keychain storage
/// CUSTOMIZE: Add your app-specific secure storage keys
enum KeychainKeys {
    static let authToken = "auth_token"
    static let refreshToken = "refresh_token"
    static let userPassword = "user_password"
    static let apiKey = "api_key"
    static let encryptionKey = "encryption_key"
    static let biometricToken = "biometric_token"
}

// MARK: - Secure Storage Helper

/// Convenient secure storage using Keychain
/// CUSTOMIZE: Add your app-specific secure properties
enum SecureStorage {
    
    // MARK: - Authentication
    
    /// Save authentication token
    static func saveAuthToken(_ token: String) async throws {
        try await KeychainManager.shared.save(KeychainKeys.authToken, value: token)
    }
    
    /// Get authentication token
    static func getAuthToken() async throws -> String? {
        try await KeychainManager.shared.getString(KeychainKeys.authToken)
    }
    
    /// Delete authentication token
    static func deleteAuthToken() async throws {
        try await KeychainManager.shared.delete(KeychainKeys.authToken)
    }
    
    // MARK: - Refresh Token
    
    /// Save refresh token
    static func saveRefreshToken(_ token: String) async throws {
        try await KeychainManager.shared.save(KeychainKeys.refreshToken, value: token)
    }
    
    /// Get refresh token
    static func getRefreshToken() async throws -> String? {
        try await KeychainManager.shared.getString(KeychainKeys.refreshToken)
    }
    
    // MARK: - Logout
    
    /// Clear all secure data (useful for logout)
    static func clearAll() async throws {
        try await KeychainManager.shared.deleteAll()
    }
    
    // MARK: - Existence Checks
    
    /// Check if user is logged in (has auth token)
    static func isLoggedIn() async -> Bool {
        await KeychainManager.shared.exists(KeychainKeys.authToken)
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Save and retrieve strings:
 
 ```swift
 // Save
 Task {
     try await KeychainManager.shared.save("auth_token", value: "abc123")
 }
 
 // Retrieve
 Task {
     if let token = try await KeychainManager.shared.getString("auth_token") {
         print("Token: \(token)")
     }
 }
 
 // Delete
 Task {
     try await KeychainManager.shared.delete("auth_token")
 }
 ```
 
 2. Save and retrieve Codable objects:
 
 ```swift
 struct UserCredentials: Codable {
     let username: String
     let password: String
 }
 
 // Save
 Task {
     let creds = UserCredentials(username: "user", password: "pass")
     try await KeychainManager.shared.saveCodable("credentials", value: creds)
 }
 
 // Retrieve
 Task {
     let creds: UserCredentials? = try await KeychainManager.shared.getCodable("credentials")
 }
 ```
 
 3. Using SecureStorage helper:
 
 ```swift
 // Login
 Task {
     try await SecureStorage.saveAuthToken(authToken)
     try await SecureStorage.saveRefreshToken(refreshToken)
 }
 
 // Check login status
 Task {
     let isLoggedIn = await SecureStorage.isLoggedIn()
 }
 
 // Logout
 Task {
     try await SecureStorage.clearAll()
 }
 ```
 
 4. Error handling:
 
 ```swift
 Task {
     do {
         try await KeychainManager.shared.save("key", value: "value")
     } catch KeychainError.duplicateItem {
         print("Item already exists")
     } catch {
         print("Error: \(error.localizedDescription)")
     }
 }
 ```
 
 */

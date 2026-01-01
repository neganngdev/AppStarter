//
//  String+Extensions.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - String Extensions

extension String {
    
    // MARK: - Validation
    
    /// Check if string is empty after trimming whitespace and newlines
    /// - Returns: true if the trimmed string is empty
    ///
    /// Example:
    /// ```swift
    /// "   ".isEmptyOrWhitespace // true
    /// "  hello  ".isEmptyOrWhitespace // false
    /// ```
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if string is a valid email address
    /// - Returns: true if the string matches email pattern
    ///
    /// Example:
    /// ```swift
    /// "user@example.com".isValidEmail // true
    /// "invalid.email".isValidEmail // false
    /// ```
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Check if string is a valid URL
    /// - Returns: true if the string is a valid URL
    ///
    /// Example:
    /// ```swift
    /// "https://example.com".isValidURL // true
    /// "not a url".isValidURL // false
    /// ```
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil && url.host != nil
    }
    
    /// Check if string contains only digits
    /// - Returns: true if string contains only numbers
    ///
    /// Example:
    /// ```swift
    /// "12345".isNumeric // true
    /// "123abc".isNumeric // false
    /// ```
    var isNumeric: Bool {
        !isEmpty && allSatisfy { $0.isNumber }
    }
    
    // MARK: - Formatting
    
    /// Returns trimmed string (whitespace and newlines removed from both ends)
    ///
    /// Example:
    /// ```swift
    /// "  hello  ".trimmed // "hello"
    /// ```
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Truncate string to specified length with ellipsis
    /// - Parameter length: Maximum length of the string
    /// - Returns: Truncated string with "..." if needed
    ///
    /// Example:
    /// ```swift
    /// "Hello World".truncated(to: 8) // "Hello..."
    /// "Hi".truncated(to: 10) // "Hi"
    /// ```
    func truncated(to length: Int, trailing: String = "...") -> String {
        if count > length {
            return prefix(length) + trailing
        }
        return self
    }
    
    /// Capitalize only the first letter
    /// - Returns: String with first letter capitalized
    ///
    /// Example:
    /// ```swift
    /// "hello world".capitalizingFirstLetter() // "Hello world"
    /// ```
    func capitalizingFirstLetter() -> String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
    
    /// Remove all whitespace from string
    /// - Returns: String without any whitespace
    ///
    /// Example:
    /// ```swift
    /// "hello world".removingWhitespace() // "helloworld"
    /// ```
    func removingWhitespace() -> String {
        replacingOccurrences(of: " ", with: "")
    }
    
    // MARK: - Localization
    
    /// Localized string using NSLocalizedString
    /// - Parameters:
    ///   - bundle: Bundle to search for localized strings (default: main bundle)
    ///   - comment: Comment for translators
    /// - Returns: Localized string
    ///
    /// Example:
    /// ```swift
    /// "welcome_message".localized() // Returns localized version
    /// "greeting".localized(comment: "User greeting on home screen")
    /// ```
    func localized(bundle: Bundle = .main, comment: String = "") -> String {
        NSLocalizedString(self, bundle: bundle, comment: comment)
    }
    
    /// Localized string with format arguments
    /// - Parameters:
    ///   - arguments: Arguments to substitute in the localized string
    /// - Returns: Formatted localized string
    ///
    /// Example:
    /// ```swift
    /// "hello_user".localized(with: userName) // "Hello, John"
    /// ```
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized(), arguments: arguments)
    }
    
    // MARK: - Subscripting
    
    /// Safe subscript access by index
    /// - Parameter index: Index to access
    /// - Returns: Character at index or nil if out of bounds
    ///
    /// Example:
    /// ```swift
    /// "Hello"[safe: 1] // "e"
    /// "Hello"[safe: 10] // nil
    /// ```
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    // MARK: - Conversion
    
    /// Convert string to URL
    /// - Returns: URL if string is valid URL, nil otherwise
    ///
    /// Example:
    /// ```swift
    /// "https://example.com".toURL() // URL object
    /// ```
    func toURL() -> URL? {
        URL(string: self)
    }
    
    /// Convert string to Int
    /// - Returns: Int value if conversion succeeds
    ///
    /// Example:
    /// ```swift
    /// "123".toInt() // 123
    /// "abc".toInt() // nil
    /// ```
    func toInt() -> Int? {
        Int(self)
    }
    
    /// Convert string to Double
    /// - Returns: Double value if conversion succeeds
    ///
    /// Example:
    /// ```swift
    /// "123.45".toDouble() // 123.45
    /// ```
    func toDouble() -> Double? {
        Double(self)
    }
    
    /// Convert string to Bool
    /// - Returns: Bool value (true for "true", "yes", "1", false otherwise)
    ///
    /// Example:
    /// ```swift
    /// "true".toBool() // true
    /// "yes".toBool() // true
    /// "1".toBool() // true
    /// ```
    func toBool() -> Bool {
        let lowercased = self.lowercased().trimmed
        return ["true", "yes", "1"].contains(lowercased)
    }
    
    // MARK: - Encoding
    
    /// URL encoded string
    /// - Returns: URL encoded string
    ///
    /// Example:
    /// ```swift
    /// "hello world".urlEncoded() // "hello%20world"
    /// ```
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// Base64 encoded string
    /// - Returns: Base64 encoded string
    ///
    /// Example:
    /// ```swift
    /// "Hello".base64Encoded() // "SGVsbG8="
    /// ```
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }
    
    /// Decode base64 string
    /// - Returns: Decoded string
    ///
    /// Example:
    /// ```swift
    /// "SGVsbG8=".base64Decoded() // "Hello"
    /// ```
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Utilities
    
    /// Count of words in string
    /// - Returns: Number of words
    ///
    /// Example:
    /// ```swift
    /// "Hello world".wordCount // 2
    /// ```
    var wordCount: Int {
        let words = components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
    
    /// Check if string contains another string (case insensitive)
    /// - Parameter string: String to search for
    /// - Returns: true if contains the string
    ///
    /// Example:
    /// ```swift
    /// "Hello World".containsIgnoringCase("world") // true
    /// ```
    func containsIgnoringCase(_ string: String) -> Bool {
        localizedCaseInsensitiveContains(string)
    }
    
    /// Replace multiple occurrences at once
    /// - Parameter replacements: Dictionary of [old: new] strings
    /// - Returns: String with all replacements applied
    ///
    /// Example:
    /// ```swift
    /// "Hello World".replacing(["Hello": "Hi", "World": "There"]) // "Hi There"
    /// ```
    func replacing(_ replacements: [String: String]) -> String {
        var result = self
        for (old, new) in replacements {
            result = result.replacingOccurrences(of: old, with: new)
        }
        return result
    }
}

// MARK: - Optional String Extensions

extension Optional where Wrapped == String {
    
    /// Check if optional string is nil or empty
    /// - Returns: true if nil or empty
    ///
    /// Example:
    /// ```swift
    /// var str: String? = nil
    /// str.isNilOrEmpty // true
    /// str = ""
    /// str.isNilOrEmpty // true
    /// ```
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    /// Unwrap optional string or return empty string
    /// - Returns: String value or empty string
    ///
    /// Example:
    /// ```swift
    /// var str: String? = nil
    /// str.orEmpty // ""
    /// ```
    var orEmpty: String {
        self ?? ""
    }
}

//
//  Collection+Extensions.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Collection Extensions

extension Collection {
    
    /// Check if collection is not empty
    /// - Returns: true if collection has elements
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 3].isNotEmpty // true
    /// [].isNotEmpty // false
    /// ```
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    /// Safe subscript access
    /// - Parameter index: Index to access
    /// - Returns: Element at index or nil if out of bounds
    ///
    /// Example:
    /// ```swift
    /// let array = [1, 2, 3]
    /// array[safe: 1] // 2
    /// array[safe: 10] // nil
    /// ```
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Array Extensions

extension Array {
    
    /// Remove duplicates while preserving order
    /// - Returns: Array with duplicates removed
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 2, 3, 1].removeDuplicates() // [1, 2, 3]
    /// ```
    func removeDuplicates<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
    
    /// Chunk array into smaller arrays of specified size
    /// - Parameter size: Size of each chunk
    /// - Returns: Array of arrays
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 3, 4, 5].chunked(into: 2) // [[1, 2], [3, 4], [5]]
    /// ```
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element: Hashable {
    
    /// Remove duplicates (for Hashable elements)
    /// - Returns: Array with duplicates removed
    ///
    /// Example:
    /// ```swift
    /// [1, 2, 2, 3, 1].removeDuplicates() // [1, 2, 3]
    /// ```
    func removeDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

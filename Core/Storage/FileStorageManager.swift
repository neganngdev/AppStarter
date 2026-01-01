//
//  FileStorageManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation
import UIKit

// MARK: - File Storage Error

/// Errors that can occur during file storage operations
enum FileStorageError: Error, LocalizedError {
    case fileNotFound
    case invalidDirectory
    case encodingFailed
    case decodingFailed
    case saveFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found"
        case .invalidDirectory:
            return "Invalid directory path"
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        case .saveFailed:
            return "Failed to save file"
        case .deleteFailed:
            return "Failed to delete file"
        }
    }
}

// MARK: - File Storage Manager

/// Thread-safe file storage manager for Documents directory
actor FileStorageManager {
    
    // MARK: - Singleton
    
    static let shared = FileStorageManager()
    
    private let fileManager = FileManager.default
    
    private init() {}
    
    // MARK: - Directory Paths
    
    /// Documents directory URL
    var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Caches directory URL
    var cachesDirectory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    /// Temporary directory URL
    var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }
    
    /// Get URL for file in Documents directory
    /// - Parameter filename: Name of the file
    /// - Returns: Full URL to the file
    func fileURL(for filename: String) -> URL {
        documentsDirectory.appendingPathComponent(filename)
    }
    
    // MARK: - Codable Operations
    
    /// Save Codable object to file
    /// - Parameters:
    ///   - object: Codable object to save
    ///   - filename: Name of the file
    ///   - directory: Directory to save to (default: Documents)
    /// - Throws: FileStorageError or encoding error
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable { let name: String }
    /// try await FileStorageManager.shared.save(user, filename: "user.json")
    /// ```
    func save<T: Codable>(
        _ object: T,
        filename: String,
        directory: URL? = nil
    ) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(object) else {
            throw FileStorageError.encodingFailed
        }
        
        let url = (directory ?? documentsDirectory).appendingPathComponent(filename)
        
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw FileStorageError.saveFailed
        }
    }
    
    /// Load Codable object from file
    /// - Parameters:
    ///   - filename: Name of the file
    ///   - type: Type of object to decode
    ///   - directory: Directory to load from (default: Documents)
    /// - Returns: Decoded object
    /// - Throws: FileStorageError or decoding error
    ///
    /// Example:
    /// ```swift
    /// let user: User = try await FileStorageManager.shared.load("user.json")
    /// ```
    func load<T: Codable>(
        _ filename: String,
        as type: T.Type = T.self,
        from directory: URL? = nil
    ) throws -> T {
        let url = (directory ?? documentsDirectory).appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw FileStorageError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw FileStorageError.decodingFailed
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw FileStorageError.decodingFailed
        }
    }
    
    // MARK: - Image Operations
    
    /// Save image to file
    /// - Parameters:
    ///   - image: UIImage to save
    ///   - filename: Name of the file (should include .jpg or .png extension)
    ///   - compressionQuality: JPEG compression quality (0-1), default 0.8
    /// - Throws: FileStorageError
    ///
    /// Example:
    /// ```swift
    /// try await FileStorageManager.shared.saveImage(profileImage, filename: "profile.jpg")
    /// ```
    func saveImage(
        _ image: UIImage,
        filename: String,
        compressionQuality: CGFloat = 0.8
    ) throws {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        let data: Data?
        if filename.lowercased().hasSuffix(".png") {
            data = image.pngData()
        } else {
            data = image.jpegData(compressionQuality: compressionQuality)
        }
        
        guard let imageData = data else {
            throw FileStorageError.encodingFailed
        }
        
        do {
            try imageData.write(to: url, options: .atomic)
        } catch {
            throw FileStorageError.saveFailed
        }
    }
    
    /// Load image from file
    /// - Parameter filename: Name of the file
    /// - Returns: UIImage
    /// - Throws: FileStorageError
    ///
    /// Example:
    /// ```swift
    /// let image = try await FileStorageManager.shared.loadImage("profile.jpg")
    /// ```
    func loadImage(_ filename: String) throws -> UIImage {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw FileStorageError.fileNotFound
        }
        
        guard let image = UIImage(contentsOfFile: url.path) else {
            throw FileStorageError.decodingFailed
        }
        
        return image
    }
    
    // MARK: - Data Operations
    
    /// Save raw data to file
    /// - Parameters:
    ///   - data: Data to save
    ///   - filename: Name of the file
    /// - Throws: FileStorageError
    func saveData(_ data: Data, filename: String) throws {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw FileStorageError.saveFailed
        }
    }
    
    /// Load raw data from file
    /// - Parameter filename: Name of the file
    /// - Returns: Data
    /// - Throws: FileStorageError
    func loadData(_ filename: String) throws -> Data {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw FileStorageError.fileNotFound
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw FileStorageError.decodingFailed
        }
    }
    
    // MARK: - File Management
    
    /// Check if file exists
    /// - Parameter filename: Name of the file
    /// - Returns: true if file exists
    func fileExists(_ filename: String) -> Bool {
        let url = documentsDirectory.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: url.path)
    }
    
    /// Delete file
    /// - Parameter filename: Name of the file
    /// - Throws: FileStorageError
    ///
    /// Example:
    /// ```swift
    /// try await FileStorageManager.shared.deleteFile("old_data.json")
    /// ```
    func deleteFile(_ filename: String) throws {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw FileStorageError.fileNotFound
        }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw FileStorageError.deleteFailed
        }
    }
    
    /// List all files in Documents directory
    /// - Returns: Array of filenames
    func listFiles() throws -> [String] {
        do {
            return try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
        } catch {
            return []
        }
    }
    
    /// Get file size
    /// - Parameter filename: Name of the file
    /// - Returns: File size in bytes
    func fileSize(_ filename: String) -> Int64? {
        let url = documentsDirectory.appendingPathComponent(filename)
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? Int64 else {
            return nil
        }
        
        return size
    }
    
    /// Get total size of all files in Documents directory
    /// - Returns: Total size in bytes
    func totalStorageSize() -> Int64 {
        guard let files = try? listFiles() else { return 0 }
        
        return files.reduce(0) { total, filename in
            total + (fileSize(filename) ?? 0)
        }
    }
    
    /// Clear all files from Documents directory
    /// - Throws: FileStorageError
    func clearAll() throws {
        guard let files = try? listFiles() else { return }
        
        for filename in files {
            try? deleteFile(filename)
        }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Save and load Codable objects:
 
 ```swift
 struct TodoList: Codable {
     var items: [String]
 }
 
 // Save
 Task {
     let todos = TodoList(items: ["Buy milk", "Walk dog"])
     try await FileStorageManager.shared.save(todos, filename: "todos.json")
 }
 
 // Load
 Task {
     let todos: TodoList = try await FileStorageManager.shared.load("todos.json")
     print(todos.items)
 }
 ```
 
 2. Save and load images:
 
 ```swift
 // Save
 Task {
     try await FileStorageManager.shared.saveImage(profileImage, filename: "profile.jpg")
 }
 
 // Load
 Task {
     let image = try await FileStorageManager.shared.loadImage("profile.jpg")
 }
 ```
 
 3. File management:
 
 ```swift
 Task {
     // Check if file exists
     let exists = await FileStorageManager.shared.fileExists("data.json")
     
     // List all files
     let files = try await FileStorageManager.shared.listFiles()
     
     // Get file size
     if let size = await FileStorageManager.shared.fileSize("data.json") {
         print("File size: \(size) bytes")
     }
     
     // Delete file
     try await FileStorageManager.shared.deleteFile("old_data.json")
     
     // Clear all files
     try await FileStorageManager.shared.clearAll()
 }
 ```
 
 4. Error handling:
 
 ```swift
 Task {
     do {
         let data: MyData = try await FileStorageManager.shared.load("data.json")
     } catch FileStorageError.fileNotFound {
         print("File not found, using defaults")
     } catch FileStorageError.decodingFailed {
         print("Failed to decode file")
     } catch {
         print("Error: \(error.localizedDescription)")
     }
 }
 ```
 
 5. Custom directory:
 
 ```swift
 Task {
     let cacheDir = await FileStorageManager.shared.cachesDirectory
     try await FileStorageManager.shared.save(data, filename: "cache.json", directory: cacheDir)
 }
 ```
 
 */

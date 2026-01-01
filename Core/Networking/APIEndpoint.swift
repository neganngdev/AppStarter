//
//  APIEndpoint.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - HTTP Method

/// HTTP request methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - API Endpoint Protocol

/// Protocol for defining type-safe API endpoints
///
/// Example:
/// ```swift
/// struct GetUserEndpoint: APIEndpoint {
///     typealias Response = User
///     let userID: String
///
///     var path: String { "/users/\(userID)" }
///     var method: HTTPMethod { .get }
/// }
/// ```
protocol APIEndpoint {
    associatedtype Response: Decodable
    
    /// API path (e.g., "/users/123")
    var path: String { get }
    
    /// HTTP method
    var method: HTTPMethod { get }
    
    /// Query parameters
    var queryItems: [URLQueryItem]? { get }
    
    /// HTTP headers
    var headers: [String: String]? { get }
    
    /// Request body (for POST, PUT, PATCH)
    var body: Encodable? { get }
    
    /// Request timeout interval
    var timeout: TimeInterval { get }
}

// MARK: - Default Implementations

extension APIEndpoint {
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
    var body: Encodable? { nil }
    var timeout: TimeInterval { 30 }
}

// MARK: - Example Endpoints

/// Example: Get user by ID
struct GetUserEndpoint: APIEndpoint {
    typealias Response = User
    
    let userID: String
    
    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .get }
}

/// Example: Get list of users
struct GetUsersEndpoint: APIEndpoint {
    typealias Response = [User]
    
    let page: Int
    let limit: Int
    
    var path: String { "/users" }
    var method: HTTPMethod { .get }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    }
}

/// Example: Create user
struct CreateUserEndpoint: APIEndpoint {
    typealias Response = User
    
    let user: User
    
    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var body: Encodable? { user }
}

/// Example: Update user
struct UpdateUserEndpoint: APIEndpoint {
    typealias Response = User
    
    let userID: String
    let user: User
    
    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .put }
    var body: Encodable? { user }
}

/// Example: Delete user
struct DeleteUserEndpoint: APIEndpoint {
    typealias Response = EmptyResponse
    
    let userID: String
    
    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .delete }
}

// MARK: - Supporting Types

/// Example User model
struct User: Codable {
    let id: String
    let name: String
    let email: String
}

/// Empty response for endpoints that don't return data
struct EmptyResponse: Codable {}

// MARK: - Endpoint Builder

/// Helper to build endpoints with common patterns
struct EndpointBuilder {
    
    /// Build GET endpoint
    static func get<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem]? = nil
    ) -> AnyEndpoint<T> {
        AnyEndpoint(
            path: path,
            method: .get,
            queryItems: queryItems
        )
    }
    
    /// Build POST endpoint
    static func post<T: Decodable>(
        _ path: String,
        body: Encodable
    ) -> AnyEndpoint<T> {
        AnyEndpoint(
            path: path,
            method: .post,
            body: body
        )
    }
    
    /// Build PUT endpoint
    static func put<T: Decodable>(
        _ path: String,
        body: Encodable
    ) -> AnyEndpoint<T> {
        AnyEndpoint(
            path: path,
            method: .put,
            body: body
        )
    }
    
    /// Build DELETE endpoint
    static func delete<T: Decodable>(
        _ path: String
    ) -> AnyEndpoint<T> {
        AnyEndpoint(
            path: path,
            method: .delete
        )
    }
}

// MARK: - Type-Erased Endpoint

/// Type-erased endpoint wrapper
struct AnyEndpoint<T: Decodable>: APIEndpoint {
    typealias Response = T
    
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?
    let body: Encodable?
    let timeout: TimeInterval
    
    init(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        body: Encodable? = nil,
        timeout: TimeInterval = 30
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }
}

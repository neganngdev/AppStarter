//
//  NetworkManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Network Manager

/// Thread-safe network manager for API calls
/// Uses async/await for modern Swift concurrency
actor NetworkManager {
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Properties
    
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // MARK: - Initialization
    
    init(
        baseURL: URL? = nil,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        // CUSTOMIZE: Set your API base URL
        self.baseURL = baseURL ?? URL(string: Environment.current.apiBaseURL.absoluteString)!
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        
        // Configure decoder for common date formats
        decoder.dateDecodingStrategy = .iso8601
        
        // Configure encoder
        encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - Generic Request
    
    /// Perform generic API request
    /// - Parameter endpoint: API endpoint conforming to APIEndpoint protocol
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    ///
    /// Example:
    /// ```swift
    /// let user: User = try await NetworkManager.shared.request(GetUserEndpoint(userID: "123"))
    /// ```
    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response {
        let request = try buildRequest(from: endpoint)
        
        if Environment.current.logNetworkRequests {
            logRequest(request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        if Environment.current.logNetworkRequests {
            logResponse(data, response: response)
        }
        
        try validateResponse(response)
        
        do {
            return try decoder.decode(T.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Convenience Methods
    
    /// Perform GET request
    /// - Parameters:
    ///   - path: API path
    ///   - queryItems: Optional query parameters
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    ///
    /// Example:
    /// ```swift
    /// let user: User = try await NetworkManager.shared.get("/users/123")
    /// ```
    func get<T: Decodable>(
        _ path: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        let endpoint = AnyEndpoint<T>(
            path: path,
            method: .get,
            queryItems: queryItems
        )
        return try await request(endpoint)
    }
    
    /// Perform POST request
    /// - Parameters:
    ///   - path: API path
    ///   - body: Request body (Encodable)
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    ///
    /// Example:
    /// ```swift
    /// let user: User = try await NetworkManager.shared.post("/users", body: newUser)
    /// ```
    func post<T: Decodable, B: Encodable>(
        _ path: String,
        body: B
    ) async throws -> T {
        let endpoint = AnyEndpoint<T>(
            path: path,
            method: .post,
            body: body
        )
        return try await request(endpoint)
    }
    
    /// Perform PUT request
    /// - Parameters:
    ///   - path: API path
    ///   - body: Request body (Encodable)
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    ///
    /// Example:
    /// ```swift
    /// let user: User = try await NetworkManager.shared.put("/users/123", body: updatedUser)
    /// ```
    func put<T: Decodable, B: Encodable>(
        _ path: String,
        body: B
    ) async throws -> T {
        let endpoint = AnyEndpoint<T>(
            path: path,
            method: .put,
            body: body
        )
        return try await request(endpoint)
    }
    
    /// Perform PATCH request
    /// - Parameters:
    ///   - path: API path
    ///   - body: Request body (Encodable)
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    func patch<T: Decodable, B: Encodable>(
        _ path: String,
        body: B
    ) async throws -> T {
        let endpoint = AnyEndpoint<T>(
            path: path,
            method: .patch,
            body: body
        )
        return try await request(endpoint)
    }
    
    /// Perform DELETE request
    /// - Parameter path: API path
    /// - Returns: Decoded response
    /// - Throws: NetworkError
    ///
    /// Example:
    /// ```swift
    /// try await NetworkManager.shared.delete("/users/123")
    /// ```
    func delete<T: Decodable>(_ path: String) async throws -> T {
        let endpoint = AnyEndpoint<T>(
            path: path,
            method: .delete
        )
        return try await request(endpoint)
    }
    
    /// Perform DELETE request without response
    /// - Parameter path: API path
    /// - Throws: NetworkError
    func delete(_ path: String) async throws {
        let _: EmptyResponse = try await delete(path)
    }
    
    // MARK: - Request Building
    
    /// Build URLRequest from endpoint
    private func buildRequest<T: APIEndpoint>(from endpoint: T) throws -> URLRequest {
        // Build URL
        var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: true
        )
        
        // Add query items
        if let queryItems = endpoint.queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeout
        
        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add authentication header if available
        if let authToken = try? await getAuthToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body
        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        return request
    }
    
    // MARK: - Response Validation
    
    /// Validate HTTP response
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 408:
            throw NetworkError.timeout
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Authentication
    
    /// Get authentication token from secure storage
    private func getAuthToken() async throws -> String? {
        try await SecureStorage.getAuthToken()
    }
    
    // MARK: - Logging
    
    /// Log network request (debug only)
    private func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("🌐 [Network Request]")
        print("   URL: \(request.url?.absoluteString ?? "N/A")")
        print("   Method: \(request.httpMethod ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("   Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("   Body: \(bodyString)")
        }
        #endif
    }
    
    /// Log network response (debug only)
    private func logResponse(_ data: Data, response: URLResponse) {
        #if DEBUG
        print("📡 [Network Response]")
        if let httpResponse = response as? HTTPURLResponse {
            print("   Status: \(httpResponse.statusCode)")
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("   Data: \(responseString)")
        }
        #endif
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Simple GET request:
 
 ```swift
 Task {
     do {
         let user: User = try await NetworkManager.shared.get("/users/123")
         print("User: \(user.name)")
     } catch {
         print("Error: \(error.localizedDescription)")
     }
 }
 ```
 
 2. POST request with body:
 
 ```swift
 Task {
     let newUser = User(id: "", name: "John", email: "john@example.com")
     let createdUser: User = try await NetworkManager.shared.post("/users", body: newUser)
 }
 ```
 
 3. Using typed endpoints:
 
 ```swift
 Task {
     let endpoint = GetUserEndpoint(userID: "123")
     let user = try await NetworkManager.shared.request(endpoint)
 }
 ```
 
 4. GET with query parameters:
 
 ```swift
 Task {
     let queryItems = [
         URLQueryItem(name: "page", value: "1"),
         URLQueryItem(name: "limit", value: "10")
     ]
     let users: [User] = try await NetworkManager.shared.get("/users", queryItems: queryItems)
 }
 ```
 
 5. Error handling:
 
 ```swift
 Task {
     do {
         let user: User = try await NetworkManager.shared.get("/users/123")
     } catch NetworkError.unauthorized {
         // Handle unauthorized - redirect to login
     } catch NetworkError.noInternet {
         // Show no internet message
     } catch {
         // Handle other errors
         print(error.localizedDescription)
     }
 }
 ```
 
 6. DELETE request:
 
 ```swift
 Task {
     try await NetworkManager.shared.delete("/users/123")
     print("User deleted")
 }
 ```
 
 7. In a ViewModel:
 
 ```swift
 @MainActor
 class UserViewModel: ObservableObject {
     @Published var user: User?
     @Published var isLoading = false
     @Published var errorMessage: String?
     
     func fetchUser(id: String) {
         isLoading = true
         Task {
             do {
                 user = try await NetworkManager.shared.get("/users/\(id)")
                 isLoading = false
             } catch let error as NetworkError {
                 errorMessage = error.userMessage
                 isLoading = false
             }
         }
     }
 }
 ```
 
 */

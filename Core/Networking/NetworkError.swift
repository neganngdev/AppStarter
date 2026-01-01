//
//  NetworkError.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Network Error

/// Errors that can occur during network operations
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case timeout
    case serverError(statusCode: Int)
    case unauthorized
    case forbidden
    case notFound
    case decodingError(Error)
    case encodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternet:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. Please try again."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        case .unauthorized:
            return "Unauthorized. Please log in again."
        case .forbidden:
            return "Access forbidden. You don't have permission to access this resource."
        case .notFound:
            return "Resource not found."
        case .decodingError:
            return "Failed to decode response. Please try again."
        case .encodingError:
            return "Failed to encode request. Please try again."
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
    
    /// User-friendly error message
    var userMessage: String {
        switch self {
        case .noInternet:
            return "Please check your internet connection and try again."
        case .timeout:
            return "The request took too long. Please try again."
        case .serverError:
            return "Something went wrong on our end. Please try again later."
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .forbidden:
            return "You don't have access to this content."
        case .notFound:
            return "The requested content could not be found."
        case .decodingError, .encodingError:
            return "Something went wrong. Please try again."
        default:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    /// HTTP status code if applicable
    var statusCode: Int? {
        switch self {
        case .serverError(let code):
            return code
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        default:
            return nil
        }
    }
    
    /// Check if error is recoverable
    var isRecoverable: Bool {
        switch self {
        case .noInternet, .timeout, .serverError:
            return true
        case .unauthorized, .forbidden, .notFound:
            return false
        default:
            return true
        }
    }
}

// MARK: - HTTP Status Code Extension

extension NetworkError {
    
    /// Create NetworkError from HTTP status code
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Appropriate NetworkError
    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 200...299:
            return .unknown(NSError(domain: "Success", code: statusCode))
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 408:
            return .timeout
        case 400...499:
            return .serverError(statusCode: statusCode)
        case 500...599:
            return .serverError(statusCode: statusCode)
        default:
            return .serverError(statusCode: statusCode)
        }
    }
}

// MARK: - URLError Extension

extension NetworkError {
    
    /// Create NetworkError from URLError
    /// - Parameter urlError: URLError from URLSession
    /// - Returns: Appropriate NetworkError
    static func from(urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cannotFindHost, .cannotConnectToHost:
            return .serverError(statusCode: 503)
        default:
            return .unknown(urlError)
        }
    }
}

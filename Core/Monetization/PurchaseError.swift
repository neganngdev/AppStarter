//
//  PurchaseError.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Purchase Error

/// Errors that can occur during purchase operations
enum PurchaseError: Error, LocalizedError {
    case notConfigured
    case cancelled
    case networkError
    case productNotFound
    case purchaseFailed(reason: String)
    case restoreFailed
    case receiptInvalid
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Purchase manager not configured. Call configure() first."
        case .cancelled:
            return "Purchase was cancelled"
        case .networkError:
            return "Network error occurred. Please check your connection."
        case .productNotFound:
            return "Product not found. Please try again later."
        case .purchaseFailed(let reason):
            return "Purchase failed: \(reason)"
        case .restoreFailed:
            return "Failed to restore purchases"
        case .receiptInvalid:
            return "Receipt validation failed"
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
    
    /// User-friendly error message for UI
    var userMessage: String {
        switch self {
        case .notConfigured:
            return "Something went wrong. Please restart the app."
        case .cancelled:
            return "You cancelled the purchase."
        case .networkError:
            return "Please check your internet connection and try again."
        case .productNotFound:
            return "This product is currently unavailable. Please try again later."
        case .purchaseFailed:
            return "We couldn't complete your purchase. Please try again."
        case .restoreFailed:
            return "We couldn't restore your purchases. Please try again."
        case .receiptInvalid:
            return "There was a problem verifying your purchase. Please contact support."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
    
    /// Whether the error is recoverable (user can retry)
    var isRecoverable: Bool {
        switch self {
        case .cancelled, .notConfigured, .receiptInvalid:
            return false
        case .networkError, .productNotFound, .purchaseFailed, .restoreFailed, .unknown:
            return true
        }
    }
}

// MARK: - Purchase Result

/// Result of a purchase operation
enum PurchaseResult {
    case success(productID: String)
    case restored
    case pending
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

//
//  SubscriptionStatus.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Subscription Status

/// Represents the current subscription status of the user
enum SubscriptionStatus: Equatable {
    /// User has an active subscription
    case active(expirationDate: Date?)
    
    /// User is in free trial period
    case trial(expirationDate: Date)
    
    /// User is in grace period (payment issue but still has access)
    case gracePeriod(expirationDate: Date)
    
    /// Subscription has expired
    case expired(expirationDate: Date?)
    
    /// No subscription
    case none
    
    // MARK: - Computed Properties
    
    /// Check if user has active premium access
    var isActive: Bool {
        switch self {
        case .active, .trial, .gracePeriod:
            return true
        case .expired, .none:
            return false
        }
    }
    
    /// Check if user is premium (has active subscription or trial)
    var isPremium: Bool {
        isActive
    }
    
    /// Check if user is in trial period
    var isTrial: Bool {
        if case .trial = self {
            return true
        }
        return false
    }
    
    /// Check if user is in grace period
    var isGracePeriod: Bool {
        if case .gracePeriod = self {
            return true
        }
        return false
    }
    
    /// Get expiration date if available
    var expirationDate: Date? {
        switch self {
        case .active(let date), .expired(let date):
            return date
        case .trial(let date), .gracePeriod(let date):
            return date
        case .none:
            return nil
        }
    }
    
    /// Days until expiration (nil if no expiration or already expired)
    var daysUntilExpiration: Int? {
        guard let expirationDate = expirationDate else { return nil }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: expirationDate).day
        return days
    }
    
    /// User-friendly status description
    var description: String {
        switch self {
        case .active:
            return "Active Subscription"
        case .trial:
            return "Free Trial"
        case .gracePeriod:
            return "Grace Period"
        case .expired:
            return "Expired"
        case .none:
            return "No Subscription"
        }
    }
    
    /// Detailed status message for UI
    var detailMessage: String {
        switch self {
        case .active(let date):
            if let date = date {
                return "Your subscription is active until \(date.formatted(style: .medium))"
            }
            return "Your subscription is active"
        case .trial(let date):
            let days = daysUntilExpiration ?? 0
            return "Your free trial ends in \(days) day\(days == 1 ? "" : "s")"
        case .gracePeriod(let date):
            return "Please update your payment method. Access expires \(date.formatted(style: .medium))"
        case .expired(let date):
            if let date = date {
                return "Your subscription expired on \(date.formatted(style: .medium))"
            }
            return "Your subscription has expired"
        case .none:
            return "You don't have an active subscription"
        }
    }
}

// MARK: - Subscription Tier

/// Represents different subscription tiers
enum SubscriptionTier: String, CaseIterable {
    case free = "free"
    case monthly = "monthly"
    case yearly = "yearly"
    case lifetime = "lifetime"
    
    var displayName: String {
        switch self {
        case .free:
            return "Free"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .lifetime:
            return "Lifetime"
        }
    }
    
    var isPremium: Bool {
        self != .free
    }
}

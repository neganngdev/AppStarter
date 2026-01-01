//
//  Offering.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Offering

/// Wrapper for subscription offering/product
struct Offering: Identifiable {
    let id: String
    let identifier: String
    let title: String
    let description: String
    let price: Decimal
    let priceString: String
    let currencyCode: String
    let duration: SubscriptionDuration
    let isTrial: Bool
    let trialDuration: SubscriptionDuration?
    
    /// Localized price with currency
    var localizedPrice: String {
        priceString
    }
    
    /// Price per month (for comparison)
    var pricePerMonth: Decimal {
        switch duration {
        case .monthly:
            return price
        case .yearly:
            return price / 12
        case .lifetime:
            return price / 120 // Assume 10 years
        case .weekly:
            return price * 4
        case .custom:
            return price
        }
    }
    
    /// Savings compared to monthly (for yearly plans)
    func savings(comparedTo monthly: Offering) -> Decimal? {
        guard duration == .yearly else { return nil }
        let yearlyAsMonthly = monthly.price * 12
        return yearlyAsMonthly - price
    }
    
    /// Savings percentage
    func savingsPercentage(comparedTo monthly: Offering) -> Int? {
        guard let savings = savings(comparedTo: monthly) else { return nil }
        let yearlyAsMonthly = monthly.price * 12
        let percentage = (savings / yearlyAsMonthly) * 100
        return Int(truncating: percentage as NSNumber)
    }
}

// MARK: - Subscription Duration

/// Duration of subscription
enum SubscriptionDuration: Equatable {
    case weekly
    case monthly
    case yearly
    case lifetime
    case custom(months: Int)
    
    var displayName: String {
        switch self {
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .lifetime:
            return "Lifetime"
        case .custom(let months):
            return "\(months) Months"
        }
    }
    
    var shortName: String {
        switch self {
        case .weekly:
            return "week"
        case .monthly:
            return "month"
        case .yearly:
            return "year"
        case .lifetime:
            return "lifetime"
        case .custom(let months):
            return "\(months)mo"
        }
    }
}

// MARK: - Package Type

/// Common package types for offerings
enum PackageType: String {
    case monthly = "monthly"
    case yearly = "annual"
    case lifetime = "lifetime"
    case weekly = "weekly"
    case custom = "custom"
}

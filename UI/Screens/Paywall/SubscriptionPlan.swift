//
//  SubscriptionPlan.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Subscription Plan

/// Model representing a subscription plan for display
struct SubscriptionPlan: Identifiable, Equatable {
    let id: String
    let name: String
    let price: String
    let period: String
    let features: [String]
    let isPopular: Bool
    let trialDays: Int?
    let savingsText: String?
    
    init(
        id: String,
        name: String,
        price: String,
        period: String,
        features: [String] = [],
        isPopular: Bool = false,
        trialDays: Int? = nil,
        savingsText: String? = nil
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.period = period
        self.features = features
        self.isPopular = isPopular
        self.trialDays = trialDays
        self.savingsText = savingsText
    }
    
    /// Display text for trial
    var trialText: String? {
        guard let days = trialDays else { return nil }
        return "\(days)-day free trial"
    }
    
    /// Full price display
    var priceDisplay: String {
        "\(price)/\(period)"
    }
}

// MARK: - Sample Plans

extension SubscriptionPlan {
    
    /// Sample subscription plans for preview/testing
    static let samplePlans: [SubscriptionPlan] = [
        SubscriptionPlan(
            id: "monthly",
            name: "Monthly",
            price: "$9.99",
            period: "month",
            features: commonFeatures,
            isPopular: false,
            trialDays: 7
        ),
        SubscriptionPlan(
            id: "yearly",
            name: "Yearly",
            price: "$79.99",
            period: "year",
            features: commonFeatures + ["Priority support"],
            isPopular: true,
            savingsText: "Save 33%"
        ),
        SubscriptionPlan(
            id: "lifetime",
            name: "Lifetime",
            price: "$199.99",
            period: "one-time",
            features: commonFeatures + ["Priority support", "Lifetime updates"],
            isPopular: false
        )
    ]
    
    /// Common features across plans
    static let commonFeatures = [
        "Unlimited access to all features",
        "Ad-free experience",
        "Sync across all devices",
        "Premium content library",
        "Advanced analytics"
    ]
    
    /// Minimal plans (2 options)
    static let minimalPlans: [SubscriptionPlan] = [
        SubscriptionPlan(
            id: "monthly",
            name: "Monthly",
            price: "$4.99",
            period: "month",
            features: ["All premium features", "Cancel anytime"],
            isPopular: false,
            trialDays: 3
        ),
        SubscriptionPlan(
            id: "yearly",
            name: "Yearly",
            price: "$39.99",
            period: "year",
            features: ["All premium features", "Best value", "Cancel anytime"],
            isPopular: true,
            savingsText: "Save 33%"
        )
    ]
}

// MARK: - Conversion from Offering

extension SubscriptionPlan {
    
    /// Create SubscriptionPlan from Offering
    /// - Parameter offering: Offering from PurchaseManager
    /// - Returns: SubscriptionPlan for display
    static func from(offering: Offering) -> SubscriptionPlan {
        let savingsText: String?
        if offering.duration == .yearly {
            // Calculate savings percentage
            savingsText = "Save 33%" // Calculate from actual prices
        } else {
            savingsText = nil
        }
        
        return SubscriptionPlan(
            id: offering.identifier,
            name: offering.title,
            price: offering.priceString,
            period: offering.duration.shortName,
            features: SubscriptionPlan.commonFeatures,
            isPopular: offering.duration == .yearly,
            trialDays: offering.isTrial ? 7 : nil,
            savingsText: savingsText
        )
    }
}

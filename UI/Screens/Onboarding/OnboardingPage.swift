//
//  OnboardingPage.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Onboarding Page

/// Model representing a single onboarding page
struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let backgroundColor: Color?
    
    init(
        icon: String,
        title: String,
        description: String,
        backgroundColor: Color? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Sample Pages

extension OnboardingPage {
    
    /// Sample onboarding pages for preview/testing
    static let samplePages: [OnboardingPage] = [
        OnboardingPage(
            icon: "star.fill",
            title: "Welcome",
            description: "Welcome to AppStarter! Let's get you started with a quick tour of what makes this app special."
        ),
        OnboardingPage(
            icon: "bell.fill",
            title: "Stay Updated",
            description: "Get instant notifications about important updates and never miss what matters to you."
        ),
        OnboardingPage(
            icon: "lock.shield.fill",
            title: "Secure & Private",
            description: "Your data is encrypted and secure. We respect your privacy and never share your information."
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            title: "Ready to Go",
            description: "You're all set! Tap 'Get Started' to begin your journey with us."
        )
    ]
    
    /// Minimal onboarding pages (3 pages)
    static let minimalPages: [OnboardingPage] = [
        OnboardingPage(
            icon: "hand.wave.fill",
            title: "Hello!",
            description: "Welcome to the app. Let's show you around."
        ),
        OnboardingPage(
            icon: "sparkles",
            title: "Discover Features",
            description: "Explore powerful features designed just for you."
        ),
        OnboardingPage(
            icon: "rocket.fill",
            title: "Let's Begin",
            description: "Ready to get started? Let's go!"
        )
    ]
    
    /// Premium feature onboarding
    static let premiumPages: [OnboardingPage] = [
        OnboardingPage(
            icon: "crown.fill",
            title: "Go Premium",
            description: "Unlock all features with a premium subscription."
        ),
        OnboardingPage(
            icon: "infinity",
            title: "Unlimited Access",
            description: "Get unlimited access to all premium content and features."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Ad-Free Experience",
            description: "Enjoy an ad-free experience and support our development."
        )
    ]
}

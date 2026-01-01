//
//  OnboardingView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Onboarding View

/// Complete onboarding flow with pages, navigation, and completion
struct OnboardingView: View {
    
    // MARK: - Properties
    
    let pages: [OnboardingPage]
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    // MARK: - Computed Properties
    
    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    private var buttonTitle: String {
        isLastPage ? "Get Started" : "Continue"
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    
                    if !isLastPage {
                        Button("Skip") {
                            withAnimation {
                                onComplete()
                            }
                        }
                        .font(.appBody)
                        .foregroundColor(.appSecondaryText)
                        .padding()
                    }
                }
                
                // Pages
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page Indicator
                HStack(spacing: AppSpacing.xSmall) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.appPrimary : Color.appBorder)
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, AppSpacing.large)
                
                // Continue/Get Started Button
                AppButton(
                    buttonTitle,
                    icon: isLastPage ? "checkmark" : "arrow.right",
                    style: .primary,
                    size: .large
                ) {
                    handleContinue()
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.bottom, AppSpacing.xLarge)
            }
        }
        .onAppear {
            // Track onboarding started
            Task {
                await AnalyticsManager.shared.trackOnboardingStarted()
            }
        }
    }
    
    // MARK: - Actions
    
    private func handleContinue() {
        if isLastPage {
            // Complete onboarding
            withAnimation {
                onComplete()
            }
            
            // Track completion
            Task {
                await AnalyticsManager.shared.trackOnboardingCompleted()
            }
        } else {
            // Go to next page
            withAnimation {
                currentPage += 1
            }
        }
    }
}

// MARK: - Minimal Onboarding View

/// Simplified onboarding without skip button
struct MinimalOnboardingView: View {
    let pages: [OnboardingPage]
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Pages
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            
            // Button
            AppButton(
                isLastPage ? "Get Started" : "Next",
                style: .primary,
                size: .large
            ) {
                if isLastPage {
                    onComplete()
                } else {
                    withAnimation {
                        currentPage += 1
                    }
                }
            }
            .padding(.horizontal, AppSpacing.large)
            .padding(.bottom, AppSpacing.xLarge)
        }
        .background(.appBackground)
    }
}

// MARK: - Previews

#Preview("Onboarding Flow") {
    OnboardingView(
        pages: OnboardingPage.samplePages,
        onComplete: {
            print("Onboarding completed")
        }
    )
}

#Preview("Minimal Onboarding") {
    MinimalOnboardingView(
        pages: OnboardingPage.minimalPages,
        onComplete: {
            print("Completed")
        }
    )
}

#Preview("Premium Onboarding") {
    OnboardingView(
        pages: OnboardingPage.premiumPages,
        onComplete: {
            print("Premium onboarding completed")
        }
    )
}

#Preview("Dark Mode") {
    OnboardingView(
        pages: OnboardingPage.samplePages,
        onComplete: { }
    )
    .preferredColorScheme(.dark)
}

//
//  OnboardingPageView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Onboarding Page View

/// Single onboarding page layout
struct OnboardingPageView: View {
    
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: AppSpacing.xxLarge) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 100, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.appPrimary, .appAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, AppSpacing.large)
            
            // Text Content
            VStack(spacing: AppSpacing.medium) {
                Text(page.title)
                    .font(.appLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, AppSpacing.xLarge)
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(page.backgroundColor ?? .appBackground)
    }
}

// MARK: - Alternative Layouts

/// Compact onboarding page (smaller icon, more text)
struct CompactOnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: AppSpacing.xLarge) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 70, weight: .regular))
                .foregroundColor(.appPrimary)
                .padding(.bottom, AppSpacing.medium)
            
            // Text Content
            VStack(spacing: AppSpacing.small) {
                Text(page.title)
                    .font(.appTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appCallout)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, AppSpacing.large)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(page.backgroundColor ?? .appBackground)
    }
}

/// Image-based onboarding page (for custom images)
struct ImageOnboardingPageView: View {
    let page: OnboardingPage
    let imageName: String?
    
    var body: some View {
        VStack(spacing: AppSpacing.xLarge) {
            Spacer()
            
            // Image or Icon
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .padding(.horizontal, AppSpacing.xLarge)
            } else {
                Image(systemName: page.icon)
                    .font(.system(size: 80))
                    .foregroundColor(.appPrimary)
            }
            
            // Text Content
            VStack(spacing: AppSpacing.medium) {
                Text(page.title)
                    .font(.appTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, AppSpacing.large)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(page.backgroundColor ?? .appBackground)
    }
}

// MARK: - Previews

#Preview("Standard Page") {
    OnboardingPageView(page: OnboardingPage.samplePages[0])
}

#Preview("All Sample Pages") {
    TabView {
        ForEach(OnboardingPage.samplePages) { page in
            OnboardingPageView(page: page)
        }
    }
    .tabViewStyle(.page)
}

#Preview("Compact Layout") {
    CompactOnboardingPageView(page: OnboardingPage.samplePages[1])
}

#Preview("Dark Mode") {
    OnboardingPageView(page: OnboardingPage.samplePages[2])
        .preferredColorScheme(.dark)
}

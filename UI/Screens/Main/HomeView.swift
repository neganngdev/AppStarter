//
//  HomeView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Home View

/// Main home screen
/// CUSTOMIZE: Replace with your actual home screen content
struct HomeView: View {
    
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    // Header
                    headerSection
                    
                    // Subscription Status
                    if purchaseManager.subscriptionStatus.isActive {
                        premiumBadge
                    } else {
                        upgradeCard
                    }
                    
                    // Placeholder Content
                    placeholderContent
                    
                    Spacer(minLength: AppSpacing.xxLarge)
                }
                .padding()
            }
            .navigationTitle("Home")
            .background(Color.appBackground)
            .sheet(isPresented: $showPaywall) {
                PaywallView(
                    plans: SubscriptionPlan.samplePlans,
                    onPurchase: { planID in
                        try await purchaseManager.purchase(productID: planID)
                    },
                    onRestore: {
                        try await purchaseManager.restorePurchases()
                    },
                    onDismiss: {
                        showPaywall = false
                    }
                )
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.small) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.appPrimary, Color.appAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Welcome to \(AppConfig.appName)")
                .font(Font.appLargeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Your app is ready to customize")
                .font(Font.appBody)
                .foregroundColor(Color.appSecondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppSpacing.large)
    }
    
    // MARK: - Premium Badge
    
    private var premiumBadge: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: "crown.fill")
                .foregroundColor(Color.appPremium)
            
            VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                Text("Premium Active")
                    .font(Font.appHeadline)
                    .foregroundColor(Color.appText)
                
                Text(purchaseManager.subscriptionStatus.detailMessage)
                    .font(Font.appCaption)
                    .foregroundColor(Color.appSecondaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appPremium.opacity(0.1))
        .cornerRadius(AppRadius.medium)
    }
    
    // MARK: - Upgrade Card
    
    private var upgradeCard: some View {
        AppCard(variant: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.title)
                        .foregroundColor(Color.appPremium)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                        Text("Unlock Premium")
                            .font(Font.appHeadline)
                            .foregroundColor(Color.appText)
                        
                        Text("Get unlimited access to all features")
                            .font(Font.appCaption)
                            .foregroundColor(Color.appSecondaryText)
                    }
                    
                    Spacer()
                }
                
                AppButton("Upgrade Now", style: .primary, size: .large) {
                    showPaywall = true
                }
            }
        }
    }
    
    // MARK: - Placeholder Content
    
    private var placeholderContent: some View {
        VStack(spacing: AppSpacing.large) {
            // Info Card
            AppCard(variant: .outlined) {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color.appInfo)
                        Text("Getting Started")
                            .font(Font.appHeadline)
                    }
                    
                    Text("This is a placeholder home screen. Replace this with your actual app features.")
                        .font(Font.appBody)
                        .foregroundColor(Color.appSecondaryText)
                    
                    Divider()
                        .padding(.vertical, AppSpacing.xSmall)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                        Text("Add your features in:")
                            .font(Font.appCaption)
                            .foregroundColor(Color.appSecondaryText)
                        
                        Text("Features/YourFeature/")
                            .font(Font.appMono)
                            .foregroundColor(Color.appPrimary)
                    }
                }
            }
            
            // Feature Examples
            VStack(spacing: AppSpacing.small) {
                Text("Example Features")
                    .font(Font.appHeadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HomeFeatureRow(
                    icon: "list.bullet",
                    title: "Lists & Collections",
                    description: "Display and manage data"
                )
                
                HomeFeatureRow(
                    icon: "chart.bar.fill",
                    title: "Analytics & Charts",
                    description: "Visualize your data"
                )
                
                HomeFeatureRow(
                    icon: "person.2.fill",
                    title: "Social Features",
                    description: "Connect with others"
                )
            }
        }
    }
}

// MARK: - Home Feature Row

/// Feature row for home screen with icon, title, and description
private struct HomeFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color.appPrimary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                Text(title)
                    .font(Font.appBodyEmphasized)
                    .foregroundColor(Color.appText)
                
                Text(description)
                    .font(Font.appCaption)
                    .foregroundColor(Color.appSecondaryText)
            }
            
            Spacer()
        }
        .padding(AppSpacing.small)
        .background(Color.appSecondaryBackground)
        .cornerRadius(AppRadius.small)
    }
}

// MARK: - Previews

#Preview("Home View") {
    HomeView()
}

#Preview("Home View - Dark Mode") {
    HomeView()
        .preferredColorScheme(.dark)
}

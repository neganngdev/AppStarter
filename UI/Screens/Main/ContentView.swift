//
//  ContentView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Content View

/// Alternative to tab-based navigation
/// Use this if your app doesn't need tabs
/// CUSTOMIZE: Replace with your actual app content
struct ContentView: View {
    
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var showSettings = false
    @State private var showPaywall = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    // Header
                    headerSection
                    
                    // Subscription Status
                    subscriptionSection
                    
                    // Main Content
                    mainContent
                    
                    Spacer(minLength: AppSpacing.xxLarge)
                }
                .padding()
            }
            .navigationTitle(AppConfig.appName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                            .foregroundColor(Color.appPrimary)
                    }
                }
            }
            .background(Color.appBackground)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
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
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.appPrimary, Color.appAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Welcome!")
                .font(Font.appLargeTitle)
                .fontWeight(.bold)
            
            Text("Start building your app features")
                .font(Font.appBody)
                .foregroundColor(Color.appSecondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppSpacing.large)
    }
    
    // MARK: - Subscription Section
    
    private var subscriptionSection: some View {
        Group {
            if purchaseManager.subscriptionStatus.isActive {
                // Premium Badge
                HStack(spacing: AppSpacing.small) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Color.appSuccess)
                    
                    Text("Premium Active")
                        .font(Font.appHeadline)
                        .foregroundColor(Color.appText)
                    
                    Spacer()
                }
                .padding()
                .background(Color.appSuccess.opacity(0.1))
                .cornerRadius(AppRadius.medium)
            } else {
                // Upgrade Card
                AppCard(variant: .elevated) {
                    VStack(spacing: AppSpacing.medium) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(Color.appPremium)
                            Text("Unlock Premium Features")
                                .font(Font.appHeadline)
                            Spacer()
                        }
                        
                        AppButton("Upgrade", style: .primary, size: .large) {
                            showPaywall = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack(spacing: AppSpacing.large) {
            // Instructions
            AppCard(variant: .outlined) {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Label("Getting Started", systemImage: "lightbulb.fill")
                        .font(Font.appHeadline)
                        .foregroundColor(Color.appPrimary)
                    
                    Text("This is a placeholder content view. Replace this with your actual app features.")
                        .font(Font.appBody)
                        .foregroundColor(Color.appSecondaryText)
                    
                    Divider()
                        .padding(.vertical, AppSpacing.xSmall)
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                        Text("Add features in:")
                            .font(Font.appCaption)
                            .foregroundColor(Color.appSecondaryText)
                        
                        Text("Features/YourFeature/")
                            .font(Font.appMono)
                            .foregroundColor(Color.appPrimary)
                    }
                }
            }
            
            // Quick Actions
            VStack(spacing: AppSpacing.small) {
                Text("Quick Actions")
                    .font(Font.appHeadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                quickActionButton(
                    icon: "plus.circle.fill",
                    title: "Add Feature",
                    color: Color.appPrimary
                )
                
                quickActionButton(
                    icon: "square.and.arrow.up",
                    title: "Share App",
                    color: Color.appAccent
                )
                
                quickActionButton(
                    icon: "star.fill",
                    title: "Rate App",
                    color: Color.appPremium
                )
            }
        }
    }
    
    // MARK: - Quick Action Button
    
    private func quickActionButton(icon: String, title: String, color: Color) -> some View {
        Button(action: {
            // Handle action
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(Font.appBody)
                    .foregroundColor(Color.appText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.appTertiaryText)
            }
            .padding()
            .background(Color.appSecondaryBackground)
            .cornerRadius(AppRadius.medium)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Content View") {
    ContentView()
}

#Preview("Content View - Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

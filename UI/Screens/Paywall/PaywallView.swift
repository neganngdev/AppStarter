//
//  PaywallView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Paywall View

/// Main subscription paywall screen
struct PaywallView: View {
    
    // MARK: - Properties
    
    let plans: [SubscriptionPlan]
    let onPurchase: (String) async throws -> Void
    let onRestore: () async throws -> Void
    let onDismiss: () -> Void
    
    @State private var selectedPlanID: String
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    // MARK: - Initialization
    
    init(
        plans: [SubscriptionPlan],
        onPurchase: @escaping (String) async throws -> Void,
        onRestore: @escaping () async throws -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.plans = plans
        self.onPurchase = onPurchase
        self.onRestore = onRestore
        self.onDismiss = onDismiss
        
        // Select popular plan or first plan by default
        _selectedPlanID = State(initialValue: plans.first(where: { $0.isPopular })?.id ?? plans.first?.id ?? "")
    }
    
    // MARK: - Computed Properties
    
    private var selectedPlan: SubscriptionPlan? {
        plans.first { $0.id == selectedPlanID }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    // Header
                    VStack(spacing: AppSpacing.small) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.appPremium, Color.appPrimary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Unlock Premium")
                            .font(Font.appLargeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.appText)
                        
                        Text("Get unlimited access to all features")
                            .font(Font.appBody)
                            .foregroundColor(Color.appSecondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AppSpacing.xxLarge)
                    
                    // Features
                    FeatureList(features: SubscriptionPlan.commonFeatures)
                        .padding(.horizontal, AppSpacing.large)
                    
                    // Plans
                    VStack(spacing: AppSpacing.small) {
                        ForEach(plans) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: plan.id == selectedPlanID
                            ) {
                                selectedPlanID = plan.id
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.large)
                    
                    // Continue Button
                    AppButton(
                        "Continue",
                        style: .primary,
                        size: .large,
                        isLoading: isLoading,
                        isDisabled: isLoading
                    ) {
                        handlePurchase()
                    }
                    .padding(.horizontal, AppSpacing.large)
                    
                    // Restore Button
                    Button("Restore Purchases") {
                        handleRestore()
                    }
                    .font(Font.appBody)
                    .foregroundColor(Color.appSecondaryText)
                    
                    // Terms & Privacy
                    HStack(spacing: AppSpacing.xxSmall) {
                        Button("Terms") {
                            // Open terms
                        }
                        
                        Text("•")
                        
                        Button("Privacy") {
                            // Open privacy
                        }
                    }
                    .font(Font.appCaption)
                    .foregroundColor(Color.appTertiaryText)
                    .padding(.bottom, AppSpacing.large)
                }
            }
            
            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(Color.appSecondaryText)
                            .padding(AppSpacing.small)
                            .background(Color.appSecondaryBackground)
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .background(Color.appBackground)
        .errorBanner(error: errorMessage, isPresented: $showError)
    }
    
    // MARK: - Actions
    
    private func handlePurchase() {
        guard let planID = selectedPlan?.id else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await onPurchase(planID)
                // Success handled by coordinator
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
    
    private func handleRestore() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await onRestore()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isLoading = false
        }
    }
}

// MARK: - Compact Paywall View

/// Compact paywall with horizontal plan selection
struct CompactPaywallView: View {
    let plans: [SubscriptionPlan]
    let onPurchase: (String) async throws -> Void
    let onDismiss: () -> Void
    
    @State private var selectedPlanID: String
    @State private var isLoading = false
    
    init(
        plans: [SubscriptionPlan],
        onPurchase: @escaping (String) async throws -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.plans = plans
        self.onPurchase = onPurchase
        self.onDismiss = onDismiss
        _selectedPlanID = State(initialValue: plans.first(where: { $0.isPopular })?.id ?? plans.first?.id ?? "")
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                    Text("Go Premium")
                        .font(Font.appTitle)
                        .fontWeight(.bold)
                    Text("Unlock all features")
                        .font(Font.appBody)
                        .foregroundColor(Color.appSecondaryText)
                }
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.appSecondaryText)
                }
            }
            .padding()
            
            // Plans
            VStack(spacing: AppSpacing.xSmall) {
                ForEach(plans) { plan in
                    CompactPlanCard(
                        plan: plan,
                        isSelected: plan.id == selectedPlanID
                    ) {
                        selectedPlanID = plan.id
                    }
                }
            }
            .padding(.horizontal)
            
            // Button
            AppButton(
                "Subscribe",
                style: .primary,
                size: .large,
                isLoading: isLoading
            ) {
                Task {
                    isLoading = true
                    try? await onPurchase(selectedPlanID)
                    isLoading = false
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.appBackground)
    }
}

// MARK: - Previews

#Preview("Paywall") {
    PaywallView(
        plans: SubscriptionPlan.samplePlans,
        onPurchase: { planID in
            print("Purchase: \(planID)")
        },
        onRestore: {
            print("Restore")
        },
        onDismiss: {
            print("Dismiss")
        }
    )
}

#Preview("Compact Paywall") {
    CompactPaywallView(
        plans: SubscriptionPlan.minimalPlans,
        onPurchase: { _ in },
        onDismiss: { }
    )
}

#Preview("Dark Mode") {
    PaywallView(
        plans: SubscriptionPlan.samplePlans,
        onPurchase: { _ in },
        onRestore: { },
        onDismiss: { }
    )
    .preferredColorScheme(.dark)
}

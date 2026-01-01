//
//  PaywallCoordinator.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Paywall Coordinator

/// Manages paywall presentation and purchase flow
@MainActor
class PaywallCoordinator: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isPresented = false
    @Published var plans: [SubscriptionPlan] = []
    
    // MARK: - Private Properties
    
    private let purchaseManager = PurchaseManager.shared
    
    // MARK: - Initialization
    
    init() {
        loadPlans()
    }
    
    // MARK: - Public Methods
    
    /// Show paywall
    func show() {
        isPresented = true
        
        // Track paywall shown
        Task {
            await AnalyticsManager.shared.trackEvent("paywall_shown")
        }
    }
    
    /// Dismiss paywall
    func dismiss() {
        isPresented = false
    }
    
    /// Load subscription plans
    func loadPlans() {
        Task {
            let offerings = await purchaseManager.fetchOfferings()
            
            if offerings.isEmpty {
                // Use sample plans for testing
                #if DEBUG
                plans = SubscriptionPlan.samplePlans
                #else
                plans = []
                #endif
            } else {
                // Convert offerings to plans
                plans = offerings.map { SubscriptionPlan.from(offering: $0) }
            }
        }
    }
    
    /// Handle purchase
    /// - Parameter planID: Plan identifier to purchase
    func purchase(planID: String) async throws {
        // Track purchase initiated
        await AnalyticsManager.shared.trackEvent("purchase_initiated", parameters: [
            "plan_id": planID
        ])
        
        do {
            let result = try await purchaseManager.purchase(productID: planID)
            
            if result.isSuccess {
                // Success - dismiss paywall
                dismiss()
                
                // Track success
                await AnalyticsManager.shared.trackEvent("purchase_completed", parameters: [
                    "plan_id": planID
                ])
            }
        } catch {
            // Track failure
            await AnalyticsManager.shared.trackEvent("purchase_failed", parameters: [
                "plan_id": planID,
                "error": error.localizedDescription
            ])
            
            throw error
        }
    }
    
    /// Handle restore purchases
    func restore() async throws {
        // Track restore initiated
        await AnalyticsManager.shared.trackEvent("restore_initiated")
        
        do {
            try await purchaseManager.restorePurchases()
            
            // Check if subscription is now active
            let status = await purchaseManager.checkSubscriptionStatus()
            if status.isActive {
                dismiss()
            }
            
            // Track success
            await AnalyticsManager.shared.trackEvent("restore_completed")
        } catch {
            // Track failure
            await AnalyticsManager.shared.trackEvent("restore_failed", parameters: [
                "error": error.localizedDescription
            ])
            
            throw error
        }
    }
}

// MARK: - Paywall Modifier

struct PaywallModifier: ViewModifier {
    @StateObject private var coordinator = PaywallCoordinator()
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $coordinator.isPresented) {
                PaywallView(
                    plans: coordinator.plans,
                    onPurchase: { planID in
                        try await coordinator.purchase(planID: planID)
                    },
                    onRestore: {
                        try await coordinator.restore()
                    },
                    onDismiss: {
                        coordinator.dismiss()
                    }
                )
            }
            .onChange(of: trigger) { oldValue, newValue in
                if newValue {
                    coordinator.show()
                }
            }
    }
}

extension View {
    /// Show paywall when trigger is true
    /// - Parameter trigger: Binding to control presentation
    /// - Returns: Modified view
    func paywall(isPresented: Binding<Bool>) -> some View {
        self.modifier(PaywallModifier(trigger: isPresented.wrappedValue))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Basic usage with coordinator:
 
 ```swift
 struct ContentView: View {
     @StateObject private var coordinator = PaywallCoordinator()
     
     var body: some View {
         VStack {
             Button("Subscribe") {
                 coordinator.show()
             }
         }
         .sheet(isPresented: $coordinator.isPresented) {
             PaywallView(
                 plans: coordinator.plans,
                 onPurchase: { planID in
                     try await coordinator.purchase(planID: planID)
                 },
                 onRestore: {
                     try await coordinator.restore()
                 },
                 onDismiss: {
                     coordinator.dismiss()
                 }
             )
         }
     }
 }
 ```
 
 2. Using modifier:
 
 ```swift
 struct FeatureView: View {
     @State private var showPaywall = false
     
     var body: some View {
         Button("Unlock Feature") {
             showPaywall = true
         }
         .paywall(isPresented: $showPaywall)
     }
 }
 ```
 
 3. Check subscription before showing feature:
 
 ```swift
 struct PremiumFeatureView: View {
     @StateObject private var purchaseManager = PurchaseManager.shared
     @StateObject private var coordinator = PaywallCoordinator()
     
     var body: some View {
         if purchaseManager.subscriptionStatus.isActive {
             PremiumContent()
         } else {
             Button("Unlock Premium") {
                 coordinator.show()
             }
         }
     }
 }
 ```
 
 4. Manual paywall presentation:
 
 ```swift
 PaywallView(
     plans: SubscriptionPlan.samplePlans,
     onPurchase: { planID in
         try await PurchaseManager.shared.purchase(productID: planID)
     },
     onRestore: {
         try await PurchaseManager.shared.restorePurchases()
     },
     onDismiss: {
         // Handle dismiss
     }
 )
 ```
 
 */

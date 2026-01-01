//
//  PurchaseManager.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import Foundation
import Combine

/*
 SETUP INSTRUCTIONS:
 
 1. Add RevenueCat SDK via Swift Package Manager:
    - In Xcode: File → Add Packages
    - URL: https://github.com/RevenueCat/purchases-ios
    - Version: Latest (5.x+)
 
 2. Configure in RevenueCat Dashboard:
    - Create account at https://app.revenuecat.com
    - Create new app
    - Add products (match AppConfig product IDs)
    - Get API key
 
 3. Add API key to AppConfig.swift:
    static let revenueCatAPIKey = "YOUR_KEY_HERE"
 
 4. Initialize in app launch:
    PurchaseManager.shared.configure(apiKey: AppConfig.revenueCatAPIKey)
 
 5. Uncomment RevenueCat imports and implementation below
 
 NOTE: This file is a template. Uncomment the RevenueCat code when you add the SDK.
 */

// MARK: - Purchase Manager

/// Thread-safe purchase manager wrapping RevenueCat
/// Handles all subscription and purchase logic
@MainActor
class PurchaseManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = PurchaseManager()
    
    // MARK: - Published Properties
    
    /// Current subscription status
    @Published private(set) var subscriptionStatus: SubscriptionStatus = .none
    
    /// Available offerings
    @Published private(set) var offerings: [Offering] = []
    
    /// Whether purchase manager is configured
    @Published private(set) var isConfigured = false
    
    /// Loading state
    @Published private(set) var isLoading = false
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    private init() {
        // Private init for singleton
    }
    
    // MARK: - Configuration
    
    /// Configure RevenueCat with API key
    /// - Parameter apiKey: RevenueCat API key from dashboard
    ///
    /// Call this in app initialization:
    /// ```swift
    /// PurchaseManager.shared.configure(apiKey: AppConfig.revenueCatAPIKey)
    /// ```
    func configure(apiKey: String) {
        guard !apiKey.isEmpty && !apiKey.contains("YOUR_") else {
            print("⚠️ RevenueCat API key not configured")
            return
        }
        
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         import RevenueCat
         
         Purchases.logLevel = Environment.current.isLoggingEnabled ? .debug : .error
         Purchases.configure(withAPIKey: apiKey)
         
         // Set up delegate
         Purchases.shared.delegate = self
         
         // Initial status check
         Task {
             await checkSubscriptionStatus()
             await fetchOfferings()
         }
         */
        
        isConfigured = true
        print("✅ PurchaseManager configured")
        
        // For template/testing without RevenueCat
        #if DEBUG
        subscriptionStatus = .none
        #endif
    }
    
    // MARK: - Purchase
    
    /// Purchase a product
    /// - Parameter productID: Product identifier
    /// - Returns: Purchase result
    /// - Throws: PurchaseError
    ///
    /// Example:
    /// ```swift
    /// do {
    ///     let result = try await PurchaseManager.shared.purchase(productID: "monthly_premium")
    ///     if result.isSuccess {
    ///         // Show success message
    ///     }
    /// } catch {
    ///     // Handle error
    /// }
    /// ```
    func purchase(productID: String) async throws -> PurchaseResult {
        guard isConfigured else {
            throw PurchaseError.notConfigured
        }
        
        isLoading = true
        defer { isLoading = false }
        
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         do {
             let result = try await Purchases.shared.purchase(product: productID)
             
             if result.userCancelled {
                 throw PurchaseError.cancelled
             }
             
             await checkSubscriptionStatus()
             
             // Track purchase
             await AnalyticsManager.shared.track(.purchaseCompleted(
                 productID: productID,
                 price: Double(result.transaction?.price ?? 0),
                 transactionID: result.transaction?.transactionIdentifier
             ))
             
             return .success(productID: productID)
             
         } catch let error as PurchaseError {
             throw error
         } catch {
             throw PurchaseError.purchaseFailed(reason: error.localizedDescription)
         }
         */
        
        // Template implementation for testing
        #if DEBUG
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        subscriptionStatus = .active(expirationDate: Date().addMonths(1))
        return .success(productID: productID)
        #else
        throw PurchaseError.notConfigured
        #endif
    }
    
    /// Restore previous purchases
    /// - Throws: PurchaseError
    ///
    /// Example:
    /// ```swift
    /// do {
    ///     try await PurchaseManager.shared.restorePurchases()
    ///     // Show success message
    /// } catch {
    ///     // Show error
    /// }
    /// ```
    func restorePurchases() async throws {
        guard isConfigured else {
            throw PurchaseError.notConfigured
        }
        
        isLoading = true
        defer { isLoading = false }
        
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         do {
             _ = try await Purchases.shared.restorePurchases()
             await checkSubscriptionStatus()
         } catch {
             throw PurchaseError.restoreFailed
         }
         */
        
        // Template implementation
        #if DEBUG
        try await Task.sleep(nanoseconds: 1_000_000_000)
        #else
        throw PurchaseError.notConfigured
        #endif
    }
    
    // MARK: - Subscription Status
    
    /// Check current subscription status
    /// - Returns: Current subscription status
    ///
    /// Example:
    /// ```swift
    /// let status = await PurchaseManager.shared.checkSubscriptionStatus()
    /// if status.isActive {
    ///     // Show premium features
    /// }
    /// ```
    @discardableResult
    func checkSubscriptionStatus() async -> SubscriptionStatus {
        guard isConfigured else {
            return .none
        }
        
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         do {
             let customerInfo = try await Purchases.shared.customerInfo()
             let status = parseSubscriptionStatus(from: customerInfo)
             subscriptionStatus = status
             
             // Update storage
             AppStorage.hasSubscription = status.isActive
             
             return status
         } catch {
             subscriptionStatus = .none
             return .none
         }
         */
        
        // Template implementation
        return subscriptionStatus
    }
    
    /// Parse subscription status from customer info
    /*
     UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
     
     private func parseSubscriptionStatus(from customerInfo: CustomerInfo) -> SubscriptionStatus {
         guard let entitlement = customerInfo.entitlements.active.first?.value else {
             return .none
         }
         
         let expirationDate = entitlement.expirationDate
         
         if entitlement.isActive {
             if entitlement.periodType == .trial {
                 return .trial(expirationDate: expirationDate ?? Date())
             } else if entitlement.billingIssueDetectedAt != nil {
                 return .gracePeriod(expirationDate: expirationDate ?? Date())
             } else {
                 return .active(expirationDate: expirationDate)
             }
         } else {
             return .expired(expirationDate: expirationDate)
         }
     }
     */
    
    // MARK: - Offerings
    
    /// Fetch available offerings
    /// - Returns: Array of offerings
    ///
    /// Example:
    /// ```swift
    /// let offerings = await PurchaseManager.shared.fetchOfferings()
    /// // Display offerings in UI
    /// ```
    @discardableResult
    func fetchOfferings() async -> [Offering] {
        guard isConfigured else {
            return []
        }
        
        isLoading = true
        defer { isLoading = false }
        
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         do {
             let rcOfferings = try await Purchases.shared.offerings()
             
             guard let current = rcOfferings.current else {
                 return []
             }
             
             let parsedOfferings = current.availablePackages.compactMap { package -> Offering? in
                 parseOffering(from: package)
             }
             
             offerings = parsedOfferings
             return parsedOfferings
             
         } catch {
             print("Failed to fetch offerings: \(error)")
             return []
         }
         */
        
        // Template implementation
        #if DEBUG
        let mockOfferings = [
            Offering(
                id: "monthly",
                identifier: AppConfig.monthlySubscriptionID,
                title: "Monthly Premium",
                description: "Premium features billed monthly",
                price: 9.99,
                priceString: "$9.99",
                currencyCode: "USD",
                duration: .monthly,
                isTrial: false,
                trialDuration: nil
            ),
            Offering(
                id: "yearly",
                identifier: AppConfig.yearlySubscriptionID,
                title: "Yearly Premium",
                description: "Premium features billed yearly",
                price: 79.99,
                priceString: "$79.99",
                currencyCode: "USD",
                duration: .yearly,
                isTrial: false,
                trialDuration: nil
            )
        ]
        offerings = mockOfferings
        return mockOfferings
        #else
        return []
        #endif
    }
    
    /// Parse offering from RevenueCat package
    /*
     UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
     
     private func parseOffering(from package: Package) -> Offering? {
         let product = package.storeProduct
         
         let duration: SubscriptionDuration
         switch package.packageType {
         case .monthly:
             duration = .monthly
         case .annual:
             duration = .yearly
         case .lifetime:
             duration = .lifetime
         case .weekly:
             duration = .weekly
         default:
             duration = .custom(months: 1)
         }
         
         return Offering(
             id: package.identifier,
             identifier: product.productIdentifier,
             title: product.localizedTitle,
             description: product.localizedDescription,
             price: product.price,
             priceString: product.localizedPriceString,
             currencyCode: product.currencyCode ?? "USD",
             duration: duration,
             isTrial: product.introductoryDiscount != nil,
             trialDuration: nil // Parse from introductoryDiscount if needed
         )
     }
     */
    
    // MARK: - User Management
    
    /// Set user ID for attribution
    /// - Parameter userID: User identifier
    func setUserID(_ userID: String) {
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         Purchases.shared.logIn(userID) { customerInfo, created, error in
             if let error = error {
                 print("Failed to set user ID: \(error)")
             }
         }
         */
    }
    
    /// Log out current user
    func logout() async {
        /*
         UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
         
         do {
             _ = try await Purchases.shared.logOut()
             subscriptionStatus = .none
         } catch {
             print("Failed to logout: \(error)")
         }
         */
        
        subscriptionStatus = .none
    }
}

// MARK: - RevenueCat Delegate

/*
 UNCOMMENT WHEN REVENUECAT SDK IS ADDED:
 
 extension PurchaseManager: PurchasesDelegate {
     func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
         Task { @MainActor in
             let status = parseSubscriptionStatus(from: customerInfo)
             subscriptionStatus = status
         }
     }
 }
 */

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 1. Initialize (in app launch):
 
 ```swift
 // In AppStarterApp.swift init()
 PurchaseManager.shared.configure(apiKey: AppConfig.revenueCatAPIKey)
 ```
 
 2. Purchase subscription:
 
 ```swift
 Button("Subscribe") {
     Task {
         do {
             try await PurchaseManager.shared.purchase(productID: "monthly_premium")
             // Show success
         } catch PurchaseError.cancelled {
             // User cancelled
         } catch {
             // Show error
             showAlert(error.localizedDescription)
         }
     }
 }
 ```
 
 3. Check subscription status:
 
 ```swift
 struct ContentView: View {
     @StateObject private var purchaseManager = PurchaseManager.shared
     
     var body: some View {
         if purchaseManager.subscriptionStatus.isActive {
             PremiumView()
         } else {
             PaywallView()
         }
     }
 }
 ```
 
 4. Restore purchases:
 
 ```swift
 Button("Restore Purchases") {
     Task {
         do {
             try await PurchaseManager.shared.restorePurchases()
             showAlert("Purchases restored successfully")
         } catch {
             showAlert("Failed to restore purchases")
         }
     }
 }
 ```
 
 5. Display offerings:
 
 ```swift
 struct PaywallView: View {
     @StateObject private var purchaseManager = PurchaseManager.shared
     
     var body: some View {
         VStack {
             ForEach(purchaseManager.offerings) { offering in
                 OfferingCard(offering: offering) {
                     Task {
                         try? await purchaseManager.purchase(productID: offering.identifier)
                     }
                 }
             }
         }
         .task {
             await purchaseManager.fetchOfferings()
         }
     }
 }
 ```
 
 */

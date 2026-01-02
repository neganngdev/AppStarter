//
//  SettingsView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Settings View

/// Main settings screen
struct SettingsView: View {
    
    // MARK: - State
    
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var notificationsEnabled = true
    @State private var analyticsEnabled = true
    @State private var showRestoreAlert = false
    @State private var isRestoring = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                // Subscription Section
                subscriptionSection
                
                // Preferences Section
                preferencesSection
                
                // Support Section
                supportSection
                
                // Legal Section
                legalSection
                
                // About Section
                aboutSection
            }
            .navigationTitle("Settings")
            .alert("Purchases Restored", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your purchases have been restored successfully.")
            }
        }
    }
    
    // MARK: - Subscription Section
    
    private var subscriptionSection: some View {
        SettingsSection(
            header: "Subscription",
            footer: purchaseManager.subscriptionStatus.detailMessage
        ) {
            // Subscription Status
            HStack {
                Image(systemName: purchaseManager.subscriptionStatus.isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(purchaseManager.subscriptionStatus.isActive ? Color.appSuccess : Color.appSecondaryText)
                
                VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                    Text("Status")
                        .font(Font.appBody)
                        .foregroundColor(Color.appText)
                    
                    Text(purchaseManager.subscriptionStatus.description)
                        .font(Font.appCaption)
                        .foregroundColor(Color.appSecondaryText)
                }
                
                Spacer()
            }
            .padding(.vertical, AppSpacing.xSmall)
            
            // Restore Purchases
            TappableSettingsRow(
                icon: "arrow.clockwise",
                iconColor: Color.appPrimary,
                title: "Restore Purchases"
            ) {
                restorePurchases()
            }
            
            // Manage Subscription (if active)
            if purchaseManager.subscriptionStatus.isActive {
                TappableSettingsRow(
                    icon: "creditcard.fill",
                    iconColor: Color.appPrimary,
                    title: "Manage Subscription"
                ) {
                    openSubscriptionManagement()
                }
            }
        }
    }
    
    // MARK: - Preferences Section
    
    private var preferencesSection: some View {
        SettingsSection(
            header: "Preferences",
            footer: "Customize your app experience"
        ) {
            SettingsRow(
                icon: "bell.fill",
                iconColor: Color.appAccent,
                title: "Notifications",
                type: .toggle(isOn: $notificationsEnabled)
            )
            .onChange(of: notificationsEnabled) { newValue in
                // Handle notification toggle
                Task {
                    await AnalyticsManager.shared.trackEvent("notifications_toggled", parameters: [
                        "enabled": newValue
                    ])
                }
            }
            
            SettingsRow(
                icon: "chart.bar.fill",
                iconColor: Color.appInfo,
                title: "Analytics",
                type: .toggle(isOn: $analyticsEnabled)
            )
            .onChange(of: analyticsEnabled) { newValue in
                Task {
                    if newValue {
                        await AnalyticsManager.shared.enable()
                    } else {
                        await AnalyticsManager.shared.disable()
                    }
                }
            }
        }
    }
    
    // MARK: - Support Section
    
    private var supportSection: some View {
        SettingsSection(header: "Support") {
            TappableSettingsRow(
                icon: "envelope.fill",
                iconColor: Color.appPrimary,
                title: "Contact Support"
            ) {
                contactSupport()
            }
            
            TappableSettingsRow(
                icon: "star.fill",
                iconColor: Color.appPremium,
                title: "Rate App"
            ) {
                rateApp()
            }
            
            TappableSettingsRow(
                icon: "square.and.arrow.up",
                iconColor: Color.appAccent,
                title: "Share App"
            ) {
                shareApp()
            }
        }
    }
    
    // MARK: - Legal Section
    
    private var legalSection: some View {
        SettingsSection(header: "Legal") {
            TappableSettingsRow(
                icon: "doc.text.fill",
                iconColor: Color.appSecondaryText,
                title: "Privacy Policy"
            ) {
                UIApplication.shared.open(AppConfig.privacyPolicyURL)
            }
            
            TappableSettingsRow(
                icon: "doc.text.fill",
                iconColor: Color.appSecondaryText,
                title: "Terms of Service"
            ) {
                UIApplication.shared.open(AppConfig.termsOfServiceURL)
            }
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        SettingsSection(
            header: "About",
            footer: "Made with ❤️ using AppStarter"
        ) {
            SettingsRow(
                icon: "info.circle.fill",
                iconColor: Color.appInfo,
                title: "Version",
                type: .info(value: AppConfig.version)
            )
            
            SettingsRow(
                icon: "number",
                iconColor: Color.appSecondaryText,
                title: "Build",
                type: .info(value: AppConfig.buildNumber)
            )
            
            TappableSettingsRow(
                icon: "heart.fill",
                iconColor: Color.appError,
                title: "Credits"
            ) {
                // Show credits
            }
        }
    }
    
    // MARK: - Actions
    
    private func restorePurchases() {
        isRestoring = true
        
        Task {
            do {
                try await purchaseManager.restorePurchases()
                showRestoreAlert = true
            } catch {
                // Show error
                print("Restore failed: \(error)")
            }
            isRestoring = false
        }
    }
    
    private func openSubscriptionManagement() {
        // Open App Store subscription management
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }
    
    private func contactSupport() {
        // Open email
        let email = AppConfig.supportEmail
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
        
        Task {
            await AnalyticsManager.shared.trackEvent("contact_support_tapped")
        }
    }
    
    private func rateApp() {
        // Open App Store rating
        if let url = URL(string: "https://apps.apple.com/app/id\(AppConfig.appStoreID)?action=write-review") {
            UIApplication.shared.open(url)
        }
        
        Task {
            await AnalyticsManager.shared.trackEvent("rate_app_tapped")
        }
    }
    
    private func shareApp() {
        // Share app
        let text = "Check out \(AppConfig.appName)!"
        let url = URL(string: "https://apps.apple.com/app/id\(AppConfig.appStoreID)")!
        
        let activityVC = UIActivityViewController(
            activityItems: [text, url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
        
        Task {
            await AnalyticsManager.shared.trackEvent("share_app_tapped")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Previews

#Preview("Settings") {
    SettingsView()
}

#Preview("Settings - Dark Mode") {
    SettingsView()
        .preferredColorScheme(.dark)
}

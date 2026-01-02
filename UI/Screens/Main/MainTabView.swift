//
//  MainTabView.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Main Tab View

/// Main tab-based navigation
/// CUSTOMIZE: Add/remove tabs as needed for your app
struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // Explore Tab (Optional)
            // CUSTOMIZE: Uncomment and add your explore/browse screen
            /*
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(1)
            */
            
            // Profile/Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
        }
        .accentColor(Color.appPrimary)
        .onAppear {
            // Track tab view shown
            Task {
                await AnalyticsManager.shared.trackEvent("main_tab_view_shown")
            }
        }
        .onChange(of: selectedTab) { newValue in
            // Track tab changes
            let tabName = tabName(for: newValue)
            Task {
                await AnalyticsManager.shared.trackEvent("tab_changed", parameters: [
                    "tab": tabName
                ])
            }
        }
    }
    
    // MARK: - Helper
    
    private func tabName(for index: Int) -> String {
        switch index {
        case 0: return "home"
        case 1: return "settings"
        default: return "unknown"
        }
    }
}

// MARK: - Alternative: Two-Tab Layout

/// Simplified two-tab layout
struct SimplifiedTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color.appPrimary)
    }
}

// MARK: - Alternative: Four-Tab Layout

/// Example four-tab layout
/// CUSTOMIZE: Use this as a template for more tabs
struct ExtendedTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            PlaceholderView(title: "Explore", icon: "magnifyingglass")
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
            
            PlaceholderView(title: "Favorites", icon: "heart.fill")
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(Color.appPrimary)
    }
}

// MARK: - Placeholder View

/// Placeholder for future tab content
struct PlaceholderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppSpacing.large) {
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(Color.appSecondaryText)
                
                Text(title)
                    .font(Font.appTitle)
                    .fontWeight(.bold)
                
                Text("Add your content here")
                    .font(Font.appBody)
                    .foregroundColor(Color.appSecondaryText)
                
                Spacer()
            }
            .navigationTitle(title)
        }
    }
}

// MARK: - Previews

#Preview("Main Tab View") {
    MainTabView()
}

#Preview("Simplified Tab View") {
    SimplifiedTabView()
}

#Preview("Extended Tab View") {
    ExtendedTabView()
}

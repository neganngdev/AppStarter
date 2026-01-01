//
//  EmptyStateView.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Empty State View

/// Reusable empty state component for lists and collections
struct EmptyStateView: View {
    
    // MARK: - Properties
    
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    // MARK: - Initialization
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.appSecondaryText)
            
            // Text
            VStack(spacing: AppSpacing.xSmall) {
                Text(title)
                    .font(.appTitle3)
                    .foregroundColor(.appText)
                
                Text(message)
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.large)
            
            // Action Button
            if let actionTitle = actionTitle, let action = action {
                AppButton(actionTitle, style: .primary, size: .medium, action: action)
                    .padding(.top, AppSpacing.small)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Common Empty States

extension EmptyStateView {
    
    /// Empty list state
    static func emptyList(
        title: String = "No Items",
        message: String = "There are no items to display",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> EmptyStateView {
        EmptyStateView(
            icon: "tray",
            title: title,
            message: message,
            actionTitle: actionTitle,
            action: action
        )
    }
    
    /// No search results state
    static func noSearchResults(
        query: String? = nil
    ) -> EmptyStateView {
        let message = query != nil
            ? "No results found for \"\(query!)\""
            : "No results found"
        
        return EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            message: message
        )
    }
    
    /// No internet connection state
    static func noInternet(
        action: @escaping () -> Void
    ) -> EmptyStateView {
        EmptyStateView(
            icon: "wifi.slash",
            title: "No Connection",
            message: "Please check your internet connection and try again",
            actionTitle: "Retry",
            action: action
        )
    }
    
    /// No notifications state
    static func noNotifications() -> EmptyStateView {
        EmptyStateView(
            icon: "bell.slash",
            title: "No Notifications",
            message: "You're all caught up! Check back later for updates"
        )
    }
    
    /// No favorites state
    static func noFavorites(
        action: @escaping () -> Void
    ) -> EmptyStateView {
        EmptyStateView(
            icon: "heart",
            title: "No Favorites",
            message: "Items you favorite will appear here",
            actionTitle: "Browse Items",
            action: action
        )
    }
}

// MARK: - Previews

#Preview("Empty State") {
    EmptyStateView(
        icon: "tray",
        title: "No Items",
        message: "Add your first item to get started",
        actionTitle: "Add Item"
    ) {
        print("Add item tapped")
    }
}

#Preview("Common States") {
    TabView {
        EmptyStateView.emptyList(
            title: "No Tasks",
            message: "Create your first task to get started",
            actionTitle: "New Task"
        ) { }
        .tag(0)
        
        EmptyStateView.noSearchResults(query: "SwiftUI")
            .tag(1)
        
        EmptyStateView.noInternet { }
            .tag(2)
        
        EmptyStateView.noNotifications()
            .tag(3)
        
        EmptyStateView.noFavorites { }
            .tag(4)
    }
    .tabViewStyle(.page)
}

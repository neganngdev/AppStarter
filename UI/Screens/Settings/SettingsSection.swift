//
//  SettingsSection.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Settings Section

/// Grouped settings section with header and footer
struct SettingsSection<Content: View>: View {
    let header: String?
    let footer: String?
    let content: Content
    
    init(
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.footer = footer
        self.content = content()
    }
    
    var body: some View {
        Section {
            content
        } header: {
            if let header = header {
                Text(header)
                    .font(.appCaption)
                    .foregroundColor(.appSecondaryText)
                    .textCase(.uppercase)
            }
        } footer: {
            if let footer = footer {
                Text(footer)
                    .font(.appCaption)
                    .foregroundColor(.appTertiaryText)
            }
        }
    }
}

// MARK: - Previews

#Preview("Settings Section") {
    List {
        SettingsSection(
            header: "Preferences",
            footer: "Customize your app experience"
        ) {
            SettingsRow(
                icon: "bell.fill",
                title: "Notifications",
                type: .toggle(isOn: .constant(true))
            )
            
            SettingsRow(
                icon: "moon.fill",
                title: "Dark Mode",
                type: .toggle(isOn: .constant(false))
            )
        }
        
        SettingsSection(header: "Support") {
            TappableSettingsRow(
                icon: "envelope.fill",
                title: "Contact Us"
            ) { }
            
            TappableSettingsRow(
                icon: "star.fill",
                title: "Rate App"
            ) { }
        }
    }
}

//
//  SettingsRow.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Settings Row

/// Reusable settings row component
struct SettingsRow: View {
    
    let icon: String?
    let iconColor: Color
    let title: String
    let type: RowType
    
    init(
        icon: String? = nil,
        iconColor: Color = Color.appPrimary,
        title: String,
        type: RowType
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            // Icon
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
            }
            
            // Title
            Text(title)
                .font(Font.appBody)
                .foregroundColor(Color.appText)
            
            Spacer()
            
            // Type-specific content
            switch type {
            case .navigation(let value):
                HStack(spacing: AppSpacing.xxSmall) {
                    if let value = value {
                        Text(value)
                            .font(Font.appBody)
                            .foregroundColor(Color.appSecondaryText)
                    }
                    Image(systemName: "chevron.right")
                        .font(Font.caption)
                        .foregroundColor(Color.appTertiaryText)
                }
                
            case .toggle(let isOn):
                Toggle("", isOn: isOn)
                    .labelsHidden()
                
            case .action:
                EmptyView()
                
            case .info(let value):
                Text(value)
                    .font(Font.appBody)
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .padding(.vertical, AppSpacing.xSmall)
    }
}

// MARK: - Row Type

extension SettingsRow {
    enum RowType {
        case navigation(value: String? = nil)
        case toggle(isOn: Binding<Bool>)
        case action
        case info(value: String)
    }
}

// MARK: - Tappable Settings Row

/// Settings row with tap action
struct TappableSettingsRow: View {
    let icon: String?
    let iconColor: Color
    let title: String
    let value: String?
    let action: () -> Void
    
    init(
        icon: String? = nil,
        iconColor: Color = Color.appPrimary,
        title: String,
        value: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            SettingsRow(
                icon: icon,
                iconColor: iconColor,
                title: title,
                type: .navigation(value: value)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Settings Rows") {
    List {
        SettingsRow(
            icon: "bell.fill",
            title: "Notifications",
            type: .toggle(isOn: .constant(true))
        )
        
        TappableSettingsRow(
            icon: "person.fill",
            title: "Account",
            value: "john@example.com"
        ) { }
        
        SettingsRow(
            icon: "info.circle.fill",
            iconColor: Color.appInfo,
            title: "Version",
            type: .info(value: "1.0.0")
        )
        
        TappableSettingsRow(
            icon: "envelope.fill",
            iconColor: Color.appAccent,
            title: "Contact Support"
        ) { }
    }
}

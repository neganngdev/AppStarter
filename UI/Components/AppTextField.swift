//
//  AppTextField.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - App Text Field

/// Reusable text field component with validation and styling
struct AppTextField: View {
    
    // MARK: - Properties
    
    let placeholder: String
    let icon: String?
    let errorMessage: String?
    let maxLength: Int?
    let showCharacterCount: Bool
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    // MARK: - Initialization
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        errorMessage: String? = nil,
        maxLength: Int? = nil,
        showCharacterCount: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.errorMessage = errorMessage
        self.maxLength = maxLength
        self.showCharacterCount = showCharacterCount
    }
    
    // MARK: - Computed Properties
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    private var borderColor: Color {
        if hasError {
            return .appError
        } else if isFocused {
            return .appPrimary
        } else {
            return .appBorder
        }
    }
    
    private var characterCount: String {
        if let maxLength = maxLength {
            return "\(text.count)/\(maxLength)"
        }
        return "\(text.count)"
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
            HStack(spacing: AppSpacing.small) {
                // Icon
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(hasError ? Color.appError : Color.appSecondaryText)
                        .frame(width: 20)
                }
                
                // Text Field
                TextField(placeholder, text: $text)
                    .font(Font.appBody)
                    .foregroundColor(Color.appText)
                    .focused($isFocused)
                    .onChange(of: text) { newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                
                // Clear Button
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.appSecondaryText)
                    }
                }
            }
            .padding(AppSpacing.small)
            .background(Color.appSecondaryBackground)
            .cornerRadius(AppRadius.input)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.input)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            
            // Error Message or Character Count
            HStack {
                if let errorMessage = errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.circle")
                        .font(Font.appCaption)
                        .foregroundColor(Color.appError)
                }
                
                Spacer()
                
                if showCharacterCount {
                    Text(characterCount)
                        .font(Font.appCaption)
                        .foregroundColor(Color.appTertiaryText)
                }
            }
        }
    }
}

// MARK: - Secure Text Field

/// Secure text field for passwords
struct AppSecureField: View {
    
    let placeholder: String
    let icon: String?
    let errorMessage: String?
    @Binding var text: String
    @State private var isSecure = true
    @FocusState private var isFocused: Bool
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        icon: String? = "lock",
        errorMessage: String? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.errorMessage = errorMessage
    }
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    private var borderColor: Color {
        if hasError {
            return Color.appError
        } else if isFocused {
            return Color.appPrimary
        } else {
            return Color.appBorder
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
            HStack(spacing: AppSpacing.small) {
                // Icon
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(hasError ? Color.appError : Color.appSecondaryText)
                        .frame(width: 20)
                }
                
                // Secure Field
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(Font.appBody)
                .foregroundColor(Color.appText)
                .focused($isFocused)
                
                // Show/Hide Button
                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundColor(Color.appSecondaryText)
                }
            }
            .padding(AppSpacing.small)
            .background(Color.appSecondaryBackground)
            .cornerRadius(AppRadius.input)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.input)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            
            // Error Message
            if let errorMessage = errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.circle")
                    .font(Font.appCaption)
                    .foregroundColor(Color.appError)
            }
        }
    }
}

// MARK: - Previews

#Preview("Text Field") {
    VStack(spacing: AppSpacing.large) {
        AppTextField("Email", text: .constant(""), icon: "envelope")
        AppTextField("Username", text: .constant("john_doe"), icon: "person")
        AppTextField("Error State", text: .constant("invalid"), icon: "envelope", errorMessage: "Invalid email address")
        AppTextField("With Count", text: .constant("Hello"), maxLength: 50, showCharacterCount: true)
    }
    .padding()
}

#Preview("Secure Field") {
    VStack(spacing: AppSpacing.large) {
        AppSecureField("Password", text: .constant(""))
        AppSecureField("Error State", text: .constant("weak"), errorMessage: "Password too weak")
    }
    .padding()
}

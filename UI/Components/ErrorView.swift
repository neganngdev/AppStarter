//
//  ErrorView.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Error View

/// Reusable error display component with retry option
struct ErrorView: View {
    
    // MARK: - Properties
    
    let error: Error
    let retryAction: (() -> Void)?
    
    // MARK: - Initialization
    
    init(
        error: Error,
        retryAction: (() -> Void)? = nil
    ) {
        self.error = error
        self.retryAction = retryAction
    }
    
    init(
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.error = ErrorMessage(message: message)
        self.retryAction = retryAction
    }
    
    // MARK: - Computed Properties
    
    private var errorMessage: String {
        if let networkError = error as? NetworkError {
            return networkError.userMessage
        } else if let purchaseError = error as? PurchaseError {
            return purchaseError.userMessage
        } else {
            return error.localizedDescription
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer()
            
            // Error Icon
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.appError)
            
            // Error Text
            VStack(spacing: AppSpacing.xSmall) {
                Text("Something Went Wrong")
                    .font(.appTitle3)
                    .foregroundColor(.appText)
                
                Text(errorMessage)
                    .font(.appBody)
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.large)
            
            // Retry Button
            if let retryAction = retryAction {
                AppButton("Try Again", icon: "arrow.clockwise", style: .primary, size: .medium, action: retryAction)
                    .padding(.top, AppSpacing.small)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error Message

private struct ErrorMessage: Error, LocalizedError {
    let message: String
    
    var errorDescription: String? {
        message
    }
}

// MARK: - Inline Error View

struct InlineErrorView: View {
    let message: String
    let retryAction: (() -> Void)?
    
    init(
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(.appError)
            
            Text(message)
                .font(.appBody)
                .foregroundColor(.appText)
            
            Spacer()
            
            if let retryAction = retryAction {
                Button("Retry") {
                    retryAction()
                }
                .font(.appBodyEmphasized)
                .foregroundColor(.appPrimary)
            }
        }
        .padding()
        .background(.appError.opacity(0.1))
        .cornerRadius(AppRadius.small)
    }
}

// MARK: - Error Banner

struct ErrorBanner: View {
    let message: String
    let dismissAction: (() -> Void)?
    
    init(
        message: String,
        dismissAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.appError)
            
            Text(message)
                .font(.appBody)
                .foregroundColor(.white)
            
            Spacer()
            
            if let dismissAction = dismissAction {
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(.appError)
        .cornerRadius(AppRadius.small)
        .appShadow(.medium)
    }
}

// MARK: - View Extension

extension View {
    /// Show error banner at top
    /// - Parameters:
    ///   - error: Error to display
    ///   - isPresented: Binding to control visibility
    /// - Returns: Modified view
    func errorBanner(error: String?, isPresented: Binding<Bool>) -> some View {
        ZStack(alignment: .top) {
            self
            
            if let error = error, isPresented.wrappedValue {
                ErrorBanner(message: error) {
                    isPresented.wrappedValue = false
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: isPresented.wrappedValue)
            }
        }
    }
}

// MARK: - Previews

#Preview("Error View") {
    ErrorView(
        message: "Failed to load data. Please check your internet connection and try again."
    ) {
        print("Retry tapped")
    }
}

#Preview("Inline Error") {
    VStack(spacing: AppSpacing.large) {
        InlineErrorView(
            message: "Failed to save changes"
        ) {
            print("Retry")
        }
        
        InlineErrorView(
            message: "Network error occurred"
        )
    }
    .padding()
}

#Preview("Error Banner") {
    VStack {
        ErrorBanner(message: "Something went wrong") {
            print("Dismiss")
        }
        .padding()
        
        Spacer()
    }
    .background(.appBackground)
}

#Preview("Error Types") {
    TabView {
        ErrorView(error: NetworkError.noInternet) { }
            .tag(0)
        
        ErrorView(error: NetworkError.timeout) { }
            .tag(1)
        
        ErrorView(error: PurchaseError.cancelled) { }
            .tag(2)
    }
    .tabViewStyle(.page)
}

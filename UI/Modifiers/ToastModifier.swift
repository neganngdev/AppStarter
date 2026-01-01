//
//  ToastModifier.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Toast Type

enum ToastType {
    case success
    case error
    case info
    case warning
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .appSuccess
        case .error: return .appError
        case .info: return .appInfo
        case .warning: return .appWarning
        }
    }
}

// MARK: - Toast View

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: type.icon)
                .foregroundColor(.white)
            
            Text(message)
                .font(.appBody)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(type.color)
        .cornerRadius(AppRadius.medium)
        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}

// MARK: - Toast Modifier

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if isPresented {
                ToastView(message: message, type: type)
                    .padding(.horizontal)
                    .padding(.top, AppSpacing.medium)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

// MARK: - View Extension

extension View {
    /// Show toast notification
    /// - Parameters:
    ///   - isPresented: Binding to control visibility
    ///   - message: Toast message
    ///   - type: Toast type (success, error, info, warning)
    ///   - duration: Auto-dismiss duration (default: 3 seconds)
    /// - Returns: Modified view
    func toast(
        _ isPresented: Binding<Bool>,
        message: String,
        type: ToastType = .info,
        duration: TimeInterval = 3.0
    ) -> some View {
        self.modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            type: type,
            duration: duration
        ))
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 struct ContentView: View {
     @State private var showToast = false
     
     var body: some View {
         VStack {
             Button("Show Success") {
                 showToast = true
             }
         }
         .toast($showToast, message: "Success!", type: .success)
     }
 }
 
 // Different types
 .toast($showSuccess, message: "Saved successfully", type: .success)
 .toast($showError, message: "Something went wrong", type: .error)
 .toast($showInfo, message: "New update available", type: .info)
 .toast($showWarning, message: "Low storage space", type: .warning)
 
 // Custom duration
 .toast($showToast, message: "Quick message", type: .info, duration: 2.0)
 ```
 
 */

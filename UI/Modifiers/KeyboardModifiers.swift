//
//  KeyboardModifiers.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Dismiss Keyboard on Tap

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}

// MARK: - Keyboard Aware Padding

struct KeyboardAwarePadding: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main
                ) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height
                    }
                }
                
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    keyboardHeight = 0
                }
            }
            .animation(.easeOut, value: keyboardHeight)
    }
}

// MARK: - View Extensions

extension View {
    /// Dismiss keyboard when tapping outside text fields
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTap())
    }
    
    /// Add padding that adjusts for keyboard
    func keyboardAwarePadding() -> some View {
        self.modifier(KeyboardAwarePadding())
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 struct LoginView: View {
     @State private var email = ""
     @State private var password = ""
     
     var body: some View {
         VStack {
             TextField("Email", text: $email)
             SecureField("Password", text: $password)
             Button("Login") { }
         }
         .padding()
         .dismissKeyboardOnTap()
     }
 }
 
 // With keyboard-aware padding
 ScrollView {
     VStack {
         // Form fields
     }
     .keyboardAwarePadding()
 }
 ```
 
 */

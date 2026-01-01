//
//  View+Extensions.swift
//  AppStarter
//
//  Created on 2026-01-01
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - View Extensions

extension View {
    
    // MARK: - Corner Radius
    
    /// Apply corner radius to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    // MARK: - Conditional Modifiers
    
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<Value, Content: View>(
        _ value: Value?,
        transform: (Self, Value) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    // MARK: - Keyboard
    
    func hideKeyboardOnTap() -> some View {
        onTapGesture {
            hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    // MARK: - Loading
    
    func loading(isLoading: Bool, message: String? = nil) -> some View {
        overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView().scaleEffect(1.5).tint(.white)
                        if let message = message {
                            Text(message).foregroundColor(.white).font(.subheadline)
                        }
                    }
                    .padding(24)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.7)))
                }
            }
        }
    }
    
    // MARK: - Card Style
    
    func cardStyle(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 4
    ) -> some View {
        padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
    
    // MARK: - Frame Helpers
    
    func fillWidth(alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func fillHeight(alignment: Alignment = .center) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func fillScreen(alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    func square(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}

// MARK: - Supporting Types

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

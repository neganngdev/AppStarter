//
//  HapticManager.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import UIKit

// MARK: - Haptic Type

enum HapticType {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
    case selection
}

// MARK: - Haptic Manager

/// Manages haptic feedback
class HapticManager {
    
    // MARK: - Singleton
    
    static let shared = HapticManager()
    
    // MARK: - Properties
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let impactGeneratorLight = UIImpactFeedbackGenerator(style: .light)
    private let impactGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactGeneratorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    // MARK: - Initialization
    
    private init() {
        // Prepare generators
        notificationGenerator.prepare()
        impactGeneratorLight.prepare()
        impactGeneratorMedium.prepare()
        impactGeneratorHeavy.prepare()
        selectionGenerator.prepare()
    }
    
    // MARK: - Public Methods
    
    /// Trigger haptic feedback
    /// - Parameter type: Type of haptic feedback
    func trigger(_ type: HapticType) {
        switch type {
        case .success:
            notificationGenerator.notificationOccurred(.success)
            
        case .warning:
            notificationGenerator.notificationOccurred(.warning)
            
        case .error:
            notificationGenerator.notificationOccurred(.error)
            
        case .light:
            impactGeneratorLight.impactOccurred()
            
        case .medium:
            impactGeneratorMedium.impactOccurred()
            
        case .heavy:
            impactGeneratorHeavy.impactOccurred()
            
        case .selection:
            selectionGenerator.selectionChanged()
        }
    }
}

// MARK: - Usage Examples

/*
 
 USAGE EXAMPLES:
 
 ```swift
 // Success feedback
 HapticManager.shared.trigger(.success)
 
 // Error feedback
 HapticManager.shared.trigger(.error)
 
 // Button tap
 Button("Tap Me") {
     HapticManager.shared.trigger(.light)
     // Handle action
 }
 
 // Selection change
 Picker("Option", selection: $selection) {
     // Options
 }
 .onChange(of: selection) { _, _ in
     HapticManager.shared.trigger(.selection)
 }
 
 // Heavy impact for important actions
 Button("Delete") {
     HapticManager.shared.trigger(.heavy)
     deleteItem()
 }
 ```
 
 */

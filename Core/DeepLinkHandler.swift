//
//  DeepLinkHandler.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import Foundation

// MARK: - Deep Link

/// Represents a deep link destination
enum DeepLink: Equatable {
    case premium
    case settings
    case feature(id: String)
    case custom(path: String)
    case unknown
}

// MARK: - Deep Link Handler

/// Handles parsing and routing of deep links
class DeepLinkHandler {
    
    // MARK: - Singleton
    
    static let shared = DeepLinkHandler()
    
    // MARK: - Properties
    
    /// URL scheme for the app
    /// CUSTOMIZE: Set your app's URL scheme
    private let scheme = "appstarter"
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Public Methods
    
    /// Parse URL into DeepLink
    /// - Parameter url: URL to parse
    /// - Returns: DeepLink destination
    func parse(_ url: URL) -> DeepLink {
        // Check scheme
        guard url.scheme == scheme else {
            return .unknown
        }
        
        // Get host/path
        let host = url.host ?? ""
        let path = url.path
        
        // Parse based on host
        switch host {
        case "premium":
            return .premium
            
        case "settings":
            return .settings
            
        case "feature":
            // Extract feature ID from path
            let components = path.split(separator: "/")
            if let featureID = components.first {
                return .feature(id: String(featureID))
            }
            return .unknown
            
        default:
            return .custom(path: "\(host)\(path)")
        }
    }
    
    /// Handle deep link
    /// - Parameters:
    ///   - url: URL to handle
    ///   - coordinator: App coordinator for navigation
    func handle(_ url: URL, coordinator: AppCoordinator) {
        let deepLink = parse(url)
        
        // Track deep link
        Task {
            await AnalyticsManager.shared.trackEvent("deep_link_opened", parameters: [
                "url": url.absoluteString,
                "destination": String(describing: deepLink)
            ])
        }
        
        // Handle based on type
        Task { @MainActor in
            switch deepLink {
            case .premium:
                coordinator.presentPaywall()
                
            case .settings:
                coordinator.navigateToSettings()
                
            case .feature(let id):
                coordinator.navigateToFeature(id: id)
                
            case .custom(let path):
                print("Custom deep link: \(path)")
                
            case .unknown:
                print("Unknown deep link: \(url)")
            }
        }
    }
}

// MARK: - Deep Link Examples

/*
 
 DEEP LINK EXAMPLES:
 
 1. Premium/Paywall:
    appstarter://premium
 
 2. Settings:
    appstarter://settings
 
 3. Specific Feature:
    appstarter://feature/profile
    appstarter://feature/notifications
 
 4. Custom:
    appstarter://custom/path
 
 SETUP IN INFO.PLIST:
 
 Add URL scheme to Info.plist:
 
 <key>CFBundleURLTypes</key>
 <array>
     <dict>
         <key>CFBundleURLSchemes</key>
         <array>
             <string>appstarter</string>
         </array>
         <key>CFBundleURLName</key>
         <string>com.yourcompany.appstarter</string>
     </dict>
 </array>
 
 USAGE IN APP:
 
 ```swift
 @main
 struct AppStarterApp: App {
     @StateObject private var coordinator = AppCoordinator()
     
     var body: some Scene {
         WindowGroup {
             coordinator.rootView
                 .onOpenURL { url in
                     coordinator.handle(deepLink: url)
                 }
         }
     }
 }
 ```
 
 TESTING:
 
 In Terminal:
 ```bash
 xcrun simctl openurl booted appstarter://premium
 xcrun simctl openurl booted appstarter://settings
 ```
 
 */

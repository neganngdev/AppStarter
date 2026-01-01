# 🚀 AppStarter - iOS App Template

A production-ready iOS app template designed for indie developers who want to ship niche apps quickly. Clone this template, customize it, and launch your app in 3-5 days.

## ✨ Features

- **🏗️ Clean Architecture**: MVVM pattern with clear separation of concerns
- **⚙️ Centralized Configuration**: Easy customization through `AppConfig.swift`
- **🌍 Environment Management**: Development, staging, and production configurations
- **🎨 Design System Ready**: Organized UI structure for consistent design
- **📦 Modular Structure**: Feature-based organization for scalability
- **🔧 Production Ready**: Includes analytics, monetization, and crash reporting setup
- **📱 iOS 16.0+**: Modern SwiftUI and Swift 5.9+ features

## 📁 Project Structure

```
AppStarter/
├── App/                          # App entry point and lifecycle
│   └── AppStarterApp.swift       # Main app file with initialization
├── Configuration/                # Centralized app configuration
│   ├── AppConfig.swift          # App settings and customization
│   └── Environment.swift        # Environment-specific configs
├── Core/                        # Shared utilities and services
│   ├── Extensions/              # Swift extensions
│   ├── Utilities/               # Helper classes
│   ├── Storage/                 # Data persistence
│   ├── Networking/              # API client
│   ├── Analytics/               # Analytics integration
│   └── Monetization/            # In-app purchases
├── UI/                          # User interface layer
│   ├── DesignSystem/            # Colors, fonts, spacing
│   ├── Components/              # Reusable UI components
│   ├── Screens/                 # Common screens (onboarding, settings)
│   └── Modifiers/               # Custom view modifiers
├── Features/                    # App-specific features (MVVM)
│   └── README.md               # Feature development guide
├── Resources/                   # Assets and media
│   └── Assets.xcassets         # Images, colors, icons
└── SupportingFiles/            # Supporting files
    └── Info.plist              # App metadata
```

## 🎯 Quick Start

### 1. Clone or Duplicate This Template

```bash
# Clone the template
git clone <repository-url> MyNewApp
cd MyNewApp

# Remove git history to start fresh
rm -rf .git
git init
```

### 2. Customize App Configuration

Open `Configuration/AppConfig.swift` and update:

```swift
// CUSTOMIZE: Change these values for each new app
static let appName = "MyNewApp"
static let appDisplayName = "My New App"
static let bundleIDPrefix = "com.yourcompany"

// CUSTOMIZE: Define your app's visual identity
static let primaryColor = Color.blue
static let accentColor = Color.purple

// CUSTOMIZE: Enable/disable features
static let hasOnboarding = true
static let hasSubscription = true
static let hasAnalytics = true

// CUSTOMIZE: Add your API keys
static let revenueCatAPIKey = "YOUR_REVENUECAT_KEY_HERE"
static let analyticsAPIKey = "YOUR_ANALYTICS_KEY_HERE"
```

### 3. Update Project Settings

1. Open Xcode
2. Create a new project or update existing:
   - Product Name: Your app name
   - Bundle Identifier: Match `AppConfig.bundleID`
   - Minimum iOS Version: 16.0
3. Add these source files to your project

### 4. Customize Branding

- Update app icon in `Resources/Assets.xcassets`
- Customize colors in `AppConfig.swift`
- Add your app's fonts (if custom fonts are needed)

### 5. Build Your Features

Create your app-specific features in the `Features/` directory. See [Features/README.md](Features/README.md) for detailed guidelines.

## 📝 Customization Checklist

Use this checklist when creating a new app from this template:

### Required Changes
- [ ] Update `appName` and `appDisplayName` in `AppConfig.swift`
- [ ] Update `bundleIDPrefix` in `AppConfig.swift`
- [ ] Set brand colors (`primaryColor`, `accentColor`)
- [ ] Add app icon to `Assets.xcassets`
- [ ] Update `supportEmail` and `developerName`
- [ ] Update privacy policy, terms, and support URLs

### Optional Changes
- [ ] Configure feature flags (onboarding, subscriptions, etc.)
- [ ] Add RevenueCat API key (if using subscriptions)
- [ ] Add analytics API key (if using analytics)
- [ ] Customize typography settings
- [ ] Update environment API URLs in `Environment.swift`
- [ ] Add social media handles

### Before Launch
- [ ] Test in all environments (dev, staging, production)
- [ ] Update version and build numbers
- [ ] Configure App Store Connect
- [ ] Test subscription flows (if applicable)
- [ ] Verify analytics tracking
- [ ] Test crash reporting
- [ ] Review and update Info.plist

## 🏗️ Architecture

This template follows the **MVVM (Model-View-ViewModel)** pattern:

- **Models**: Data structures and business logic
- **Views**: SwiftUI views (UI layer)
- **ViewModels**: Presentation logic and state management
- **Services**: Data access and API calls

See [Features/README.md](Features/README.md) for detailed architecture guidelines and examples.

## 🔧 Core Components

### AppConfig
Centralized configuration for easy app customization. All app-specific settings in one place.

### Environment
Manages different build configurations (development, staging, production) with environment-specific settings.

### Features
Modular feature organization following MVVM pattern. Each feature is self-contained and testable.

## 🎨 Design System

The template includes a design system structure for consistent UI:

- **Colors**: Defined in `AppConfig.swift`
- **Typography**: Font sizes and styles
- **Components**: Reusable UI components
- **Modifiers**: Custom view modifiers

## 📦 Dependencies

This template starts with **zero external dependencies** to keep it lightweight. Add dependencies as needed:

### Recommended Packages
- **RevenueCat**: Subscription management
- **Firebase Analytics**: User analytics
- **Sentry/Crashlytics**: Crash reporting

Add via Swift Package Manager in Xcode: File → Add Packages...

## 🧪 Testing

### Unit Tests
Create unit tests for:
- ViewModels (business logic)
- Services (data operations)
- Models (validation logic)

### UI Tests
Test critical user flows:
- Onboarding
- Main features
- Subscription flow

## 🚀 Deployment

### Development
```bash
# Run in simulator
⌘ + R in Xcode
```

### Staging
1. Change build configuration to "Staging"
2. Build and test on TestFlight

### Production
1. Update version and build number
2. Archive and upload to App Store Connect
3. Submit for review

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Swift Language Guide](https://docs.swift.org/swift-book/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## 💡 Tips for Rapid Development

1. **Start with MVP**: Enable only essential features initially
2. **Reuse Components**: Build a library of reusable UI components
3. **Test Early**: Write tests as you build features
4. **Iterate Fast**: Use development environment for quick iterations
5. **Document as You Go**: Add comments for future reference

## 🤝 Contributing

This is a personal template, but feel free to fork and customize for your needs!

## 📄 License

This template is provided as-is for personal and commercial use.

---

**Ready to build your next app?** Start customizing and ship fast! 🚀

## 🆘 Support

For questions or issues:
- Email: [Your support email]
- Website: [Your website]

---

**Version**: 1.0.0  
**Last Updated**: 2026-01-01  
**Minimum iOS**: 16.0

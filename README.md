# AppStarter Template

**One-week iOS app starter template for indie developers.**

Build and ship iOS apps faster with this production-ready template featuring onboarding, subscriptions, analytics, and a complete design system.

## 🎯 What's Included

### Core Systems
- ✅ **App Coordinator** - Smart navigation flow with deep linking
- ✅ **Configuration** - Environment-based settings (Debug/Release)
- ✅ **Extensions** - String, Date, Color, View, Collection utilities
- ✅ **Storage** - UserDefaults, Keychain, FileStorage managers
- ✅ **Networking** - Type-safe API client with async/await
- ✅ **Analytics** - Multi-provider abstraction (Firebase, Mixpanel ready)
- ✅ **Monetization** - RevenueCat subscription wrapper

### UI & UX
- ✅ **Design System** - Colors, fonts, spacing, radius, shadows
- ✅ **UI Components** - Buttons, text fields, cards, loading, errors
- ✅ **Onboarding** - Beautiful onboarding flow with coordinator
- ✅ **Paywall** - Conversion-optimized subscription screen
- ✅ **Settings** - Complete settings screen with all common options
- ✅ **Main App** - Tab-based navigation structure

### Utilities
- ✅ **View Modifiers** - Toast, loading, keyboard handling, conditionals
- ✅ **Haptic Feedback** - Easy-to-use haptic manager
- ✅ **Logger** - Debug/production logging with os.Logger
- ✅ **App Review** - Smart review request timing

## 🚀 Quick Start

### 1. Clone or Download
```bash
git clone https://github.com/neganngdev/AppStarter.git MyNewApp
cd MyNewApp
rm -rf .git  # Remove template git history
git init     # Start fresh
```

### 2. Customize Configuration
Open `Configuration/AppConfig.swift` and update:
```swift
static let appName = "Your App Name"
static let bundleIdentifier = "com.yourcompany.yourapp"
static let supportEmail = "support@yourapp.com"
// ... etc
```

### 3. Update Project Settings
- Open in Xcode
- Change bundle identifier
- Update app icon (Assets.xcassets)
- Update app name in Info.plist

### 4. Configure Services (Optional)
- Add RevenueCat API key for subscriptions
- Add Firebase/Mixpanel for analytics
- Configure deep link URL scheme

### 5. Build Your Features
Add your features in `Features/` folder following MVVM pattern.

See [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) for detailed steps.

## 📁 Project Structure

```
AppStarter/
├── App/
│   └── AppStarterApp.swift          # App entry point
├── Configuration/
│   ├── AppConfig.swift               # App configuration
│   └── Environment.swift             # Environment settings
├── Core/
│   ├── Analytics/                    # Analytics system
│   ├── Extensions/                   # Swift extensions
│   ├── Monetization/                 # Subscription system
│   ├── Networking/                   # API client
│   ├── Storage/                      # Data persistence
│   ├── Utilities/                    # Haptics, logger, reviews
│   ├── AppCoordinator.swift          # Navigation coordinator
│   ├── AppState.swift                # App state management
│   └── DeepLinkHandler.swift         # Deep link routing
├── Features/
│   └── README.md                     # How to add features
├── UI/
│   ├── Components/                   # Reusable UI components
│   ├── DesignSystem/                 # Design tokens
│   ├── Modifiers/                    # View modifiers
│   └── Screens/                      # App screens
│       ├── Main/                     # Home, tabs, content
│       ├── Onboarding/               # Onboarding flow
│       ├── Paywall/                  # Subscription paywall
│       └── Settings/                 # Settings screen
└── SupportingFiles/
    └── Info.plist
```

## ✅ Customization Checklist

### Essential (Required for every app)
- [ ] Update `AppConfig.swift` with your app details
- [ ] Change bundle identifier in Xcode
- [ ] Replace app icon in Assets.xcassets
- [ ] Update app name in Info.plist
- [ ] Configure onboarding pages in `OnboardingCoordinator.swift`
- [ ] Update subscription plans in `SubscriptionPlan.swift`
- [ ] Add your privacy policy and terms URLs

### Optional (Based on your needs)
- [ ] Add RevenueCat API key if using subscriptions
- [ ] Configure analytics providers (Firebase, Mixpanel)
- [ ] Customize design system colors/fonts
- [ ] Add custom deep link URL scheme
- [ ] Configure app review timing thresholds
- [ ] Add custom fonts to design system
- [ ] Update placeholder views with your features

See [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) for detailed instructions.

## ⏱️ Time Estimate

Based on building a typical indie app:

- **Setup & Customize**: 1-2 hours
- **Build Features**: 3-4 days
- **Polish & Test**: 1 day
- **App Store Prep**: 1 day

**Total: ~1 week per app** 🎉

## 🏗️ Architecture

This template follows modern iOS development best practices:

- **MVVM Pattern** - Model-View-ViewModel architecture
- **Swift Concurrency** - async/await throughout
- **Protocol-Oriented** - Flexible, testable code
- **Dependency Injection** - Singleton managers with clear APIs
- **SwiftUI-First** - Modern declarative UI

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture overview.

## 💡 Tips & Best Practices

### Adding Features
1. Create folder in `Features/YourFeature/`
2. Follow MVVM: Models, Views, ViewModels
3. Use design system components
4. Track analytics events
5. Add haptic feedback for interactions

### Design System
- Always use design tokens (colors, spacing, fonts)
- Use provided view modifiers for consistency
- Create reusable components in `UI/Components/`

### Analytics
- Track key user actions
- Use type-safe events from `AnalyticsEvent.swift`
- Add custom events as needed

### Subscriptions
- Test with StoreKit Configuration file
- Use sandbox for testing
- Track subscription events in analytics

### Performance
- Use `Logger` for debugging (auto-disabled in production)
- Lazy load heavy content
- Cache network responses when appropriate

## 🔧 Common Tasks

### Change App Colors
Edit `UI/DesignSystem/AppColors.swift`:
```swift
static let appPrimary = Color(hex: "#YOUR_COLOR")
```

### Add Onboarding Page
Edit `OnboardingCoordinator.swift`:
```swift
pages = [
    OnboardingPage(icon: "star.fill", title: "Welcome", description: "..."),
    // Add more pages
]
```

### Add Subscription Plan
Edit `SubscriptionPlan.swift`:
```swift
static let samplePlans = [
    SubscriptionPlan(id: "monthly", name: "Monthly", price: "$9.99", ...)
]
```

### Track Custom Event
```swift
await AnalyticsManager.shared.trackEvent("custom_event", parameters: [
    "key": "value"
])
```

### Show Toast Notification
```swift
.toast($showToast, message: "Success!", type: .success)
```

## 📚 Documentation

- [Features Guide](Features/README.md) - How to add features
- [Customization Guide](CUSTOMIZATION_GUIDE.md) - Step-by-step customization
- [Architecture Overview](ARCHITECTURE.md) - Design decisions and patterns

## 🛠️ Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## 📝 License

This template is provided as-is for indie developers to use in their projects.

## 🙏 Credits

Built with ❤️ for indie iOS developers who want to ship apps faster.

---

**Ready to build your next app?** Start customizing! 🚀

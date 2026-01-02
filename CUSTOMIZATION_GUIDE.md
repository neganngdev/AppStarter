# Customization Guide

Step-by-step guide to customize AppStarter for your new app.

## 🎯 Overview

This guide walks you through customizing the template for each new app you build. Follow these steps in order for the smoothest experience.

## ⏱️ Estimated Time: 1-2 hours

---

## Step 1: Project Setup (15 minutes)

### 1.1 Clone and Rename

```bash
git clone https://github.com/neganngdev/AppStarter.git MyNewApp
cd MyNewApp
rm -rf .git
git init
```

### 1.2 Open in Xcode

- Open `AppStarter.xcodeproj`
- Select project in navigator
- Change "Display Name" to your app name
- Change "Bundle Identifier" to `com.yourcompany.yourapp`

### 1.3 Update Team & Signing

- Select your development team
- Enable automatic signing
- Verify bundle ID is unique

---

## Step 2: App Configuration (20 minutes)

### 2.1 Update AppConfig.swift

Location: `Configuration/AppConfig.swift`

```swift
// MARK: - App Information
static let appName = "Your App Name"
static let bundleIdentifier = "com.yourcompany.yourapp"
static let version = "1.0.0"  // Keep in sync with Xcode

// MARK: - Contact & Support
static let supportEmail = "support@yourapp.com"
static let websiteURL = "https://yourapp.com"
static let privacyPolicyURL = "https://yourapp.com/privacy"
static let termsOfServiceURL = "https://yourapp.com/terms"

// MARK: - App Store
static let appStoreID = "123456789"  // ⚠️ REQUIRED: Update with your App Store ID from App Store Connect

// MARK: - Monetization
static let requiresSubscription = false  // Set true if paywall required
```

**Important**: The `appStoreID` is required for app ratings and App Store links in the Settings view. Get your App Store ID from App Store Connect after creating your app listing.

### 2.2 Update Environment.swift

Location: `Configuration/Environment.swift`

```swift
// Set API base URLs for each environment
case debug:
    return "https://api-dev.yourapp.com"
case release:
    return "https://api.yourapp.com"
```

---

## Step 3: Visual Identity (30 minutes)

### 3.1 App Icon

- Design 1024x1024 app icon
- Add to `Assets.xcassets/AppIcon`
- Use all required sizes

### 3.2 Design System Colors

Location: `Core/Extensions/Color+Extensions.swift`

```swift
// Brand Colors
static let appPrimary = Color(hex: "#YOUR_PRIMARY_COLOR")
static let appSecondary = Color(hex: "#YOUR_SECONDARY_COLOR")
static let appAccent = Color(hex: "#YOUR_ACCENT_COLOR")
static let appPremium = Color(hex: "#YOUR_PREMIUM_COLOR")
```

**⚠️ Important - Using Design System Colors**:
Always use explicit `Color.` prefixes when applying colors in views to avoid type ambiguity:

```swift
// ✅ Correct
Text("Hello")
    .foregroundColor(Color.appPrimary)
    .background(Color.appBackground)

// ❌ Wrong - causes "Ambiguous use" compilation errors
Text("Hello")
    .foregroundColor(.appPrimary)
    .background(.appBackground)
```

This is required because both `Color` and `Font` extensions define properties with the same names (e.g., `appPrimary`), which confuses Swift's type inference when using shorthand notation.

### 3.3 Custom Fonts (Optional)

If using custom fonts:

1. Add font files to project
2. Add to Info.plist under "Fonts provided by application"
3. Update `UI/DesignSystem/AppFonts.swift`:

```swift
static let customFontName = "YourFont-Regular"
```

**⚠️ Important - Using Design System Fonts**:
Same as colors, always use explicit `Font.` prefixes:

```swift
// ✅ Correct
Text("Title").font(Font.appTitle)
Text("Body").font(Font.appBody)

// ❌ Wrong - causes "Ambiguous use" compilation errors
Text("Title").font(.appTitle)
Text("Body").font(.appBody)
```

---

## Step 4: Onboarding (15 minutes)

### 4.1 Configure Onboarding Pages

Location: `UI/Screens/Onboarding/OnboardingCoordinator.swift`

```swift
self.pages = [
    OnboardingPage(
        icon: "star.fill",
        title: "Welcome to \(AppConfig.appName)",
        description: "Your app description here"
    ),
    OnboardingPage(
        icon: "bell.fill",
        title: "Stay Updated",
        description: "Get notifications about important updates"
    ),
    OnboardingPage(
        icon: "checkmark.circle.fill",
        title: "Ready to Go",
        description: "Let's get started!"
    )
]
```

### 4.2 Customize Onboarding Flow

In `Core/AppCoordinator.swift`, adjust the flow:

```swift
private func completeOnboarding() {
    onboardingCoordinator.completeOnboarding()

    // Choose next step:
    // currentState = .permissions  // Request permissions
    // currentState = .paywall      // Show paywall
    currentState = .main            // Go to main app
}
```

---

## Step 5: Subscriptions (20 minutes)

### 5.1 Configure Subscription Plans

Location: `UI/Screens/Paywall/SubscriptionPlan.swift`

```swift
static let samplePlans: [SubscriptionPlan] = [
    SubscriptionPlan(
        id: "monthly",
        name: "Monthly",
        price: "$9.99",
        period: "month",
        features: [
            "Unlimited access",
            "Ad-free experience",
            "Premium support"
        ],
        trialDays: 7
    ),
    SubscriptionPlan(
        id: "yearly",
        name: "Yearly",
        price: "$79.99",
        period: "year",
        features: [
            "Unlimited access",
            "Ad-free experience",
            "Premium support",
            "Best value"
        ],
        isPopular: true,
        savingsText: "Save 33%"
    )
]
```

### 5.2 Add RevenueCat (If Using)

1. Create account at [revenuecat.com](https://revenuecat.com)
2. Add SDK via SPM: `https://github.com/RevenueCat/purchases-ios`
3. Update `Core/Monetization/PurchaseManager.swift`:

```swift
private let apiKey = "YOUR_REVENUECAT_API_KEY"
```

### 5.3 Configure Paywall Requirement

In `Core/AppCoordinator.swift`:

```swift
// Uncomment to require subscription
if !status.isActive && AppConfig.requiresSubscription {
    currentState = .paywall
    return
}
```

---

## Step 6: Analytics (15 minutes)

### 6.1 Add Analytics Provider (Optional)

**For Firebase:**

1. Add Firebase SDK via SPM
2. Add GoogleService-Info.plist
3. Create `FirebaseAnalyticsProvider.swift` in `Core/Analytics/`
4. Register in `AppStarterApp.swift`:

```swift
await AnalyticsManager.shared.addProvider(FirebaseAnalyticsProvider())
```

**For Mixpanel:**

1. Add Mixpanel SDK via SPM
2. Create `MixpanelAnalyticsProvider.swift`
3. Register provider with your token

### 6.2 Add Custom Events

Location: `Core/Analytics/AnalyticsEvent.swift`

```swift
// Add your custom events
static func customAction(value: String) -> AnalyticsEvent {
    AnalyticsEvent(
        name: "custom_action",
        parameters: ["value": value]
    )
}
```

---

## Step 7: Deep Links (10 minutes)

### 7.1 Configure URL Scheme

Location: `SupportingFiles/Info.plist`

Add your URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>yourapp</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.yourapp</string>
    </dict>
</array>
```

### 7.2 Update Deep Link Handler

Location: `Core/DeepLinkHandler.swift`

```swift
private let scheme = "yourapp"  // Change to your scheme
```

---

## Step 8: Main App Content (Varies)

### 8.1 Choose Navigation Style

In `Core/AppCoordinator.swift`, replace `MainAppView()` with:

**Option 1: Tab-based (Recommended)**

```swift
MainTabView()
```

**Option 2: Single screen**

```swift
ContentView()
```

### 8.2 Customize Home Screen

Location: `UI/Screens/Main/HomeView.swift`

Replace placeholder content with your actual home screen.

### 8.3 Add Your Features

Create features in `Features/` folder. See [Features/README.md](Features/README.md).

---

## Step 9: Settings & Legal (15 minutes)

### 9.1 Update Settings

Location: `UI/Screens/Settings/SettingsView.swift`

Customize sections as needed (already mostly configured).

### 9.2 Create Legal Pages

Create and host:

- Privacy Policy at `AppConfig.privacyPolicyURL`
- Terms of Service at `AppConfig.termsOfServiceURL`

---

## Step 10: App Review Settings (5 minutes)

### 10.1 Configure Review Timing

Location: `Core/Utilities/AppReviewManager.swift`

```swift
private let minimumLaunchCount = 10      // Adjust as needed
private let minimumActionCount = 5       // Adjust as needed
```

### 10.2 Track Launch

Already configured in `AppCoordinator.swift`:

```swift
init() {
    AppReviewManager.shared.trackLaunch()
}
```

---

## 📐 Coding Guidelines & Best Practices

### iOS 16 Compatibility

This template supports **iOS 16+**. When using SwiftUI modifiers, use iOS 16 compatible syntax:

#### onChange Modifier

```swift
// ✅ iOS 16+ compatible (single parameter)
.onChange(of: searchText) { newValue in
    performSearch(newValue)
}

// ❌ iOS 17+ only (two parameters)
.onChange(of: searchText) { oldValue, newValue in
    // This will not compile on iOS 16
}
```

### Design System Usage

#### Always Use Explicit Type Prefixes

Due to property naming conflicts between `Color` and `Font` extensions, you **must** use explicit type prefixes:

```swift
// ✅ Correct - Always use explicit prefixes
VStack {
    Text("Title")
        .font(Font.appTitle)
        .foregroundColor(Color.appPrimary)

    Text("Body")
        .font(Font.appBody)
        .foregroundColor(Color.appSecondary)
}
.background(Color.appBackground)

// ❌ Wrong - Causes "Ambiguous use" compiler errors
VStack {
    Text("Title")
        .font(.appTitle)           // Error!
        .foregroundColor(.appPrimary)  // Error!
}
```

#### Why This Is Required

Both `Color+Extensions.swift` and `AppFonts.swift` define properties with similar names (`appPrimary`, `appSecondary`, etc.). Swift's type inference cannot determine which type you mean when using shorthand notation like `.appPrimary`, resulting in compilation errors.

### URL Handling

For iOS 16 compatibility, use `UIApplication.shared.open()` instead of the newer `openURL` environment:

```swift
// ✅ iOS 16+ compatible
if let url = URL(string: "https://example.com") {
    UIApplication.shared.open(url)
}

// ❌ iOS 17+ only
@Environment(\.openURL) var openURL
openURL(url)
```

---

## ✅ Final Checklist

Before building your first version:

### Essential

- [ ] Updated `AppConfig.swift` with all app details
- [ ] Changed bundle identifier
- [ ] Added app icon
- [ ] Configured onboarding pages
- [ ] Set up subscription plans (if using)
- [ ] Updated design system colors
- [ ] Created privacy policy and terms
- [ ] Tested onboarding flow
- [ ] Tested paywall (if using)
- [ ] Tested settings screen

### Optional

- [ ] Added RevenueCat API key
- [ ] Configured analytics provider
- [ ] Added custom fonts
- [ ] Configured deep links
- [ ] Added custom events
- [ ] Customized app review timing

### Before App Store

- [ ] Updated version and build number
- [ ] Added App Store ID to `AppConfig`
- [ ] Tested on real device
- [ ] Tested all subscription flows
- [ ] Verified analytics tracking
- [ ] Tested deep links
- [ ] Created App Store screenshots
- [ ] Prepared App Store description

---

## 🎉 You're Ready!

Your app is now customized and ready for feature development. Start building in the `Features/` folder!

## 📚 Next Steps

1. Read [Features/README.md](Features/README.md) for how to add features
2. Read [ARCHITECTURE.md](ARCHITECTURE.md) for architecture overview
3. Start building your features!

## 💡 Tips

- Commit often as you customize
- Test on a real device early
- Use design system components for consistency
- Track analytics for key user actions
- Don't over-customize before validating your idea

---

**Questions?** Check the main [README.md](README.md) or architecture docs.

# Architecture Overview

This document explains the architecture, design decisions, and patterns used in the AppStarter template.

## 🎯 Design Philosophy

The AppStarter template is built with these principles:

1. **Speed to Market** - Get apps shipped in ~1 week
2. **Maintainability** - Clean, organized, easy to modify
3. **Scalability** - Grows with your app
4. **Best Practices** - Modern Swift patterns
5. **Flexibility** - Easy to customize

## 🏗️ Architecture Pattern

### MVVM (Model-View-ViewModel)

The template uses MVVM architecture:

```
┌─────────────┐
│    View     │ ← SwiftUI Views
└──────┬──────┘
       │ binds to
┌──────▼──────┐
│ ViewModel   │ ← @Published properties, business logic
└──────┬──────┘
       │ uses
┌──────▼──────┐
│   Model     │ ← Data structures
└─────────────┘
```

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Reactive UI updates with @Published
- Easy to understand and maintain

## 📐 Project Structure

### Core Layer
Foundation of the app - reusable across all apps.

```
Core/
├── Analytics/          # Analytics abstraction
├── Extensions/         # Swift extensions
├── Monetization/       # Subscription system
├── Networking/         # API client
├── Storage/            # Data persistence
├── Utilities/          # Haptics, logger, reviews
├── AppCoordinator.swift    # Navigation flow
├── AppState.swift          # App state enum
└── DeepLinkHandler.swift   # Deep link routing
```

**Key Components:**

- **AppCoordinator**: Manages app-wide navigation flow
- **Managers**: Singleton managers for cross-cutting concerns
- **Extensions**: Utility methods on standard types
- **Protocols**: Flexible, testable abstractions

### UI Layer
User interface components and screens.

```
UI/
├── Components/         # Reusable UI components
├── DesignSystem/       # Design tokens
├── Modifiers/          # View modifiers
└── Screens/            # App screens
    ├── Main/           # Home, tabs
    ├── Onboarding/     # Onboarding flow
    ├── Paywall/        # Subscription screen
    └── Settings/       # Settings screen
```

**Key Concepts:**

- **Design System**: Centralized design tokens
- **Components**: Reusable, composable UI
- **Modifiers**: Reusable view modifications
- **Screens**: Complete screen implementations

### Features Layer
Your app-specific features go here.

```
Features/
└── YourFeature/
    ├── Models/         # Data models
    ├── Views/          # SwiftUI views
    ├── ViewModels/     # Business logic
    └── Services/       # Feature-specific services
```

## 🔄 Data Flow

### 1. User Interaction
```
User taps button
    ↓
View calls ViewModel method
    ↓
ViewModel updates @Published property
    ↓
View automatically re-renders
```

### 2. Network Request
```
ViewModel calls NetworkManager
    ↓
NetworkManager makes async request
    ↓
Response decoded to Model
    ↓
ViewModel updates @Published property
    ↓
View updates
```

### 3. Analytics Event
```
User action occurs
    ↓
Track event via AnalyticsManager
    ↓
Event sent to all registered providers
    ↓
Logged to console (debug) / sent to service (production)
```

## 🎨 Design System

### Token-Based Design

All design values are centralized:

```swift
// Colors
Color.appPrimary
Color.appSecondary

// Spacing
AppSpacing.small
AppSpacing.medium

// Typography
Font.appTitle
Font.appBody

// Radius
AppRadius.small
AppRadius.medium

// Shadows
.appShadow(.medium)
```

**Benefits:**
- Consistent UI
- Easy theme changes
- Dark mode support
- Maintainable

### Component Hierarchy

```
Design Tokens (Colors, Fonts, Spacing)
    ↓
Basic Components (Button, TextField, Card)
    ↓
Composite Components (FeatureRow, PlanCard)
    ↓
Screens (HomeView, PaywallView)
```

## 🔌 Dependency Management

### Singleton Pattern

Used for managers that need global access:

```swift
class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() { }
}
```

**When to use:**
- Analytics
- Purchase management
- Logging
- Haptics

**Benefits:**
- Easy access throughout app
- Single source of truth
- Lifecycle management

### Protocol-Oriented Design

Used for flexibility and testing:

```swift
protocol AnalyticsProvider {
    func trackEvent(_ event: AnalyticsEvent) async
}

class FirebaseAnalyticsProvider: AnalyticsProvider { }
class MixpanelAnalyticsProvider: AnalyticsProvider { }
```

**Benefits:**
- Swap implementations easily
- Testable with mocks
- Multiple providers

## 🔀 Navigation Flow

### App Coordinator Pattern

Centralized navigation logic:

```
App Launch
    ↓
AppCoordinator determines state
    ↓
┌─────────────────────────┐
│ First time?             │ → Onboarding → Main
│ Needs subscription?     │ → Paywall → Main
│ Ready to use?           │ → Main
└─────────────────────────┘
```

**Benefits:**
- Single source of truth for navigation
- Easy to modify flow
- Testable navigation logic
- Deep link handling

### State Management

```swift
enum AppState {
    case loading
    case onboarding
    case paywall
    case main
    case permissions
}
```

Clear, predictable state transitions.

## 💾 Data Persistence

### Three-Tier Storage

```
UserDefaults          → Simple key-value (preferences)
Keychain              → Secure storage (tokens, sensitive data)
FileStorage           → Files and images
```

**When to use each:**

- **UserDefaults**: Settings, flags, simple data
- **Keychain**: API tokens, passwords, sensitive data
- **FileStorage**: Images, documents, large data

## 🌐 Networking

### Type-Safe API Client

```swift
protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

// Usage
let users: [User] = try await NetworkManager.shared.request(
    endpoint: UserEndpoint.list
)
```

**Benefits:**
- Type-safe requests
- Automatic JSON decoding
- Error handling
- Async/await

## 📊 Analytics

### Multi-Provider Architecture

```
AnalyticsManager
    ↓
┌──────────────────────────┐
│ Firebase                 │
│ Mixpanel                 │
│ Console (debug)          │
│ Your custom provider     │
└──────────────────────────┘
```

**Benefits:**
- Switch providers easily
- Multiple providers simultaneously
- Type-safe events
- GDPR compliance built-in

## 💰 Monetization

### RevenueCat Wrapper

Abstraction over RevenueCat SDK:

```swift
PurchaseManager
    ↓
RevenueCat SDK
    ↓
App Store
```

**Benefits:**
- Simplified API
- Error handling
- Subscription status tracking
- Easy to swap providers

## 🎯 Key Design Decisions

### 1. SwiftUI-First
**Decision**: Use SwiftUI for all UI
**Rationale**: Modern, declarative, less code
**Trade-off**: iOS 16+ requirement

### 2. Async/Await
**Decision**: Use Swift concurrency throughout
**Rationale**: Cleaner async code, better performance
**Trade-off**: Requires understanding of async/await

### 3. Protocol-Oriented
**Decision**: Use protocols for abstractions
**Rationale**: Flexibility, testability
**Trade-off**: Slightly more code

### 4. Singleton Managers
**Decision**: Use singletons for managers
**Rationale**: Easy access, single source of truth
**Trade-off**: Global state (managed carefully)

### 5. Token-Based Design
**Decision**: Centralize all design values
**Rationale**: Consistency, easy theming
**Trade-off**: Requires discipline to use

## 🧪 Testing Strategy

### What to Test

1. **ViewModels** - Business logic
2. **Managers** - Core functionality
3. **Extensions** - Utility methods
4. **Network** - API integration

### What Not to Test

1. **Views** - SwiftUI handles this
2. **Simple models** - Just data
3. **Coordinators** - Integration tested

## 📈 Scalability

### Adding Features

```
Features/NewFeature/
├── Models/
│   └── FeatureModel.swift
├── Views/
│   └── FeatureView.swift
├── ViewModels/
│   └── FeatureViewModel.swift
└── Services/
    └── FeatureService.swift
```

Each feature is self-contained and follows MVVM.

### Growing the App

1. **More screens**: Add to `UI/Screens/`
2. **More components**: Add to `UI/Components/`
3. **More features**: Add to `Features/`
4. **More utilities**: Add to `Core/Utilities/`

## 🔒 Security Considerations

### Sensitive Data
- API keys in environment variables
- Tokens in Keychain
- Never commit secrets

### Network Security
- HTTPS only
- Certificate pinning (if needed)
- Request signing (if needed)

### User Privacy
- Analytics opt-out
- GDPR compliance
- Clear privacy policy

## ⚡ Performance

### Optimization Strategies

1. **Lazy Loading**: Load data as needed
2. **Caching**: Cache network responses
3. **Image Optimization**: Compress images
4. **Async Operations**: Don't block main thread
5. **Pagination**: Load data in chunks

### Monitoring

- Use `Logger` for debugging
- Track performance metrics in analytics
- Monitor crash reports

## 🎓 Learning Resources

### Recommended Reading

- [Swift Documentation](https://docs.swift.org)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [MVVM Pattern](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm)

### Best Practices

- Follow Swift API Design Guidelines
- Use meaningful names
- Keep functions small
- Comment complex logic
- Write tests for business logic

---

## 📝 Summary

The AppStarter template uses:

- **MVVM** for architecture
- **SwiftUI** for UI
- **Async/Await** for concurrency
- **Protocols** for flexibility
- **Singletons** for managers
- **Token-based** design system

This creates a **maintainable**, **scalable**, and **fast-to-build** foundation for iOS apps.

---

**Questions?** Check the main [README.md](README.md) or [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md).

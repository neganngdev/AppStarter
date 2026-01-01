# Configuration Files Guide

This document explains the configuration files in the AppStarter template.

## 📄 Files Overview

### 1. .gitignore
**Purpose**: Prevent sensitive files from being committed to git.

**What's Ignored:**
- Xcode user settings (`xcuserdata/`)
- Build artifacts (`build/`, `DerivedData/`)
- Secrets (`AppSecrets.swift`, `GoogleService-Info.plist`)
- Package manager files
- macOS files (`.DS_Store`)

**Important**: Never commit API keys or secrets!

### 2. AppSecrets.swift.template
**Purpose**: Template for storing API keys securely.

**Setup:**
1. Copy to `AppSecrets.swift`:
   ```bash
   cp Configuration/AppSecrets.swift.template Configuration/AppSecrets.swift
   ```
2. Add your actual API keys
3. `AppSecrets.swift` is git-ignored

**Keys to Add:**
- RevenueCat API key
- Mixpanel token
- Firebase (via GoogleService-Info.plist)
- Your backend API tokens

**Usage in Code:**
```swift
Purchases.configure(withAPIKey: AppSecrets.revenueCatAPIKey)
```

### 3. Info.plist
**Purpose**: App metadata and permissions.

**Key Sections:**

**App Information:**
- Bundle ID
- Version and build number
- Display name

**URL Schemes:**
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>appstarter</string>  <!-- Change to your scheme -->
</array>
```

**Privacy Permissions:**
Uncomment as needed:
- Camera: `NSCameraUsageDescription`
- Photo Library: `NSPhotoLibraryUsageDescription`
- Location: `NSLocationWhenInUseUsageDescription`
- Microphone: `NSMicrophoneUsageDescription`
- Contacts: `NSContactsUsageDescription`
- Face ID: `NSFaceIDUsageDescription`

**Custom Fonts:**
```xml
<key>UIAppFonts</key>
<array>
    <string>YourFont-Regular.ttf</string>
</array>
```

### 4. Localizable.strings
**Purpose**: Localized text strings.

**Usage in Code:**
```swift
Text(NSLocalizedString("app.name", comment: ""))
// or with String extension
Text("app.name".localized)
```

**Adding Languages:**
1. File > New > File > Strings File
2. Name: `Localizable.strings`
3. File Inspector > Localize
4. Select language
5. Add translations

**Structure:**
```
"key" = "Value";
"error.generic" = "Something went wrong";
```

## 🔒 Security Best Practices

### API Keys
1. **Never commit** `AppSecrets.swift`
2. **Use environment variables** in CI/CD
3. **Rotate keys** if exposed
4. **Different keys** for debug/release

### Secrets Management
```swift
// ✅ Good - Using AppSecrets
let apiKey = AppSecrets.revenueCatAPIKey

// ❌ Bad - Hardcoded
let apiKey = "sk_abc123..."
```

### Git Safety
```bash
# Check what will be committed
git status

# Verify secrets aren't staged
git diff --cached

# If accidentally staged
git reset HEAD AppSecrets.swift
```

## 📝 Customization Checklist

### For Each New App

**Info.plist:**
- [ ] Update bundle identifier
- [ ] Update display name
- [ ] Change URL scheme
- [ ] Uncomment needed permissions
- [ ] Add custom fonts (if any)

**AppSecrets.swift:**
- [ ] Copy template to AppSecrets.swift
- [ ] Add RevenueCat API key
- [ ] Add analytics tokens
- [ ] Add backend API keys

**Localizable.strings:**
- [ ] Update app name
- [ ] Add app-specific strings
- [ ] Add additional languages (if needed)

**.gitignore:**
- [ ] Verify it's working (`git status` shouldn't show secrets)
- [ ] Add app-specific ignores if needed

## 🌍 Localization

### Adding a New Language

1. **In Xcode:**
   - Project > Info > Localizations
   - Click "+" to add language
   - Select `Localizable.strings`

2. **Translate Strings:**
   ```
   // English (Localizable.strings)
   "welcome" = "Welcome";
   
   // Spanish (Localizable.strings (Spanish))
   "welcome" = "Bienvenido";
   ```

3. **Use in Code:**
   ```swift
   Text(NSLocalizedString("welcome", comment: ""))
   ```

### String Extension (Optional)
Add to `String+Extensions.swift`:
```swift
extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

// Usage
Text("welcome".localized)
```

## 🔧 Environment-Specific Configuration

### Debug vs Release

**In AppConfig.swift:**
```swift
#if DEBUG
static let apiBaseURL = "https://api-dev.yourapp.com"
#else
static let apiBaseURL = "https://api.yourapp.com"
#endif
```

**In AppSecrets.swift:**
```swift
#if DEBUG
static let revenueCatAPIKey = "DEBUG_KEY"
#else
static let revenueCatAPIKey = "PRODUCTION_KEY"
#endif
```

## 📱 Testing Configurations

### Test URL Scheme
```bash
# In Terminal (simulator)
xcrun simctl openurl booted appstarter://premium
```

### Test Localization
1. Edit Scheme > Run > Options
2. Change "Application Language"
3. Run app

### Verify .gitignore
```bash
# Should not show AppSecrets.swift
git status

# Should show as ignored
git check-ignore -v Configuration/AppSecrets.swift
```

## 🚨 Common Issues

### "AppSecrets not found"
**Solution**: Copy template to AppSecrets.swift
```bash
cp Configuration/AppSecrets.swift.template Configuration/AppSecrets.swift
```

### Accidentally Committed Secrets
**Solution**:
1. Remove from git history
2. Rotate all exposed keys
3. Update .gitignore
```bash
git rm --cached Configuration/AppSecrets.swift
git commit -m "Remove secrets"
```

### Localization Not Working
**Solution**:
1. Verify file is in project
2. Check target membership
3. Rebuild project

## 📚 Additional Resources

- [Apple Documentation: Info.plist](https://developer.apple.com/documentation/bundleresources/information_property_list)
- [Apple Documentation: Localization](https://developer.apple.com/documentation/xcode/localization)
- [Git Documentation: .gitignore](https://git-scm.com/docs/gitignore)

---

**Questions?** Check the main [README.md](../README.md) for more information.

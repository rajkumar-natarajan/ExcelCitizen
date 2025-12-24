# TestFlight Beta Testing Guide

## 🚀 Quick Start

### Step 1: Prepare Your Build

```bash
# Navigate to project
cd /Users/rajkumarnatarajan/Documents/raj/excel_citizen_flutter

# Clean and rebuild
flutter clean
flutter pub get
```

### Step 2: Archive and Upload (Recommended Method)

Since automatic provisioning requires registered devices, use xcodebuild with manual signing:

```bash
# Archive the app
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath build/Runner.xcarchive \
  archive DEVELOPMENT_TEAM=Y62BAT7CF4

# Export and upload to App Store Connect
xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportOptionsPlist ios/ExportOptions.plist \
  -exportPath build/ipa \
  -allowProvisioningUpdates
```

### Step 3: ExportOptions.plist

The project includes `ios/ExportOptions.plist` configured for App Store Connect upload:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>teamID</key>
    <string>Y62BAT7CF4</string>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>destination</key>
    <string>upload</string>
</dict>
</plist>
```

---

## 📋 Prerequisites

### Required Certificates & Profiles

1. **Apple Distribution Certificate**: `Apple Distribution: Rajkumar Natarajan (Y62BAT7CF4)`
2. **App Store Distribution Profile**: `ExcelCitizen AppStore`
3. **Bundle ID**: `com.curiousdev.excelCitizenFlutter`

### Creating Distribution Profile (if needed)

1. Go to [Apple Developer Portal - Profiles](https://developer.apple.com/account/resources/profiles/add)
2. Select **Distribution** → **App Store Connect**
3. Select App ID: `com.curiousdev.excelCitizenFlutter`
4. Select your Apple Distribution certificate
5. Name: `ExcelCitizen AppStore`
6. Download and double-click to install

---

## 📱 App Store Connect Setup

### 1. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: ExcelCitizen - Citizenship Test
   - **Primary Language**: English (Canada)
   - **Bundle ID**: com.curiousdev.excelCitizenFlutter
   - **SKU**: excelcitizen-ios-2024
   - **User Access**: Full Access

### 2. App Information

Navigate to **App Information** and fill:

| Field | Value |
|-------|-------|
| Name | ExcelCitizen - Citizenship Test |
| Subtitle | Canadian Citizenship Test Prep |
| Category | Education |
| Secondary Category | Reference |
| Content Rights | This app does not contain third-party content |

### 3. Pricing and Availability

- **Price**: Free (or your chosen price tier)
- **Availability**: All countries or specific regions
- **Pre-Order**: Optional

---

## 🔨 Building with Xcode GUI (Alternative)

### Manual Archive Process

1. **Open Xcode Workspace**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing**
   - Select `Runner` in Project Navigator
   - Go to **Signing & Capabilities**
   - Select your Team
   - Ensure "Automatically manage signing" is checked
   - Bundle ID: `com.curiousdev.excelCitizenFlutter`

3. **Set Build Configuration**
   - Product → Scheme → Edit Scheme
   - Set Run/Archive to **Release**

4. **Select Destination**
   - Product → Destination → **Any iOS Device (arm64)**

5. **Archive**
   - Product → Archive
   - Wait for archive to complete (~5-10 minutes)

6. **Upload to App Store Connect**
   - Window → Organizer
   - Select latest archive
   - Click **Distribute App**
   - Select **App Store Connect**
   - Select **Upload**
   - Follow prompts

---

## ✈️ TestFlight Configuration

### Internal Testing

**Internal testers** are members of your App Store Connect team.

1. Go to **TestFlight** tab in App Store Connect
2. Click **App Store Connect Users**
3. Add testers by selecting team members
4. Testers receive automatic invitation

**Limits:**
- Up to 100 internal testers
- Builds available immediately (no review)
- 90-day expiration

### External Testing

**External testers** are people outside your team.

1. Go to **TestFlight** → **External Testing**
2. Click **+** to create a new group (e.g., "Beta Testers")
3. Add build to the group
4. Submit for **Beta App Review** (required first time)
5. Add testers by email or create public link

**Limits:**
- Up to 10,000 external testers
- Requires Beta App Review (1-2 days)
- 90-day expiration

---

## 📧 Tester Invitation Email

### Email Template for Testers

```
Subject: Invitation to Test ExcelCitizen - Canadian Citizenship Test App

Hi [Name],

I'm excited to invite you to beta test ExcelCitizen, a new app to help prepare for the Canadian Citizenship Test!

📱 How to Join:

1. Install TestFlight from the App Store (if you haven't already)
   https://apps.apple.com/app/testflight/id899247664

2. Click this invitation link:
   [YOUR_TESTFLIGHT_LINK]

3. Open the app and start testing!

🔍 What to Test:
- Try all quiz modes (Quick, Standard, Full Mock)
- Test both English and French languages
- Check your progress and achievements
- Look for any bugs or issues

📝 How to Provide Feedback:
- Shake your device while in the app to report a bug
- Email feedback to: beta@curiousdev.app
- Take screenshots of any issues

Thank you for helping make ExcelCitizen better!

Best regards,
[Your Name]
```

---

## 📋 Beta App Review Information

When submitting for external testing, provide:

### Beta App Description
```
ExcelCitizen helps users prepare for the Canadian Citizenship Test with 180+ bilingual practice questions.

Features in this beta:
- 6 topic categories with comprehensive questions
- English and French language support
- Multiple test modes
- Progress tracking and achievements
- Smart learning algorithms

We're looking for feedback on:
- Question accuracy and clarity
- App stability and performance
- User experience improvements
- Any bugs or issues
```

### What to Test
```
1. Complete a practice session in each category
2. Try switching between English and French
3. Test all quiz modes (Quick, Standard, Full Mock)
4. Check progress tracking accuracy
5. Explore achievements and gamification features
6. Test bookmarking questions
7. Verify app works offline
```

### Feedback Email
```
beta@curiousdev.app
```

---

## 📊 Build Versions

### Version Numbering Convention

```
Version: MAJOR.MINOR.PATCH
Build: Sequential number

Example:
Version 1.0.0 (Build 1) - Initial beta
Version 1.0.0 (Build 2) - Bug fixes
Version 1.0.1 (Build 3) - Minor improvements
Version 1.1.0 (Build 4) - New features
```

### Update pubspec.yaml
```yaml
version: 1.0.0+1  # version+buildNumber
```

### Increment Build Number
```bash
# In pubspec.yaml, change:
version: 1.0.0+2  # Increment the number after +
```

---

## 🐛 Common Issues & Solutions

### Issue: Archive fails with signing error
```
Solution:
1. Xcode → Preferences → Accounts → Download Certificates
2. Clean build folder: Product → Clean Build Folder
3. Try again
```

### Issue: Upload fails
```
Solution:
1. Check internet connection
2. Verify App Store Connect app exists
3. Ensure bundle ID matches
4. Try Transporter app as alternative
```

### Issue: Build not appearing in TestFlight
```
Solution:
1. Wait 5-30 minutes for processing
2. Check email for any compliance issues
3. Verify build was uploaded successfully in Organizer
```

### Issue: Testers can't install
```
Solution:
1. Ensure tester accepted invitation
2. Check tester has TestFlight installed
3. Verify tester's device is compatible
4. Check build hasn't expired (90 days)
```

---

## 📝 TestFlight Build Notes Template

### For Each Build
```
Build 1.0.0 (X) - [Date]

🆕 What's New:
• Feature 1
• Feature 2
• Bug fix 1

🔍 Focus Areas for Testing:
• Test feature 1 thoroughly
• Check for any crashes
• Verify translations

⚠️ Known Issues:
• Issue 1 (will be fixed in next build)

📧 Feedback: beta@curiousdev.app
```

---

## ✅ TestFlight Checklist

### Before First Upload
- [ ] App Store Connect account active
- [ ] App created in App Store Connect
- [ ] Apple Developer Program membership active
- [ ] Signing certificates installed
- [ ] Provisioning profiles configured

### Before Each Build
- [ ] Version number updated
- [ ] Build number incremented
- [ ] All tests passing
- [ ] No analyzer warnings
- [ ] Release build tested locally

### After Upload
- [ ] Build appears in TestFlight (may take 30 min)
- [ ] No compliance issues reported
- [ ] External testing submitted for review (if applicable)
- [ ] Testers invited
- [ ] Build notes added

### During Testing
- [ ] Monitor crash reports
- [ ] Respond to tester feedback
- [ ] Track issues in bug tracker
- [ ] Plan fixes for next build

---

## 🔗 Useful Links

- [App Store Connect](https://appstoreconnect.apple.com)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Transporter App](https://apps.apple.com/app/transporter/id1450874784) (Alternative upload method)

---

## 📅 Recommended Testing Timeline

| Day | Activity |
|-----|----------|
| 1 | Upload first build, internal testing begins |
| 2-3 | Fix critical bugs from internal testing |
| 3 | Submit for external beta review |
| 4-5 | Beta review approval |
| 5-7 | External testing, gather feedback |
| 7-10 | Address feedback, prepare release build |
| 10+ | Submit for App Store review |

---

*Happy Testing! 🍁📱*

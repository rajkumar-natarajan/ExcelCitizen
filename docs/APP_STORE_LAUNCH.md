# ExcelCitizen - App Store & TestFlight Launch Guide

## 📱 App Information

### Basic Details
| Field | Value |
|-------|-------|
| **App Name** | ExcelCitizen - Citizenship Test |
| **Subtitle** | Canadian Citizenship Test Prep |
| **Bundle ID** | com.curiousdev.excelCitizenFlutter |
| **Primary Language** | English (Canada) |
| **Secondary Language** | French (Canada) |
| **Category** | Education |
| **Secondary Category** | Reference |
| **Content Rating** | 4+ (No objectionable content) |

---

## 📝 App Store Metadata

### App Name (30 characters max)
```
ExcelCitizen - Citizenship Test
```

### Subtitle (30 characters max)
```
Canadian Citizenship Test Prep
```

### Promotional Text (170 characters max)
```
🍁 Prepare for your Canadian Citizenship Test with 180+ bilingual questions, smart learning, and comprehensive study materials based on Discover Canada.
```

### Description (4000 characters max)

```
ExcelCitizen is your comprehensive companion for preparing for the Canadian Citizenship Test. Whether you're a new immigrant pursuing your dream of becoming Canadian or helping a family member prepare, our app provides everything you need to succeed.

🎯 COMPREHENSIVE QUESTION BANK
• 180+ practice questions covering all test topics
• Fully bilingual - English and French translations
• Based on the official Discover Canada study guide
• Detailed explanations for every answer

📚 SIX KEY TOPIC AREAS
• Rights & Responsibilities - Charter of Rights, equality, civic duties
• Canadian History - Confederation, Aboriginal peoples, World Wars
• Government & Democracy - Federal, provincial, and municipal systems
• Geography - Provinces, territories, capitals, and regions
• Canadian Symbols - Flag, anthem, national holidays
• Economy - Trade, industries, natural resources

🧠 SMART LEARNING FEATURES
• Spaced repetition for better retention
• Performance-based question prioritization
• Bookmark important questions for review
• Track your weak areas and improve

📊 MULTIPLE TEST MODES
• Quick Assessment (10 questions, 5 minutes)
• Standard Practice (20 questions, 15 minutes)
• Full Mock Exam (20 questions, 30 minutes)
• Category-specific practice sessions

🏆 GAMIFICATION
• Earn XP and level up as you learn
• Unlock 15+ achievement badges
• Build daily study streaks
• Track your progress over time

📈 DETAILED ANALYTICS
• View your performance by category
• Identify strengths and weaknesses
• Monitor improvement over time
• Best study time recommendations

🌙 USER-FRIENDLY DESIGN
• Clean, Canadian-themed interface
• Dark mode support
• Offline access to all questions
• Works on iPhone and iPad

Start your journey to Canadian citizenship today with ExcelCitizen!

Note: This app is an independent study tool and is not affiliated with Immigration, Refugees and Citizenship Canada (IRCC). Questions are based on publicly available study materials.
```

### Keywords (100 characters max, comma-separated)
```
citizenship,canada,test,exam,study,immigration,citizen,practice,quiz,canadian,civics,history
```

### Support URL
```
https://curiousdev.app/excelcitizen/support
```

### Marketing URL
```
https://curiousdev.app/excelcitizen
```

### Privacy Policy URL (Required)
```
https://curiousdev.app/excelcitizen/privacy
```

---

## 🖼️ Screenshots Required

### iPhone Screenshots (6.7" Display - iPhone 15 Pro Max)
Required: 3-10 screenshots | Recommended: 5-6

| # | Screen | Caption |
|---|--------|---------|
| 1 | Dashboard | "Your citizenship journey starts here 🍁" |
| 2 | Practice Screen | "Choose from 180+ practice questions" |
| 3 | Test Session | "Interactive quizzes in English & French" |
| 4 | Results Screen | "Detailed performance analytics" |
| 5 | Progress Screen | "Track your learning progress" |
| 6 | Achievements | "Earn badges and level up!" |

### Screenshot Specifications
- **6.7" Display**: 1290 x 2796 pixels (iPhone 15 Pro Max, 14 Pro Max)
- **6.5" Display**: 1284 x 2778 pixels (iPhone 14 Plus, 13 Pro Max)
- **5.5" Display**: 1242 x 2208 pixels (iPhone 8 Plus) - Optional
- **iPad Pro 12.9"**: 2048 x 2732 pixels - If supporting iPad

### Screenshot Tips
- Use actual app screenshots with real content
- Add captions/frames using tools like Fastlane Frameit
- Showcase key features prominently
- Use consistent branding colors (red/white Canadian theme)

---

## 🎬 App Preview Video (Optional but Recommended)

### Specifications
- **Duration**: 15-30 seconds
- **Resolution**: Same as screenshots
- **Format**: H.264, .mov or .mp4
- **Audio**: Optional (muted by default)

### Suggested Storyboard
1. **0-5s**: App icon and launch → Dashboard overview
2. **5-12s**: Start a practice test → Answer questions
3. **12-20s**: View results → See explanations
4. **20-25s**: Check achievements → View progress
5. **25-30s**: App name + "Start your citizenship journey today"

---

## 🔒 Privacy & Compliance

### Privacy Policy (Create at your support URL)

```markdown
# ExcelCitizen Privacy Policy

Last Updated: December 2024

## Data Collection
ExcelCitizen collects and stores the following data LOCALLY on your device:
- Test scores and performance statistics
- Bookmarked questions
- Learning progress and streaks
- App preferences (theme, language)

## Data NOT Collected
- Personal identification information
- Location data
- Contact information
- Analytics or tracking data

## Data Storage
All data is stored locally on your device using secure storage mechanisms. No data is transmitted to external servers.

## Third-Party Services
This app does not integrate with any third-party analytics, advertising, or tracking services.

## Children's Privacy
This app is suitable for all ages (4+) and does not collect any personal information from children.

## Contact
For privacy concerns, contact: privacy@curiousdev.app
```

### App Privacy Details (App Store Connect)
| Question | Answer |
|----------|--------|
| Does your app collect data? | Yes |
| Data Types Collected | Usage Data (analytics), Other Data (preferences) |
| Data Linked to User | No |
| Data Used for Tracking | No |
| Data Collected for Third Parties | No |

### Data Types Declaration
- **Usage Data**: Test scores, progress (stored locally, not linked to identity)
- **Other Data**: App preferences (stored locally, not linked to identity)

---

## 📋 App Review Information

### Demo Account
```
Not required - app has no login functionality
```

### Notes for Reviewers
```
ExcelCitizen is an educational app to help users prepare for the Canadian Citizenship Test.

Key Points:
1. No login/account required - all data is stored locally
2. No in-app purchases in initial release
3. All content is based on publicly available Canadian citizenship study materials
4. App works fully offline
5. Bilingual support (English/French) throughout the app

Content Source:
Questions are derived from the public "Discover Canada: The Rights and Responsibilities of Citizenship" guide published by Immigration, Refugees and Citizenship Canada (IRCC).

Testing the App:
- Launch the app and tap any Quick Action tile to start practicing
- Try different test modes from the Practice tab
- Review your progress in the Progress tab
- Check achievements in the Achievements section

Thank you for reviewing our app!
```

### Contact Information
```
First Name: [Your First Name]
Last Name: [Your Last Name]
Phone: [Your Phone Number]
Email: [Your Email]
```

---

## 🚀 TestFlight Setup

### Internal Testing (Up to 100 testers)
1. Go to App Store Connect → Your App → TestFlight
2. Add internal testers (Apple ID email addresses)
3. Build will be automatically available to internal testers

### External Testing (Up to 10,000 testers)
1. Create a new External Testing Group
2. Submit build for Beta App Review
3. Add tester emails or create public link
4. Testers receive invitation to download via TestFlight app

### Beta App Information
```
Beta App Description:
Help us test ExcelCitizen before launch! Practice for the Canadian Citizenship Test with 180+ questions in English and French.

Feedback Email:
beta@curiousdev.app

What to Test:
- Question accuracy and translations
- App stability and performance
- User experience and navigation
- Any bugs or issues
```

### TestFlight Build Notes Template
```
Build [VERSION] - What's New:
• [Feature 1]
• [Feature 2]
• [Bug fixes]

Known Issues:
• [Any known issues]

Please report bugs to: beta@curiousdev.app
```

---

## 📦 Build & Submission Checklist

### Pre-Submission Checklist

#### Code & Build
- [ ] All tests passing (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Release build works (`flutter build ios --release`)
- [ ] App icon set for all sizes
- [ ] Launch screen configured
- [ ] Version number incremented
- [ ] Build number incremented

#### App Store Connect
- [ ] App registered in App Store Connect
- [ ] Bundle ID matches Xcode project
- [ ] App Information filled out
- [ ] Pricing set (Free or Paid)
- [ ] Availability (countries/regions) configured
- [ ] Age rating questionnaire completed
- [ ] App Privacy details completed

#### Assets
- [ ] Screenshots for required device sizes
- [ ] App icon (1024x1024 PNG, no alpha)
- [ ] App preview video (optional)

#### Legal
- [ ] Privacy Policy URL live and accessible
- [ ] Terms of Service (if applicable)
- [ ] Content licensing verified
- [ ] No trademark violations

### Build Commands

```bash
# Clean and prepare
flutter clean
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze

# Build release IPA
flutter build ipa --release

# Or build via Xcode
open ios/Runner.xcworkspace
# Then: Product → Archive
```

### Xcode Archive & Upload

1. **Open Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Generic iOS Device**
   - Product → Destination → Any iOS Device

3. **Archive**
   - Product → Archive
   - Wait for build to complete

4. **Distribute**
   - Window → Organizer
   - Select latest archive
   - Click "Distribute App"
   - Select "App Store Connect"
   - Follow prompts to upload

### Fastlane Alternative (Recommended)

```bash
# Install Fastlane
gem install fastlane

# Initialize in ios folder
cd ios
fastlane init

# Deploy to TestFlight
fastlane beta

# Deploy to App Store
fastlane release
```

---

## 💰 Pricing Strategy

### Initial Launch (Recommended)
| Option | Price | Notes |
|--------|-------|-------|
| **Free** | $0 | Maximize downloads, consider ads/IAP later |
| **Freemium** | $0 + IAP | Free with premium upgrade option |
| **Paid** | $2.99-4.99 | One-time purchase |

### Future Monetization Options
1. **Premium Upgrade** ($4.99)
   - Unlock additional question packs
   - Remove ads (if added)
   - Advanced analytics

2. **Subscription** ($2.99/month or $19.99/year)
   - New questions monthly
   - Priority support
   - Advanced features

---

## 🌍 Localization

### Current Languages
- ✅ English (Canada) - Primary
- ✅ French (Canada) - Fully translated

### App Store Localization
Localize the following for French (Canada):
- App Name: `ExcelCitizen - Test de citoyenneté`
- Subtitle: `Préparation au test canadien`
- Description: [French translation of description]
- Keywords: `citoyenneté,canada,test,examen,étude,immigration,citoyen,pratique,quiz`
- Screenshots: Add French captions

---

## 📊 Post-Launch Monitoring

### Key Metrics to Track
- Download numbers
- Crash reports (Xcode Organizer)
- User ratings and reviews
- Retention rates
- Session duration

### Responding to Reviews
- Reply to all negative reviews professionally
- Thank users for positive reviews
- Use feedback for future updates

### Update Strategy
- Weekly bug fixes if needed
- Monthly feature updates
- Seasonal content updates (around citizenship ceremonies)

---

## 📞 Support Setup

### Support Email
```
support@curiousdev.app
```

### FAQ for Support Page
1. **Is this app official?**
   No, ExcelCitizen is an independent study tool not affiliated with IRCC.

2. **Are the questions accurate?**
   Questions are based on the official Discover Canada guide.

3. **Can I use this offline?**
   Yes, all content is available offline.

4. **Is my progress saved?**
   Yes, all progress is saved locally on your device.

5. **How do I switch languages?**
   Go to Settings and select your preferred language.

---

## 🔨 Build & Deployment Commands

### Quick Build and Upload

```bash
# Navigate to project
cd /Users/rajkumarnatarajan/Documents/raj/excel_citizen_flutter

# Clean and get dependencies
flutter clean && flutter pub get

# Archive the app (uses manual signing with ExcelCitizen AppStore profile)
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

### Signing Configuration

| Setting | Value |
|---------|-------|
| **Team ID** | Y62BAT7CF4 |
| **Bundle ID** | com.curiousdev.excelCitizenFlutter |
| **Distribution Certificate** | Apple Distribution: Rajkumar Natarajan (Y62BAT7CF4) |
| **Provisioning Profile** | ExcelCitizen AppStore |
| **Code Sign Style** | Manual (for Release/Profile configurations) |

### App Icon Requirements
- All icons must have **no alpha channel** (transparency)
- Use ImageMagick to remove alpha: `convert icon.png -background white -alpha remove -alpha off icon.png`

---

## ✅ Final Submission Checklist

- [x] App tested on multiple devices
- [x] App icons have no alpha channel
- [x] Provisioning profile created (ExcelCitizen AppStore)
- [x] ExportOptions.plist configured
- [x] Archive built successfully
- [x] Uploaded to App Store Connect
- [ ] All screenshots uploaded
- [ ] All metadata complete
- [ ] Privacy policy live
- [ ] Support URL live
- [ ] TestFlight testing complete
- [ ] Submit for App Store review

---

## 📅 Build History

| Version | Build | Date | Status |
|---------|-------|------|--------|
| 1.0.0 | 1 | December 24, 2025 | Uploaded to TestFlight |

---

*Good luck with your App Store launch! 🍁🚀*

# ExcelCitizen - Canadian Citizenship Test Preparation

A comprehensive Flutter application designed to help users prepare for the Canadian Citizenship Test through interactive practice sessions, smart learning algorithms, and gamification features.

## 🍁 Features

### Core Functionality
- **Practice Tests**: Multiple test modes including Quick Assessment, Standard Practice, and Full Mock exams
- **Question Bank**: 180+ comprehensive bilingual questions covering all citizenship test categories
- **Smart Learning**: Spaced repetition and performance-based question prioritization
- **Bookmark System**: Save important questions for later review
- **Progress Tracking**: Detailed analytics and performance insights
- **Bilingual Support**: Full English and French translations for all questions and explanations

### Question Bank (180+ Questions)
| Category | Questions | Topics Covered |
|----------|-----------|----------------|
| 🏛️ **Rights & Responsibilities** | 28 | Charter of Rights, Equality, Citizenship Rights, Civic Duties |
| 📜 **History** | 34 | Confederation, Aboriginal Peoples, Exploration, World Wars, Modern Canada |
| ⚖️ **Government** | 32 | Federal/Provincial/Municipal Government, Elections, Monarchy, Justice System |
| 🗺️ **Geography** | 30 | Provincial Capitals, Provinces & Territories, Regions, Natural Resources |
| 🍁 **Symbols** | 28 | National Symbols, Anthem, Canadian Holidays, Flags |
| 💼 **Economy** | 28 | Trade, Natural Resources, Industries, Agriculture, Banking |

### Test Modes
| Mode | Questions | Time | Purpose |
|------|-----------|------|---------|
| Quick Assessment | 10 | 5 min | Daily practice |
| Standard Practice | 20 | 15 min | Regular study |
| Full Mock | 20 | 30 min | Exam simulation |

### Gamification
- **XP System**: Earn experience points for completing tests
- **Level Progression**: Unlock new levels as you improve
- **Achievements**: 15+ badges to unlock
- **Daily Streaks**: Build consistency with streak tracking
- **Leaderboard**: Compare progress with other learners

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── controllers/
│   ├── gamification_controller.dart    # XP, levels, achievements
│   ├── settings_controller.dart        # App preferences
│   └── smart_learning_controller.dart  # Spaced repetition & analytics
├── data/
│   └── question_data_manager.dart      # Question loading & filtering
├── models/
│   └── question.dart                   # Question, TestConfiguration, UserAnswer
├── screens/
│   ├── achievements_screen.dart        # Achievement badges display
│   ├── dashboard_screen.dart           # Main menu
│   ├── practice_screen.dart            # Test configuration
│   ├── progress_screen.dart            # Analytics & statistics
│   ├── results_screen.dart             # Test results summary
│   ├── review_screen.dart              # Answer review
│   ├── settings_screen.dart            # App settings
│   ├── study_guide_screen.dart         # Learning materials
│   └── test_session_screen.dart        # Active test interface
└── widgets/
    └── canadian_theme.dart             # Canada-themed UI styling
```

## 🏗️ Architecture

### Models

#### Question
```dart
class Question {
  final String id;
  final String question;
  final String questionFr;      // French translation
  final List<String> options;
  final List<String> optionsFr;
  final int correctAnswer;
  final String explanation;
  final String explanationFr;
  final QuestionType type;
  final Difficulty difficulty;
  final List<String>? tags;
}
```

#### Enums
- **QuestionType**: `rightsResponsibilities`, `history`, `government`, `geography`, `symbols`, `economy`
- **Difficulty**: `easy`, `medium`, `hard`
- **Language**: `english`, `french`
- **TestMode**: `quickAssessment`, `standardPractice`, `fullMock`

### Controllers

#### SmartLearningController
Manages intelligent learning features:
- Bookmark management with persistence
- Performance statistics tracking
- Time analytics (best/worst performance hours)
- Spaced repetition scheduling
- Test session history

#### GamificationController
Handles engagement features:
- XP calculation and awarding
- Level progression (1-50+)
- Achievement unlocking
- Daily streak management
- Statistics tracking

#### SettingsController
Manages user preferences:
- Theme mode (light/dark)
- Language selection (EN/FR)
- Difficulty preferences
- Notification settings

### Data Layer

#### QuestionDataManager
Responsible for:
- Loading questions from JSON assets
- Filtering by category, difficulty, language
- Generating test configurations
- Shuffling and randomizing questions

## 🧪 Testing

The project includes comprehensive test coverage with 112+ tests.

### Test Structure
```
test/
├── widget_test.dart                        # Basic widget tests
├── controllers/
│   ├── gamification_controller_test.dart   # XP, levels, achievements
│   ├── settings_controller_test.dart       # Settings functionality
│   └── smart_learning_controller_test.dart # Learning algorithms
├── data/
│   └── question_data_manager_test.dart     # Data loading & filtering
├── integration/
│   └── workflow_test.dart                  # End-to-end workflows
└── models/
    └── question_test.dart                  # Model validation
```

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/question_test.dart

# Run with verbose output
flutter test --reporter expanded
```

### Test Categories

| Category | Tests | Coverage |
|----------|-------|----------|
| Question Model | 40+ | Enums, constructors, JSON, validation |
| SmartLearningController | 15+ | Bookmarks, stats, history |
| GamificationController | 20+ | XP, levels, streaks, achievements |
| SettingsController | 10+ | Theme, language, difficulty |
| QuestionDataManager | 15+ | Loading, filtering, configs |
| Integration | 10+ | Complete workflows |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- iOS Simulator / Android Emulator (for mobile)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/excel_citizen_flutter.git
cd excel_citizen_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Run on default device
flutter run

# Run on specific platform
flutter run -d chrome      # Web
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
flutter run -d macos       # macOS Desktop
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# macOS
flutter build macos --release
```

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | ✅ Supported |
| macOS | ✅ Supported |
| Windows | ✅ Supported |
| Linux | ✅ Supported |

## � Bilingual Support (English/French)

The app is fully bilingual, reflecting Canada's official languages:

### Language Features
- **UI Translation**: All screens, buttons, and labels support English and French
- **Question Content**: Questions, options, and explanations available in both languages
- **Study Guide**: Complete study materials in both languages
- **Real-time Switching**: Change language instantly in Settings

### Screens with French Support
- ✅ Dashboard (Home)
- ✅ Practice Configuration
- ✅ Test Session
- ✅ Results & Review
- ✅ Study Guide
- ✅ Settings

### How to Switch Language
1. Go to **Settings** (gear icon in navigation)
2. Tap on **Language**
3. Select **English (🇬🇧)** or **Français (🇫🇷)**
4. The entire app updates immediately

## 📚 Study Guide Content

The Study Guide covers all topics from the official "Discover Canada" guide:

### Rights & Responsibilities
- Fundamental rights under the Charter
- Citizen responsibilities and duties
- Voting rights and obligations

### Canadian History
- Aboriginal Peoples (First Nations, Inuit, Métis)
- Confederation (1867)
- World Wars and Canada's contributions
- Key historical figures

### Government
- Constitutional Monarchy structure
- Three levels of government (Federal, Provincial, Municipal)
- Electoral process and voting
- Parliament (Senate and House of Commons)

### Geography
- 10 Provinces and 3 Territories
- Five main regions of Canada
- Capital cities
- Natural features and resources

### Symbols & Economy
- National symbols (Flag, Anthem, Beaver, Maple Leaf)
- Major industries
- Trading partners
- Economic organizations (G7, G20, USMCA)

### Test-Taking Tips
- Time management strategies
- Passing score requirements (75%)
- Study recommendations

## �🎨 Theming

The app features a Canadian-themed design with:
- Primary color: Canadian Red (#FF0000)
- Accent elements inspired by the Canadian flag
- Maple leaf iconography
- Bilingual support (English/French)

### Theme Modes
- **Light Mode**: Clean, bright interface
- **Dark Mode**: Eye-friendly dark theme
- **System**: Follows device preferences

## 📊 Analytics & Progress

### Performance Stats
- Accuracy percentage by category
- Average response time
- Questions answered per session
- Daily/weekly/monthly trends

### Time Analytics
- Best performing hours
- Optimal study time recommendations
- Session duration tracking

## 🔧 Configuration

### Test Configuration
```dart
TestConfiguration(
  mode: TestMode.standardPractice,
  categories: [QuestionType.history, QuestionType.government],
  difficulty: Difficulty.medium,
  language: Language.english,
  questionCount: 20,
  timeLimitMinutes: 15,
)
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -m 'Add new feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Submit a pull request

### Code Style
- Follow Dart style guidelines
- Run `flutter analyze` before committing
- Ensure all tests pass with `flutter test`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Canadian Government for citizenship test guidelines
- Flutter team for the amazing framework
- All contributors and testers

---

**Good luck with your Canadian Citizenship Test! 🍁🇨🇦**

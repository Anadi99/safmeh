# SafMeh 🌸 — Your Personal Safety Companion

> *"Even when no one is physically there, someone still cares about your safety."*

SafMeh is a calm, emotionally supportive personal safety app built with Flutter. Unlike traditional safety apps that feel alarming and stressful, SafMeh focuses on **quiet protection, emotional reassurance, and instant safety support** — all wrapped in a soft white-and-pink interface that never makes you anxious.

---

## ✨ Features

### 🚶 Safe Walk Mode
Start a protected journey with one tap. SafMeh silently monitors your route in the background — tracking your location every 10 seconds, detecting unusual stops, route deviations, and falls. If something seems wrong, it gently asks *"Are you okay?"* and automatically triggers emergency mode if you don't respond within 15 seconds.

### 🆘 Silent SOS System
Get help without attracting attention. Trigger an emergency alert using:
- **Power button** pressed 3× within 2 seconds
- **Shake** the phone for 2 seconds
- **Volume pattern** up-up-down within 3 seconds
- **Voice keyword** activation

Once triggered, SafMeh silently shares your live location, starts recording audio evidence, and notifies your trusted contacts — all without any visible alerts or sounds.

### 🎭 Pretend Mode
Disguise SafMeh as a normal app. Choose from:
- **Calculator** — enter your PIN with the number buttons
- **Notes** — type your PIN as text
- **Journal** — write your PIN as a diary entry
- **Music Player** — use the skip button pattern

The real Safety Dashboard is hidden behind your secret PIN.

### 📞 Fake Call Escape System
Trigger a realistic fake incoming call to exit uncomfortable situations. Customize the caller name, photo, ringtone, and pre-recorded voice clip. Schedule calls in advance or trigger instantly.

### 💕 Comfort Corner
Personal notes, motivational quotes, and comforting reminders. SafMeh shows a warm message when you arrive safely — *"Glad you reached safely 🌸"* — because emotional safety matters too.

### 🗺️ Temporary Route Sharing
Share your live journey with trusted contacts including ETA, movement status, and battery percentage. The session automatically expires when you arrive or when the timer ends — no permanent tracking.

### 👥 Trusted Circle
A private safety circle of family and close friends. Only they receive SOS alerts, location access, and emergency recordings.

---

## 📱 Screenshots

> *Coming soon — custom doodle icons and animations in progress*

---

## 🏗️ Architecture

SafMeh is built with a clean, scalable architecture:

```
lib/
├── cubits/          # BLoC/Cubit state management (9 feature cubits)
├── models/          # Data models with toJson/fromJson
├── screens/         # UI screens (auth, dashboard, all features)
├── services/        # Business logic services (location, SOS, audio, etc.)
├── theme/           # White & pink design system (SafMehTheme)
└── widgets/         # Reusable widgets (GlassCard, SoftButton, SosOverlay)
```

**State Management:** BLoC/Cubit pattern  
**Repository Pattern:** All services use abstract interfaces — swap mock → real Firebase by replacing one class  
**Background Services:** `flutter_background_service` for Android foreground service  
**Platform Channels:** Native Android `EventChannel` for power/volume button interception

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3.x (Dart) |
| State Management | flutter_bloc / Cubit |
| Backend (ready) | Firebase (Auth, Firestore, Realtime DB, Storage, FCM) |
| Maps | Google Maps API |
| SMS Alerts | Twilio API (via Cloud Functions) |
| Encryption | AES-256-CBC (encrypt package) |
| Secure Storage | flutter_secure_storage |
| Sensors | sensors_plus, geolocator |
| Audio | record package |
| Font | Nunito (Google Fonts) |

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x (`flutter --version`)
- Android Studio or VS Code
- Android device or emulator (API 21+)

### Installation

```bash
# Clone the repository
git clone https://github.com/Anadi99/safmeh.git
cd safmeh

# Install dependencies
flutter pub get

# Run the app (mock mode — no Firebase needed)
flutter run
```

The app runs fully in **mock mode** out of the box. All features work with simulated data — no Firebase configuration required to explore the UI and logic.

### Running Tests

```bash
flutter test
```

177 tests, 0 failures.

---

## 🔥 Firebase Setup (Production)

To wire real Firebase services:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an Android app with package name `com.safmeh.safmeh`
3. Download `google-services.json` → place in `android/app/`
4. Enable **Authentication** (Email/Password + Biometric)
5. Enable **Firestore Database** and deploy the security rules from `lib/services/firestore_security_rules.dart`
6. Enable **Firebase Storage** for audio evidence
7. Enable **Cloud Messaging** for push notifications
8. Replace each `Mock*Repository` class with a real Firebase implementation

---

## 🔐 Security

- All local user data encrypted with `flutter_secure_storage` (AES-256 on Android, Keychain on iOS)
- Audio evidence encrypted with AES-256-CBC before upload
- Firestore security rules enforce owner-only access — no user can read another user's data
- Generic error messages on auth failures (no email enumeration)
- Biometric authentication support (fingerprint / face recognition)

---

## 📁 Project Structure

```
safmeh/
├── android/                    # Android platform code
│   └── app/src/main/
│       ├── AndroidManifest.xml # Permissions + background service
│       └── kotlin/.../
│           └── MainActivity.kt # Hardware button EventChannel
├── ios/                        # iOS platform code
├── lib/
│   ├── cubits/
│   │   ├── auth/               # Login, register, biometric
│   │   ├── battery/            # Battery monitoring + thresholds
│   │   ├── comfort/            # Notes + comfort messages
│   │   ├── fake_call/          # Fake call scheduling
│   │   ├── pretend_mode/       # Decoy UI + PIN validation
│   │   ├── route_share/        # Live route sharing
│   │   ├── safe_walk/          # Journey tracking + check-in
│   │   ├── sos/                # Silent SOS lifecycle
│   │   └── trusted_circle/     # Contact management
│   ├── models/                 # 11 data models
│   ├── screens/
│   │   ├── auth/               # Login + Register
│   │   ├── comfort/            # Comfort Corner
│   │   ├── dashboard/          # Safety Dashboard (main hub)
│   │   ├── fake_call/          # Fake Call screen
│   │   ├── pretend_mode/       # 4 decoy UIs
│   │   ├── route_share/        # Route Share panel
│   │   ├── safe_walk/          # Safe Walk sheet + Check-in prompt
│   │   └── trusted_circle/     # Trusted Circle management
│   ├── services/
│   │   ├── background_sensor_processor.dart
│   │   ├── battery_coordinator.dart
│   │   ├── encryption_service.dart
│   │   ├── fall_detector.dart
│   │   ├── hardware_button_channel.dart
│   │   ├── safe_walk_coordinator.dart
│   │   ├── sos_coordinator.dart
│   │   └── ... (20+ service files)
│   ├── theme/
│   │   └── safmeh_theme.dart   # White & pink design system
│   └── widgets/
│       ├── check_in_prompt.dart
│       ├── glass_card.dart
│       ├── soft_button.dart
│       └── sos_overlay.dart
└── test/                       # 177 unit tests
```

---

## 🎨 Design System

SafMeh uses a warm white-and-pink palette designed to feel safe, not alarming:

| Token | Color | Use |
|---|---|---|
| `blushPink` | `#FFB6C8` | Primary / buttons |
| `deepPink` | `#FF6B9D` | Accent / active states |
| `palePink` | `#FFE4EE` | Card backgrounds |
| `softWhite` | `#FFF8FA` | App background |
| `dustyRose` | `#FFCDD8` | Borders / dividers |
| `safeGreen` | `#A8E6CF` | Safe / confirmed states |
| `emergencyRose` | `#FF8FAB` | Emergency (soft, not alarming) |

Typography: **Nunito** — rounded, friendly, warm.

---

## 🗺️ Roadmap

- [ ] Wire real Firebase (Auth, Firestore, Storage, FCM)
- [ ] Custom doodle icons and Lottie animations
- [ ] Real GPS via `geolocator`
- [ ] Real accelerometer via `sensors_plus`
- [ ] Real audio recording via `record` package
- [ ] Twilio SMS Cloud Function deployment
- [ ] AI distress detection (voice stress analysis)
- [ ] Smartwatch integration (heart rate, fall detection)
- [ ] App Store / Play Store release

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 💌 About

SafMeh was built with care for anyone who has ever felt unsafe walking alone, traveling at night, or being in an uncomfortable situation. The app quietly says:

> *"I care about your safety, even when I'm not there."*

---

<p align="center">Made with 🌸 and Flutter</p>

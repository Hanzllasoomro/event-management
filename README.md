# Event Planner Application

A comprehensive event management application built with Flutter that helps users organize events, manage guests, track tasks, and monitor budgets. This app provides an all-in-one solution for event planning and coordination.

## 🚀 Features

- 📱 **Event Management** - Create and manage multiple event types (Wedding, Birthday, Engagement, Graduation Party, Farewell)
- 📸 **Image Upload** - Upload custom images for your events using the built-in image picker
- 👥 **Guest Management** - Track and manage guest lists with confirmation status
- ✅ **Task Management** - Organize to-do lists for each event with completion tracking
- 💰 **Budget Tracking** - Monitor expenses and manage budgets for each event
- 🔐 **Firebase Authentication** - Secure login and signup with Firebase
- 🎨 **Material Design** - Beautiful and intuitive user interface
- 🌐 **Multi-Platform** - Supports Android, iOS, Web, and Desktop

## 📋 Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter SDK** (3.0.0 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (compatible with Flutter)
- **Firebase Account** - Setup required for authentication and database
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** - For cloning and version control

## Setup Instructions

1. **Clone this repository**
   ```bash
   git clone https://github.com/Hanzllasoomro/event-management.git
   cd event-management
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   The app uses Firebase for authentication and data storage. The `firebase_options.dart` file is already configured with a Firebase project.
   
   If you need to set up your own Firebase project:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Run `flutterfire configure` in the project root

4. **Firebase Configuration** (Optional)

   If you want to use your own Firebase project:
   ```bash
   flutterfire configure
   ```
   
   The splash screen animation (`Animation.json`) is optional and can be added to `assets/images/` if needed.

## Running the Application

### For Android
```bash
flutter run
```

### For iOS (macOS only)
```bash
flutter run
```

### For Web
```bash
flutter run -d chrome
```

### For Windows Desktop
```bash
flutter run -d windows
```

## Project Structure

```
lib/
├── main.dart              # Entry point
├── SplashScreen.dart      # Splash screen with animation
├── login.dart            # Login screen
├── signup.dart           # Sign up screen
├── Dashboard.dart         # Main dashboard with events
├── DetailScreen.dart     # Event detail screen
├── guestlist.dart        # Guest management
├── Task.dart             # Task management
├── Bugdet.dart           # Budget management
├── auth_service.dart     # Firebase authentication service
└── firebase_options.dart # Firebase configuration
```

## Building the App

### Android APK
```bash
flutter build apk
```

### Android App Bundle
```bash
flutter build appbundle
```

### iOS (requires macOS)
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

### Windows
```bash
flutter build windows
```

## 📦 Dependencies

- `firebase_core` - Firebase initialization and configuration
- `firebase_auth` - User authentication and security
- `cloud_firestore` - Real-time database for events, guests, and tasks
- `lottie` - Beautiful animations for splash screen
- `file_picker` - Image upload functionality
- `flutter` - Flutter SDK

## 🛠 Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: Flutter StatefulWidget
- **UI**: Material Design 3

## 📱 Screenshots

_Coming soon - Add screenshots of your app here_

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Hanzllasoomro/event-management/issues).

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**HANZLLA SOOMRO**

- GitHub: [@Hanzllasoomro](https://github.com/Hanzllasoomro)
- Repository: [event-management](https://github.com/Hanzllasoomro/event-management)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - Google's UI toolkit
- [Firebase](https://firebase.google.com/) - Backend services
- [LottieFiles](https://lottiefiles.com/) - Animations

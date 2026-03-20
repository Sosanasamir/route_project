# 🎬 MovieApp | Route Graduation Project

A premium, high-performance mobile application built with **Flutter** and **Firebase**, designed to provide users with a seamless movie discovery and management experience. This project demonstrates advanced state management, cloud synchronization, and clean architecture principles.

---

## 🚀 Key Features

* **User Authentication**: Secure Login, Sign Up, and Password Reset powered by **Firebase Auth**.
* **Profile Management**: Customizable user profiles with avatar selection and real-time data updates.
* **Global Watchlist**: Cloud-synced movie bookmarking using **Firestore** with **Optimistic UI** for zero-latency feedback.
* **Movie Discovery**: Detailed movie information including cast, summaries, ratings, and similar movie suggestions via **YTS API**.
* **Multi-Language Support**: Full Internationalization (i18n) supporting **English** and **Arabic** via `easy_localization`.
* **Modern UI/UX**: Dark-themed, minimalist design featuring glass-morphism, hero animations, and custom theme data.

---

## 🛠 Tech Stack & Architecture

This project follows **Clean Architecture** patterns to ensure scalability and maintainability.

* **Framework**: [Flutter](https://flutter.dev)
* **State Management**: [Flutter BLoC / Cubit](https://pub.dev/packages/flutter_bloc) (Global & Local providers)
* **Backend**: [Firebase](https://firebase.google.com) (Authentication & Firestore)
* **Networking**: [Dio](https://pub.dev/packages/dio) & [HttpOverrides](https://api.flutter.dev/flutter/dart-io/HttpOverrides-class.html) for API communication
* **Local Storage**: `shared_preferences` for theme and locale settings.
* **Localization**: `easy_localization`

### Folder Structure
```text
lib/
├── core/                           # App-wide configurations
│   ├── theme/                      # AppTheme, Colors, Typography
│   ├── network/                    # Dio/Http clients, API Endpoints
│   ├── utils/                      # Constants, Validators, Formatters
│   └── widgets/                    # Shared UI (Loading, Custom Buttons)
│
├── features/                       # Independent modules
│   ├── auth/                       # Authentication Feature
│   │   ├── data/                   # AuthRepository, AuthModels
│   │   ├── logic/                  # AuthCubit, AuthStates
│   │   └── ui/                     # Login, Register, ForgetPassword
│   │
│   ├── movies/                     # Movie Discovery Feature
│   │   ├── data/                   # MovieModel, MovieRepository
│   │   ├── logic/                  # MovieCubit, MovieDetailCubit, SearchCubit
│   │   └── ui/                     # HomeScreen, MovieDetails, Splash
│   │       └── widgets/            # MovieCard, CategoryList, HeroSection
│   │
│   └── profile/                    # User Profile & Watchlist
│       ├── data/                   # ProfileRepository, WatchlistRepository
│       ├── logic/                  # ProfileCubit, WatchlistCubit
│       └── ui/                     # ProfileTab, UpdateProfileScreen
│           └── widgets/            # AvatarPicker, StatItem, EmptyState
│
├── generated/                      # Auto-generated (Localization/Assets)
├── firebase_options.dart           # Firebase configuration
└── main.dart                       # Entry point & Global Bloc Providers
```

---

## 📖 Technical Highlights  

### ⚡ Optimistic UI Updates
The **Watchlist** logic doesn't wait for a Firebase response to update the UI. The state is emitted immediately, providing a "snappy" feel, while the network request runs in the background.

### 🌐 Global State Synchronization
By utilizing a **MultiBlocProvider** in `main.dart`, the `WatchlistCubit` is accessible across the entire app. Bookmarking a movie in the `DetailsScreen` updates the `ProfileTab` grid in real-time without requiring a page refresh or app restart.

### 🔒 Secure Cloud Persistence
Migrated from local SQLite to **Firebase Firestore** to ensure user data persists across devices, linked uniquely to the user's `UID`.

---

## 📥 Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Sosanasamir/route_project.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Firebase Setup:**
    * Create a project on the [Firebase Console](https://console.firebase.google.com/).
    * Run `flutterfire configure` to generate `firebase_options.dart`.
4.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 👨‍💻 Developed By
**[Sosana Samir and Marvi Gamil]**
*Software Development Intern | Managment Information System (MIS)*

---

### Key Features:
 

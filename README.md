<img width="99" height="101" alt="Logo" src="https://github.com/user-attachments/assets/89744021-efba-4cfc-bd96-e828fd5e80e9" />

# Flutly Store

![Tests](https://github.com/GabrielPeresBernes/flutly-store/actions/workflows/tests.yml/badge.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue)


Flutly is a **demo e-commerce mobile application** built with Flutter to showcase clean architecture, feature-based organization, and production-ready patterns.

> ⚠️ This app is for **demonstration purposes only**.  
> No real payments, orders, or transactions are processed.

<!-- TODO: Add demo media -->
<!-- 
[PLACEHOLDER]
- Add 1 short GIF showing the happy path (browse → add to cart → checkout)
- Add 3–6 screenshots (Home, Product Details, Cart, Checkout, Profile)
-->

## ✨ Overview

Flutly simulates a complete shopping experience, including authentication, product browsing, cart management, and checkout.

The project is structured to reflect real-world mobile applications, prioritizing:

- Feature-based organization
- Clear separation of concerns
- Scalable navigation and state management
- Maintainable and testable architecture

## 📱 Key Features

- Authentication (email/password and social sign-in)
- Tab-based main navigation
- Home integrated with Sanity (content)
- Product catalog and search
- Product details
- Shopping cart
- Checkout flow (mocked)
- User profile
- Bug report flow

## 🧪 Try the App (Closed Test)

You can install the Flutly app directly on your device via the closed test builds.

👉 [Flutly – Closed Test Page](https://slow-bath-005.notion.site/Flutly-Store-Closed-Test-2e762a6865a680a79b23d1d05e153c4d?pvs=74)

## 🧱 Tech Stack

- **Flutter & Dart**
- **State management:** `flutter_bloc`
- **Navigation:** `go_router`
- **Dependency injection:** `get_it`
- **Networking:** `dio`
- **Local storage:** `shared_preferences`, `flutter_secure_storage`
- **Forms:** `reactive_forms`
- **Localization:** `easy_localization`

### Firebase

- Authentication
- Firestore
- Analytics
- Crashlytics

### Sanity

- Sanity CMS used as a content source for the Home experience

## 🏗 Architecture

Flutly follows a **feature-first Clean Architecture** approach.

Each feature (e.g. `auth`, `catalog`, `checkout`) is divided into:

- **presentation**  
  UI, pages, widgets, BLoC/Cubit
- **domain**  
  Entities, use cases, repository contracts
- **data**  
  Data sources and repository implementations

### Shared infrastructure

- `lib/app/core`  
  Routing, dependency injection, HTTP client, storage
- `lib/app/shared`  
  Theme, shared widgets, utilities

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (`sdk: ^3.9.2`)
- Android Studio or Xcode
- CocoaPods (for iOS)

### Configuration

#### Environment variables

Environment values are provided via `--dart-define`.

Example using a JSON file:

```bash
flutter run --dart-define-from-file=env.prod.json
```

Or manually:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://dummyjson.com/products \
  --dart-define=CRM_BASE_URL=https://veushuon.api.sanity.io/v2025-12-27/data/query/production
```

#### Firebase

Firebase configuration is defined in `lib/firebase_options.dart`.

To regenerate:

```bash
flutterfire configure
```

### Running the App

Install dependencies:

```bash
flutter pub get
```

For iOS:

```bash
cd ios && pod install
```

Run on device or emulator:

```bash
flutter run --dart-define-from-file=env.prod.json
```

## 🧪 Running the Tests

### Unit and Widget Tests

```bash
flutter test
```

### Test Coverage

To generate coverage data:

```bash
flutter test --coverage
```

Generate an HTML report:

```bash
genhtml coverage/lcov.info -o coverage/html
```

> Note: `genhtml` is part of `lcov`.
> - macOS: `brew install lcov`
> - Ubuntu/Debian: `sudo apt-get install lcov`

Open `index.html` inside the `coverage/html` directory to view the report.

<img width="1640" height="300" alt="image" src="https://github.com/user-attachments/assets/5a6c03d7-d5db-4141-94b2-744ad534dde5" />

The project prioritizes test coverage for:

- Domain logic and use cases
- State management (BLoC/Cubit)
- Repositories and data sources
- Critical UI states and flows

This approach provides strong confidence in business behavior while avoiding brittle tests in areas such as routing and dependency wiring, which are exercised indirectly.

## 🎨 Assets & Localization

- Assets: `assets/icons`, `assets/images`, `assets/splash`
- Fonts: DM Sans, Montserrat
- Localization via `easy_localization`
- Current locale: English (`assets/translations/en`)

## 👨‍💻 Author

Gabriel Peres Bernes
Mobile Software Engineer — Flutter Specialist

LinkedIn: [https://www.linkedin.com/in/gabriel-peres-bernes/](https://www.linkedin.com/in/gabriel-peres-bernes/)

Email: bernes.dev@gmail.com

## 📄 License & Disclaimer

This project is intended for educational and demonstration purposes only
and does not represent a real commercial product.

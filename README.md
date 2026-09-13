<p align="center">
  <img src="assets/travel.png" alt="Flutter Travel App Preview" width="100%" style="border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);" />
</p>

<h1 align="center">✈️ Wanderlust — Luxury Travel & Experience Booking App</h1>

<p align="center">
  <strong>A production-ready, enterprise-grade Flutter mobile application built with Clean Architecture, BLoC/Cubit state management, custom 60fps shimmer animations, and tactile haptic feedback.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20%2B%20Cubit-blueviolet?style=for-the-badge" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/Tests-42%20Passed-success?style=for-the-badge" alt="Tests" />
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-4CAF50?style=for-the-badge" alt="Platform" />
</p>

---

## 📖 Overview

**Wanderlust** is a modern, high-performance travel discovery and booking mobile application designed to provide travelers with an immersive, fluid, and visually stunning booking journey.

Built from the ground up adhering to **Clean Architecture** and strict separation of concerns, the application combines smooth micro-interactions, dark/light themes, offline persistence, and tactile sensory feedback to match the polish of top-tier consumer apps like Airbnb, Hopper, and Booking.com.

---

## ✨ Core Features & Highlights

### 1. 🔍 Interactive Multi-Criteria Filter Bottom Sheet
- **Dynamic Dual-Thumb Price Slider**: Filter stays by price per night ($40 to $1,000) with real-time range indicators.
- **Rating Threshold Selector**: Filter by minimum guest ratings (`Any`, `4.0+ ⭐`, `4.5+ ⭐`, `4.8+ ⭐`).
- **Multi-Select Amenity Tags**: Select amenities including *Free WiFi, Swimming Pool, Ocean View, Luxury Spa, Breakfast, Gym, and Fine Dining*.
- **Multi-Option Sorting**: Sort instantly by *Recommended, Price: Low to High, Price: High to Low, or Highest Rated*.
- **Reactive Match Counter**: Floating sticky button dynamically computes matching destinations (e.g. *"Show 8 Destinations"*).

### 2. 🎫 Digital Boarding Pass & Scannable QR Code
- **Custom `TicketClipper`**: Mathematical path clipper cutting out authentic side notches and rounded outer corners.
- **`DashedLinePainter`**: Custom perforated tear line with ticket separation acoustics.
- **Dynamic 2D QR Code**: High-resolution scannable QR code powered by `qr_flutter` carrying signed reservation verification data.
- **Boarding Pass Metadata**: Displays flight/stay PNR code, origin/destination IATA codes (e.g., `JFK` $\to$ `JTR`), room/suite assignments, and boarding time.
- **Wallet & Share Integration**: Simulated "Add to Apple / Google Wallet" and one-tap share/export sheet.

### 3. ⚡ 60fps Skeleton Shimmer Loading Engine
- **Zero External Dependencies**: Custom sliding gradient engine built using `AnimationController`, `ShaderMask`, and `_SlidingGradientTransform`.
- **Adaptive Theming**: Automatically adjusts shimmer frequency and palette for **Light Theme** (`#E2E8F0` $\to$ `#F8FAFC`) and **Dark Theme** (`#1E293B` $\to$ `#334155`).
- **Tailored Skeleton Layouts**: Custom skeletons mirroring the exact dimensions of home carousels, vertical place cards, saved bookmarks, and community reviews.
- **Pull-To-Refresh**: Integrated native `RefreshIndicator` on Home, Bookmarks, and Reviews.

### 4. 📳 Multi-Tier Tactile Haptic Feedback
- **`Haptics.light()`**: Subtle feedback on tab switching, bookmarking, swipe-to-dismiss, and undo actions.
- **`Haptics.selection()`**: Tactile notch feedback when dragging price sliders, category chips, and amenity filters.
- **`Haptics.medium()`**: Firm confirmation when opening filter modals, booking stays, or submitting reviews.
- **`Haptics.success()`**: Satisfying vibration upon saving tickets to the digital wallet.
- **`Haptics.warning()`**: Distinct warning feedback on clearing or resetting filters.
- *Gracefully no-ops on Web/Desktop to ensure zero platform crashes.*

### 5. 💾 Offline Persistence & Bookmark Engine
- **`SharedPreferences`** backing for instantaneous bookmark saving and retrieval across cold app restarts.
- **Swipe-to-Dismiss**: Remove saved destinations with red slide-to-delete gesture and an interactive "UNDO" action snackbar.

---

## 🏗️ Architecture & Engineering Design

The project strictly follows **Clean Architecture** divided into three distinct layers:

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                     │
│  - Cubits: FavoritesCubit, PlacesCubit                      │
│  - States: FavoritesLoaded, PlacesLoaded (Equatable)       │
│  - UI: Widgets, Screens, Custom Painters & Clippers         │
└──────────────────────────────┬──────────────────────────────┘
                               │ invokes
┌──────────────────────────────▼──────────────────────────────┐
│                         DOMAIN LAYER                        │
│  - Use Cases & Repositories: FavoritesRepository, PlacesRepo│
│  - Entities & Models: Place, Booking, Review, FilterCriteria│
│  - Pure Dart (Zero framework or UI dependencies)            │
└──────────────────────────────▲──────────────────────────────┘
                               │ implements
┌──────────────────────────────┴──────────────────────────────┐
│                          DATA LAYER                         │
│  - Implementations: FavoritesRepositoryImpl, PlacesRepoImpl │
│  - Data Sources: FavoritesLocalDataSource (SharedPreferences│
└─────────────────────────────────────────────────────────────┘
```

### Why Cubit / BLoC?
- **Predictable State Flow**: Single source of truth for bookmarks and search/filter states.
- **Performance**: High-granularity widget rebuilding via `BlocBuilder` without unnecessary full-tree re-renders.
- **Testability**: Pure business logic easily validated with standard unit tests.

---

## 📂 Project Structure

```
lib/
├── main.dart                      # Bootstrap & dependency injection (MultiBlocProvider)
├── domain/                        # Pure business logic interfaces
│   └── repositories/             # Abstract repository contracts
├── data/                          # Concrete data implementations
│   ├── datasources/              # Local storage data source (SharedPreferences)
│   └── repositories/             # Repository implementations with filtering pipelines
├── presentation/                  # State management
│   └── cubits/                   # PlacesCubit, FavoritesCubit & state definitions
├── models/                        # Core data models (Place, Booking, Review, FilterCriteria)
├── screens/                       # Top-level screen views
│   ├── home.dart                 # Main discovery feed with categories & carousel
│   ├── details.dart              # Immersive destination details with hero animation
│   ├── favorites_screen.dart     # Dismissible saved bookmarks list
│   ├── boarding_pass_screen.dart # Luxury digital boarding pass & QR code
│   ├── reviews_screen.dart       # Community tips & travel reviews
│   ├── profile_screen.dart       # User profile with active reservations
│   └── main_screen.dart          # Floating pill bottom navigation shell
├── widgets/                       # Reusable UI components
│   ├── filter_bottom_sheet.dart  # Multi-criteria filter modal
│   ├── boarding_pass_card.dart   # Notched ticket widget with QR code
│   ├── ticket_clipper.dart       # Custom clipper & dashed line painter
│   ├── shimmer_loading.dart      # 60fps sliding gradient shader engine
│   ├── place_skeleton.dart       # Skeleton layouts for places & home feed
│   ├── favorites_skeleton.dart   # Skeleton layout for saved bookmarks
│   └── reviews_skeleton.dart     # Skeleton layout for reviews feed
├── services/                      # In-memory reactive services (Booking, Reviews)
└── util/                          # Global constants, colors, dummy dataset & haptics
```

---

## 🧪 Automated Testing & Code Quality

The application is thoroughly verified with an automated test suite containing **42 passing tests**:

```bash
# Run the complete test suite
flutter test

# Run static code analysis (0 warnings, 0 errors)
flutter analyze
```

### Test Coverage Highlights:
- **`test/filter_test.dart`**: Multi-criteria filter algorithms, amenity subset matching, and sort comparators.
- **`test/boarding_pass_test.dart`**: Ticket PNR extraction, IATA code mappings, QR code generation, and wallet actions.
- **`test/shimmer_test.dart`**: 60fps shimmer shader rendering across Light and Dark themes, skeleton widgets, and haptic safety.
- **`test/favorites_cubit_test.dart` & `test/places_cubit_test.dart`**: State emission pipelines and persistence.
- **`test/widget_test.dart`**: Full-app smoke and navigation tests.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.19.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (v3.3.0 or higher)
- Android Studio / Xcode / VS Code with Flutter extension

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Noufel-sf/Flutter_Travel_app.git
   cd Flutter_Travel_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on your device or simulator**:
   ```bash
   # Run on Chrome (Web)
   flutter run -d chrome

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android
   ```

---

## 🎨 Theme Support

The application features built-in **Adaptive Theme Support**:
- **Light Theme**: Crisp editorial typography, airy card surfaces, soft shadows (`#F8FAFC`).
- **Dark Theme**: Deep luxury slate surfaces (`#1E293B`), refined border contrasts (`#334155`), and OLED battery savings.
- Toggle between themes anytime from the floating theme toggle button on the details screen!

---

## 👨‍💻 Author

Crafted with passion for mobile user experience by **Noufel** — [GitHub Profile](https://github.com/Noufel-sf).

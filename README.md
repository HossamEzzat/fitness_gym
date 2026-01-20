# 🏋️‍♂️ GymFlow - Premium Gym Membership Management

GymFlow is a sleek, modern Flutter application designed for fitness gym owners to manage memberships effortlessly. Built with a focus on performance and clean architecture, it provides a seamless experience for tracking member status, expiration dates, and gym statistics.

## ✨ Key Features

- **📊 Dynamic Dashboard**: Get an overview of total members, active versus expired memberships, and recent activity at a glance.
- **👥 Member Management**: Easily add, edit, and remove members with detailed profiles including plan types and registration dates.
- **🕒 Status Tracking**: Real-time tracking of membership expiration with visual indicators for active and expired statuses.
- **🔍 Fast Search**: Quickly find members by name or ID using the integrated search functionality.
- **📱 Responsive UI**: Beautifully designed interface with glassmorphism elements, custom animations, and Google Fonts integration.
- **💾 Local Persistence**: Reliable data storage using Hive for offline access and fast performance.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Bloc (flutter_bloc)](https://pub.dev/packages/flutter_bloc)
- **Local Database**: [Hive](https://pub.dev/packages/hive)
- **Dependency Injection**: Factory-based clean architecture
- **Design System**: Custom Material Design with Google Fonts (Inter, Outfit)
- **Utilities**: `uuid`, `intl`, `equatable`

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.10.4 or higher)
- Android Studio / VS Code
- Dart SDK

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/HossamEzzat/fitness_gym.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd fitness_gym
   ```

3. **Install dependencies**:

   ```bash
   flutter pub get
   ```

4. **Generate Hive Adapters**:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the application**:

   ```bash
   flutter run
   ```

---
Built with ❤️ by Hossam Ezzat

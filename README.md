# FitFlow 🏋️‍♂️🥗

A comprehensive fitness and meal tracking mobile application built with Flutter and Firebase, featuring AI-powered personalized recommendations for workouts and nutrition.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [AI Integration](#ai-integration)
- [Admin Dashboard](#admin-dashboard)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

FitFlow is an all-in-one fitness and nutrition management platform designed to help users achieve their health goals through personalized tracking, AI-powered recommendations, and expert guidance. Whether you're looking to lose weight, gain muscle, or maintain a healthy lifestyle, FitFlow provides the tools and support you need.

## ✨ Features

### 🔐 User Authentication & Profile Management
- Secure sign-up/sign-in with Firebase Authentication
- Personalized user profiles with customizable avatars
- Profile editing (name, age, weight, password)

### 🏠 Home Dashboard
- Personalized daily progress tracking
- Real-time metrics: steps, calories burned, water intake
- Quick access to workouts and meal logging
- Activity overview with visual progress indicators

### 🍽️ Nutrition Tracking
- **Daily Calorie Tracking**: Monitor intake vs. goals (e.g., 0/2000 Cal)
- **Meal Logging**: Browse and log meals by category (Breakfast, Brunch, Lunch & Snacks)
- **Meal Details**: View ingredients, preparation time, and step-by-step instructions
- **FoodGPT AI Assistant**: Get personalized meal recommendations based on:
  - Fitness goals (weight gain/loss/maintenance)
  - Available ingredients
  - Calorie requirements
  - Dietary preferences

### 💪 Workout Management
- **Multiple Workout Categories**:
  - Indoor workouts (strength training, HIIT, yoga)
  - Outdoor activities (running, cycling, walking)
  - Stretching routines
  - Condition-specific workouts (Depression, Knee Pain, Obesity, etc.)
- **Real-time Activity Tracking**:
  - Distance, speed, duration
  - Calories burned
  - Weekly progress visualization
- **WorkoutGPT AI Assistant**: Generate personalized workout plans based on:
  - Health conditions
  - Occupation
  - Fitness goals
  - Weekly scheduling

### 📱 Additional Features
- **Custom Reminders**: Water intake notifications and custom task reminders
- **Chatting Hub**: Direct communication with coaches, doctors, and admins
- **User Videos Library**: Save and organize favorite workouts by day
- **Privacy Controls**: Manage notifications, location services, and data sharing

### 🖥️ Web Platform
- Landing page with platform statistics
- Admin dashboard for user and content management
- Video management system
- User role assignment (coach, doctor, admin)

## 📸 Screenshots

> Add your app screenshots here

## 🛠️ Tech Stack

- **Frontend**: Flutter (Cross-platform: iOS & Android)
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore (NoSQL database)
  - Cloud Storage
  - Push Notifications
- **AI Integration**: ChatGPT API (FoodGPT & WorkoutGPT)
- **Design**: Inspired by Behance and Pinterest
- **Version Control**: Git & GitHub
- **Testing**: Flutter's built-in testing framework

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account
- OpenAI API key (for AI features)
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/fitflow.git
cd fitflow
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Create a new Firebase project
   - Add your Android/iOS app to Firebase
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **Set up environment variables**
```bash
# Create a .env file in the root directory
OPENAI_API_KEY=your_api_key_here
FIREBASE_API_KEY=your_firebase_key_here
```

5. **Run the app**
```bash
flutter run
```

## 🏗️ Architecture

### Database Structure
```
Users/
└── User ID/
    ├── Profile: {name, email, age, weight, height}
    ├── Meals/
    │   └── meal_id: {foodName, calories, date}
    └── Workouts/
        └── workout_id: {type, duration, caloriesBurned, date}
```

### Project Structure
```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── services/        # Firebase & API services
├── utils/           # Helper functions
└── main.dart        # App entry point
```

## 🤖 AI Integration

### FoodGPT
FoodGPT provides personalized meal recommendations through an interactive chat interface:
- Calculates daily calorie needs based on user goals
- Suggests meals based on available ingredients
- Provides detailed recipes with calorie counts
- Supports weight gain, loss, and maintenance goals

### WorkoutGPT
WorkoutGPT creates customized workout plans considering:
- User's health conditions
- Occupation and lifestyle
- Fitness objectives
- Weekly scheduling preferences

## 👨‍💼 Admin Dashboard

Administrators have access to:
- **User Management**: View, edit, and delete user accounts
- **Role Assignment**: Set users as coaches or doctors
- **Video Management**: Add, edit, or remove workout videos
- **Content Moderation**: Ensure platform quality

Admin login credentials are managed separately for security.

## 🔮 Future Enhancements

- [ ] Wearable device integration (Fitbit, Apple Watch)
- [ ] Social features (challenges, community sharing)
- [ ] Gamification (rewards, badges, leaderboards)
- [ ] Advanced AI features based on user habits
- [ ] Expanded web dashboard capabilities
- [ ] Multi-language support
- [ ] Offline mode functionality

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/fitflow](https://github.com/yourusername/fitflow)

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [Firebase](https://firebase.google.com) - Backend services
- [OpenAI](https://openai.com) - ChatGPT API
- [Behance](https://www.behance.net) - Design inspiration
- [Pinterest](https://www.pinterest.com) - UI/UX ideas

---

Made with ❤️ by [Your Name]

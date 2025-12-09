# VibeMatch 🎯

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Socket.io](https://img.shields.io/badge/Socket.io-010101?style=for-the-badge&logo=socket.io&logoColor=white)

**A modern real-time chat application with Firebase integration and custom backend services**

[Features](#features) • [Architecture](#architecture) • [Installation](#installation) • [Documentation](#documentation)

</div>

---

## 📖 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Development Guide](#development-guide)
- [Backend API Documentation](#backend-api-documentation)
- [Deployment](#deployment)
- [Contributing](#contributing)

---

## 🎯 Overview

**VibeMatch** is a feature-rich, real-time chat application built with Flutter for cross-platform mobile support and a custom Node.js backend service. The application leverages Firebase services for authentication, cloud storage, and push notifications, while using a dedicated backend service (chat-service-backend) for user management and real-time messaging via Socket.IO.

### Key Highlights

- 🔐 **Secure Authentication**: Firebase Authentication integration
- 💬 **Real-time Messaging**: Socket.IO powered instant messaging
- 👥 **Friend Management**: Add, search, and manage friends
- 🖼️ **Media Sharing**: Image upload and sharing capabilities
- 🔔 **Push Notifications**: Firebase Cloud Messaging integration
- 📱 **Cross-Platform**: Runs on Android, iOS, and Web
- 🎨 **Modern UI**: Clean and intuitive user interface with curved navigation

---

## ✨ Features

### User Features

- **Authentication**
  - Email/password registration and login
  - Firebase Authentication integration
  - Secure session management

- **Profile Management**
  - User profile creation and editing
  - Profile picture upload
  - Gender and date of birth settings
  - Display name customization

- **Chat System**
  - One-on-one real-time messaging
  - Message history with Firestore
  - Image sharing in conversations
  - Typing indicators
  - Read receipts

- **Social Features**
  - User search functionality
  - Friend list management
  - Friend request system
  - Online status indicators

- **Notifications**
  - Push notifications for new messages
  - Local notifications support
  - Firebase Cloud Messaging integration

---

## 🏗️ Architecture

VibeMatch follows a modern client-server architecture with multiple backend services:

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer                             │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │           Flutter Mobile Application                      │   │
│  │  (Android, iOS, Web)                                      │   │
│  │                                                            │   │
│  │  ┌──────────┐  ┌───────────┐  ┌──────────┐              │   │
│  │  │  Auth    │  │  Chat     │  │ Profile  │              │   │
│  │  │  Screen  │  │  Screen   │  │  Screen  │              │   │
│  │  └──────────┘  └───────────┘  └──────────┘              │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                           │
                           │ HTTPS / WebSocket
                           │
┌──────────────────────────┼────────────────────────────────────┐
│                          │    Backend Services                │
│                          ▼                                     │
│  ┌────────────────────────────────────────────────────────┐   │
│  │         Firebase Services (Google Cloud)               │   │
│  │                                                          │   │
│  │  ┌──────────────┐  ┌─────────────┐  ┌──────────────┐  │   │
│  │  │ Firebase     │  │ Cloud       │  │ Cloud        │  │   │
│  │  │ Auth         │  │ Firestore   │  │ Storage      │  │   │
│  │  └──────────────┘  └─────────────┘  └──────────────┘  │   │
│  │                                                          │   │
│  │  ┌──────────────┐  ┌─────────────┐                     │   │
│  │  │ Firebase     │  │ Cloud       │                     │   │
│  │  │ Messaging    │  │ Functions   │                     │   │
│  │  └──────────────┘  └─────────────┘                     │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐   │
│  │    Custom Backend Service (chat-service-backend)       │   │
│  │          Node.js + Express + TypeScript                │   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐  │   │
│  │  │            Express REST API                       │  │   │
│  │  │  • /v1/user/insert - Create user                 │  │   │
│  │  │  • /v1/user/update - Update user profile         │  │   │
│  │  │  • /v1/user/get - Get user details               │  │   │
│  │  │  • /api-docs - Swagger documentation             │  │   │
│  │  └──────────────────────────────────────────────────┘  │   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐  │   │
│  │  │         Socket.IO Server (Real-time)             │  │   │
│  │  │  • WebSocket connections                          │  │   │
│  │  │  • Real-time message broadcasting                 │  │   │
│  │  │  • Event handling (message, hello, etc.)          │  │   │
│  │  └──────────────────────────────────────────────────┘  │   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐  │   │
│  │  │         MongoDB Database (Mongoose)              │  │   │
│  │  │  • User collection                                │  │   │
│  │  │  • Profile data                                   │  │   │
│  │  │  • Friend relationships                           │  │   │
│  │  └──────────────────────────────────────────────────┘  │   │
│  └────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Architecture Components

#### Frontend (Flutter)
- **Framework**: Flutter 2.19.6+
- **Language**: Dart
- **State Management**: StatefulWidget with local state
- **Navigation**: MaterialApp with route-based navigation
- **UI Components**: Material Design widgets, Curved Navigation Bar

#### Backend Services

##### Firebase Services
- **Authentication**: User authentication and session management
- **Firestore**: Real-time database for chat messages and user data
- **Storage**: Cloud storage for images and media files
- **Cloud Messaging**: Push notifications
- **Cloud Functions**: Serverless functions for backend logic

##### Custom Backend (chat-service-backend)
- **Framework**: Express.js with TypeScript
- **Runtime**: Node.js
- **Real-time**: Socket.IO for WebSocket connections
- **Database**: MongoDB with Mongoose ODM
- **API Documentation**: Swagger/OpenAPI
- **Security**: Helmet.js, CORS
- **Logging**: Morgan

---

## 🛠️ Technology Stack

### Frontend

| Technology | Purpose | Version |
|-----------|---------|---------|
| Flutter | Cross-platform mobile framework | >=2.19.6 <3.0.0 |
| Dart | Programming language | - |
| Firebase SDK | Firebase integration | Latest |
| firebase_auth | Authentication | ^5.1.2 |
| cloud_firestore | Real-time database | ^5.1.0 |
| firebase_storage | Cloud storage | ^12.1.1 |
| firebase_messaging | Push notifications | ^15.0.3 |
| image_picker | Image selection | ^1.1.2 |
| flutter_local_notifications | Local notifications | ^17.2.1+1 |
| curved_navigation_bar | Navigation UI | ^1.0.3 |

### Backend (Server)

| Technology | Purpose | Version |
|-----------|---------|---------|
| Node.js | Runtime environment | - |
| TypeScript | Programming language | ^5.1.3 |
| Express | Web framework | ^4.18.2 |
| Socket.IO | Real-time communication | ^4.6.2 |
| MongoDB | Database | - |
| Mongoose | MongoDB ODM | ^7.2.4 |
| Helmet | Security middleware | ^7.0.0 |
| Morgan | HTTP request logger | ^1.10.0 |
| CORS | Cross-origin resource sharing | - |
| dotenv | Environment variables | ^16.1.4 |
| Swagger | API documentation | - |

---

## 📁 Project Structure

```
vibe-match/
├── android/                    # Android native code
│   ├── app/
│   │   ├── build.gradle       # Android build configuration
│   │   └── src/
│   │       └── main/
│   │           └── AndroidManifest.xml
│   └── build.gradle
│
├── ios/                       # iOS native code
│   └── Runner/
│       └── Info.plist        # iOS configuration
│
├── lib/                       # Flutter application code
│   ├── main.dart             # Application entry point
│   ├── AuthScreen.dart       # Authentication screen
│   ├── HomeScreen.dart       # Home screen
│   ├── MainScreen.dart       # Main navigation screen
│   ├── ChatScreen.dart       # Chat interface
│   ├── TempChatScreen.dart   # Temporary chat screen
│   ├── ProfileScreen.dart    # User profile screen
│   ├── SearchScreen.dart     # User search screen
│   ├── FriendListScreen.dart # Friend list screen
│   ├── TempScreen.dart       # Temporary screen
│   ├── UserData.dart         # User data model
│   ├── firebase_options.dart # Firebase configuration
│   ├── components/           # Reusable components
│   │   └── ChatTile.dart    # Chat list tile component
│   └── services/            # Service layer
│       ├── userService.dart # User service
│       └── AsyncNavigator.dart # Navigation helper
│
├── server/                   # Backend server (chat-service-backend)
│   ├── src/
│   │   ├── index.ts         # Server entry point
│   │   ├── App.ts           # Express app configuration
│   │   ├── socketServer.ts  # Socket.IO configuration
│   │   └── api/
│   │       └── v1/          # API version 1
│   │           ├── index.ts # API routes
│   │           ├── models/  # Database models
│   │           │   └── UserModel.ts
│   │           ├── interfaces/ # TypeScript interfaces
│   │           │   ├── IUser.ts
│   │           │   ├── IRequest.ts
│   │           │   └── IResponse.ts
│   │           ├── controllers/ # Request handlers
│   │           │   └── userControllers.ts
│   │           ├── services/ # Business logic
│   │           │   └── userServices.ts
│   │           └── routes/  # Route definitions
│   │               └── userRoute.ts
│   ├── package.json         # Node.js dependencies
│   ├── tsconfig.json        # TypeScript configuration
│   ├── api.yml              # Swagger API documentation
│   └── .env                 # Environment variables
│
├── web/                     # Web platform code
│   └── manifest.json        # Web app manifest
│
├── test/                    # Test files
│   └── widget_test.dart     # Widget tests
│
├── pubspec.yaml            # Flutter dependencies
├── package.json            # Root package configuration
├── firebase.json           # Firebase configuration
├── firestore.rules         # Firestore security rules
├── storage.rules           # Storage security rules
├── database.rules.json     # Realtime database rules
└── README.md              # This file
```

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### For Frontend Development

- **Flutter SDK** (>=2.19.6 <3.0.0)
  ```bash
  # Check Flutter installation
  flutter --version
  ```

- **Dart SDK** (included with Flutter)

- **Android Studio** (for Android development)
  - Android SDK
  - Android Emulator

- **Xcode** (for iOS development, macOS only)
  - iOS Simulator
  - CocoaPods

- **VS Code** or **Android Studio** (recommended IDEs)

### For Backend Development

- **Node.js** (v14 or higher)
  ```bash
  # Check Node.js installation
  node --version
  ```

- **npm** or **yarn** (package manager)
  ```bash
  # Check npm installation
  npm --version
  ```

- **MongoDB** (local installation or cloud instance)
  - MongoDB Atlas account (recommended)
  - Or local MongoDB server

- **TypeScript** (installed as dev dependency)

### Additional Requirements

- **Firebase Account**
  - Create a project at [Firebase Console](https://console.firebase.google.com/)
  - Enable Authentication, Firestore, Storage, and Cloud Messaging

- **Git** (for version control)

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/theQuarky/vibe-match.git
cd vibe-match
```

### 2. Frontend Setup

#### Install Flutter Dependencies

```bash
# Install Flutter packages
flutter pub get

# Verify installation
flutter doctor
```

#### Configure Firebase

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)

2. Add Android App:
   - Package name: `com.example.vibe_match`
   - Download `google-services.json`
   - Place it in `android/app/`

3. Add iOS App:
   - Bundle ID: `com.example.vibeMatch`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

4. Enable Firebase Services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Cloud Storage
   - Cloud Messaging

5. Update `lib/firebase_options.dart` with your Firebase configuration:
   ```bash
   # Use FlutterFire CLI to configure
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

### 3. Backend Setup

#### Install Backend Dependencies

```bash
cd server
npm install
```

#### Configure Environment Variables

Create a `.env` file in the `server` directory:

```env
# MongoDB Configuration
DB_URL=mongodb://localhost:27017/vibe-match
# Or use MongoDB Atlas
# DB_URL=mongodb+srv://username:password@cluster.mongodb.net/vibe-match

# Server Configuration
PORT=3000
NODE_ENV=development

# Add other configuration as needed
```

#### Build TypeScript

```bash
npm run build
```

---

## ⚙️ Configuration

### Firestore Rules

Update `firestore.rules` for your security requirements:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Chats collection
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Storage Rules

Update `storage.rules` for file upload security:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /user-images/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

### MongoDB Connection

Ensure MongoDB is running:

```bash
# For local MongoDB
mongod

# Or use MongoDB Atlas cloud service
```

---

## 🎮 Running the Application

### Start Backend Server

```bash
cd server

# Development mode with hot reload
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:3000`

- API endpoints: `http://localhost:3000/v1/*`
- API documentation: `http://localhost:3000/api-docs`
- Socket.IO: `http://localhost:3000/socket.io`

### Start Flutter Application

#### Run on Android Emulator

```bash
# List available devices
flutter devices

# Run on Android
flutter run
```

#### Run on iOS Simulator (macOS only)

```bash
# Run on iOS
flutter run -d ios
```

#### Run on Web

```bash
flutter run -d chrome
```

#### Run in Release Mode

```bash
# Android
flutter run --release

# iOS
flutter run --release -d ios
```

---

## 💻 Development Guide

### Project Architecture Patterns

#### Frontend Structure

- **Screens**: Each screen is a separate StatefulWidget
- **Components**: Reusable widgets in the `components/` directory
- **Services**: Business logic and API calls in the `services/` directory
- **Navigation**: Route-based navigation with MaterialApp

#### Backend Structure

- **MVC Pattern**: Model-View-Controller architecture
- **Layered Architecture**:
  - **Routes**: Define API endpoints
  - **Services**: Business logic and validation
  - **Controllers**: Request/response handling
  - **Models**: Database schemas

### API Endpoints

#### User Management

```
POST /v1/user/insert
- Create a new user
- Body: { uid, displayName, gender, dob, deviceToken, imageUrl }

POST /v1/user/update
- Update user profile
- Body: { uid, ...updateData }

GET /v1/user/get?uid={userId}
- Get user details
- Query: uid (required)
```

#### Socket.IO Events

```javascript
// Client to Server
socket.emit('message', { text: 'Hello', userId: 'abc123' });
socket.emit('hello');

// Server to Client
socket.on('message', (data) => {
  console.log('New message:', data);
});
```

### Database Schema

#### User Model

```typescript
{
  uid: String (unique),
  displayName: String,
  gender: "male" | "female",
  dob: Date,
  deviceToken: String,
  friends: Array<Object>,
  isActive: Boolean,
  imageUrl: String,
  isDeleted: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### Testing

#### Run Flutter Tests

```bash
flutter test
```

#### Run Backend Tests (if configured)

```bash
cd server
npm test
```

### Code Style

#### Flutter/Dart

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` for linting
- Format code: `dart format .`

#### TypeScript

- Follow TypeScript best practices
- Use ESLint for linting
- Format code with Prettier

---

## 📚 Backend API Documentation

### Swagger Documentation

The backend provides interactive API documentation using Swagger UI.

**Access Swagger UI:**
```
http://localhost:3000/api-docs
```

### API Response Format

All API responses follow this structure:

```json
{
  "success": true,
  "data": { },
  "message": "Success message",
  "error": null
}
```

### Authentication

Currently, the API uses Firebase UID for user identification. Future versions may include JWT authentication.

---

## 🚢 Deployment

### Deploy Backend

#### Heroku Deployment

```bash
cd server

# Login to Heroku
heroku login

# Create Heroku app
heroku create your-app-name

# Set environment variables
heroku config:set DB_URL=your_mongodb_url

# Deploy
git push heroku main
```

#### Docker Deployment

```bash
cd server

# Build Docker image
docker build -t vibe-match-server .

# Run container
docker run -p 3000:3000 --env-file .env vibe-match-server
```

### Deploy Flutter App

#### Android Release Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS Release Build

```bash
# Build iOS app
flutter build ios --release
```

Then archive and upload using Xcode.

#### Web Deployment

```bash
# Build web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Firebase Deployment

```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage:rules

# Deploy Cloud Functions (if any)
firebase deploy --only functions
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Workflow

1. Always create a new branch for your feature
2. Write clean, documented code
3. Follow the existing code style
4. Test your changes thoroughly
5. Update documentation as needed

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👥 Authors

- **theQuarky** - [GitHub](https://github.com/theQuarky)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Socket.IO for real-time communication
- MongoDB for the database
- All contributors and supporters

---

## 📞 Support

For support and questions:

- Create an issue on GitHub
- Contact: [Your contact information]

---

## 🔄 Changelog

### Version 1.0.0 (Current)

- Initial release
- Real-time chat functionality
- User authentication
- Profile management
- Friend system
- Firebase integration
- Custom backend service

---

<div align="center">

**Made with ❤️ by theQuarky**

</div>

## 💻 PCify Platform

PCify is a modern, cross-platform application built with Flutter, designed to streamline PC management and technical services. It leverages Firebase for real-time data synchronization, authentication, and cloud storage.

## 📖 Table of Contents

Features

Architecture & Security

Getting Started

Prerequisites

Setup & Installation

Environment Configuration

Project Structure

Contributing

License

✨ Features

Cross-Platform: Supports Web, Android, iOS, macOS, and Windows.

Real-time Backend: Powered by Firebase.

Secure Configuration: Uses environment variables for sensitive API keys.

Clean UI: Modern design following Material and Cupertino guidelines.

🔒 Architecture & Security

To prevent the exposure of sensitive credentials (like Firebase API keys), this project utilizes a Decoupled Configuration Strategy:

Environment Files: All API keys are stored in a local .env file.

Ignored by Git: The .env file is listed in .gitignore to prevent accidental commits.

Runtime Injection: Keys are loaded at runtime using the flutter_dotenv package.

🚀 Getting Started

Prerequisites

Flutter SDK: Install Flutter

Dart SDK: Included with Flutter

Firebase Project: Set up a project

Setup & Installation

Clone the Repository

git clone [https://github.com/kishor-2646/PCify.git](https://github.com/kishor-2646/PCify.git)
cd PCify


Install Dependencies

flutter pub get


Configure Environment
Follow the steps in the Environment Configuration section below.

Run the App

flutter run


🔑 Environment Configuration

Create a file named .env in the root of your project and populate it with your Firebase project details:

# Web & Windows Configuration
FIREBASE_WEB_API_KEY=your_key_here
FIREBASE_WEB_APP_ID=your_id_here

# Android Configuration
FIREBASE_ANDROID_API_KEY=your_key_here
FIREBASE_ANDROID_APP_ID=your_id_here

# iOS & macOS Configuration
FIREBASE_IOS_API_KEY=your_key_here
FIREBASE_IOS_APP_ID=your_id_here

# Common Project Details
FIREBASE_MESSAGING_SENDER_ID=your_id_here
FIREBASE_PROJECT_ID=pcify-platform
FIREBASE_STORAGE_BUCKET=pcify-platform.firebasestorage.app
FIREBASE_AUTH_DOMAIN=pcify-platform.firebaseapp.com


[!WARNING]
Never share your .env file or upload it to GitHub. It contains keys that identify your specific Firebase project.

🛠 Project Structure

PCify/
├── .env                # Secret environment variables (Local only)
├── lib/
│   ├── main.dart       # App entry point (loads dotenv)
│   ├── firebase_options.dart # Reads keys from .env
│   └── ...             # Feature-specific code
├── assets/             # Images, fonts, and icons
└── pubspec.yaml        # Project dependencies & asset declarations


🤝 Contributing

Contributions are welcome! Please ensure that any new keys or sensitive configurations follow the .env pattern established in this project.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

📄 License

This project is licensed under the MIT License - see the LICENSE page for details.
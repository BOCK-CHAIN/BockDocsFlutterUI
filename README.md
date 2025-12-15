  

# BockDocs Frontend Documentation

## Overview

The **BockDocs Frontend** is a **Flutter-based cross-platform application** that allows users to create, edit, and share documents seamlessly across **web, mobile, and desktop** platforms.

* * *

## Supported Platforms

*   Web (Chrome, Firefox, Safari, Edge)
    
*   Android
    
*   iOS
    
*   macOS
    
*   Windows
    
*   Linux
    

* * *

## Tech Stack

*   **Framework**: Flutter 3.8.1+
    
*   **Language**: Dart
    
*   **State Management**: Provider 6.1.0
    
*   **HTTP Client**: http 1.2.0
    
*   **Secure Storage**:
    
    *   flutter\_secure\_storage 9.0.0
        
    *   shared\_preferences 2.2.3
        
*   **PDF Export**: pdf 3.11.1, printing 5.13.3
    
*   **Google Sign-In**: google\_sign\_in 6.2.1
    
*   **File Handling**: file\_picker, path\_provider
    

* * *

## Project Structure

```
BockDocs/
├── frontend/                   # Flutter application
│   ├── lib/
│   │   ├── main.dart          # App entry point
│   │   ├── config/
│   │   │   └── api_config.dart # API configuration
│   │   ├── models/
│   │   │   └── document_model.dart # Data models
│   │   ├── pages/             # App screens
│   │   │   ├── login_page.dart
│   │   │   ├── sign_up_page.dart
│   │   │   ├── home_page.dart
│   │   │   ├── editor_page.dart
│   │   │   └── settings_page.dart
│   │   ├── services/
│   │   │   └── email_service.dart
│   │   ├── widgets/
│   │   │   ├── custom_widgets.dart
│   │   │   └── share_dialog.dart
│   │   ├── utils/             # Utility functions
│   │   │   ├── document_formats.dart
│   │   │   ├── document_tabs_manager.dart
│   │   │   ├── download_helper.dart
│   │   │   └── file_handler.dart
│   │   └── theme_provider.dart # Theme management
│   ├── android/               # Android-specific files
│   ├── ios/                   # iOS-specific files
│   ├── web/                   # Web-specific files
│   ├── macos/                 # macOS-specific files
│   ├── windows/               # Windows-specific files
│   ├── linux/                 # Linux-specific files
│   └── pubspec.yaml           # Flutter dependencies
│
└── README.md                   # This file
```

* * *

## Setup Instructions

### Prerequisites

*   Flutter SDK 3.8.1+
    
*   Dart SDK
    
*   Backend server running
    

* * *

### Installation

`cd frontend flutter pub get`

* * *

### API Configuration

Edit:

`lib/config/api_config.dart`

Set backend URL:

`static const String _defaultLocalUrl = 'http://localhost:5050/api';`

* * *

### Run Application

`flutter run -d chrome flutter run -d android flutter run -d ios flutter run -d macos`

* * *

## Application Pages

### Login Page

*   Email/password login
    
*   Google sign-in
    
*   Forgot password
    

### Sign Up Page

*   Email registration
    
*   Password validation
    
*   Google sign-up
    

### Home Page

*   Document list
    
*   Create document
    
*   Delete / Share actions
    

### Editor Page

*   Rich text editor
    
*   Auto-save
    
*   Title editing
    
*   Share dialog
    

### Settings Page

*   Profile update
    
*   Password change
    
*   Account deletion
    
*   Theme switching
    

* * *

## State Management

Uses **Provider** for:

*   Theme state
    
*   UI updates
    
*   Session handling
    

* * *

## Authentication Flow

1.  User logs in
    
2.  JWT token received
    
3.  Token stored securely
    
4.  Token attached to API requests
    
5.  Session restored on app restart
    

* * *

## Mobile Configuration

### Android Emulator

`http://10.0.2.2:5050/api`

### Physical Devices

Use your computer’s IP address:

`http://192.168.x.x:5050/api`

* * *

## Web Build

`flutter build web`

Deploy contents of `build/web`.

* * *

## Troubleshooting

**Backend unreachable**

*   Verify API URL
    
*   Ensure backend is running
    
*   Check network/IP for mobile
    

**Build errors**

`flutter clean flutter pub get flutter run`

**Google Sign-In issues**

*   Verify Google Client ID
    
*   Ensure correct OAuth configuration
    

* * *

## License

MIT License

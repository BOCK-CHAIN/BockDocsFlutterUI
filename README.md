
# BockDocs - Complete Documentation

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Tech Stack](#tech-stack)
5. [Project Structure](#project-structure)
6. [Getting Started](#getting-started)
7. [Backend Documentation](#backend-documentation)
8. [Frontend Documentation](#frontend-documentation)
9. [API Reference](#api-reference)
10. [Database Schema](#database-schema)
11. [Authentication](#authentication)
12. [Document Sharing](#document-sharing)
13. [Email Configuration](#email-configuration)
14. [Mobile Development](#mobile-development)
15. [Deployment](#deployment)
16. [Troubleshooting](#troubleshooting)

---

## Project Overview

**BockDocs** is a modern, cross-platform document editor application that allows users to create, edit, and share documents. The application supports web, iOS, Android, and desktop platforms, providing a seamless experience across all devices.

### Key Capabilities

- **Document Management**: Create, edit, save, and delete documents
- **User Authentication**: Email/password and Google OAuth sign-in
- **Document Sharing**: Share documents via links or email with view/edit permissions
- **Cross-Platform**: Works on web, iOS, Android, macOS, Windows, and Linux
- **Real-time Editing**: Save documents with automatic synchronization
- **Password Recovery**: Forgot password functionality with email reset links

---

## Architecture

BockDocs follows a **client-server architecture**:

```
┌─────────────────┐
│   Flutter App   │  (Frontend - Web, iOS, Android, Desktop)
│   (Dart)        │
└────────┬────────┘
         │ HTTP/REST API
         │
┌────────▼────────┐
│  Node.js/Express│  (Backend Server)
│   (JavaScript)  │
└────────┬────────┘
         │
┌────────▼────────┐
│  PostgreSQL     │  (Database - Neon)
│   (via Prisma)  │
└─────────────────┘
```

### Components

- **Frontend**: Flutter application with Dart
- **Backend**: Node.js with Express.js
- **Database**: PostgreSQL (hosted on Neon)
- **ORM**: Prisma for database operations
- **Authentication**: JWT tokens + Google OAuth
- **Email**: Nodemailer for transactional emails

---

## Features

### User Features

- ✅ User registration and login
- ✅ Google OAuth authentication
- ✅ Profile management
- ✅ Password change and recovery
- ✅ Account deletion

### Document Features

- ✅ Create new documents
- ✅ Edit documents with rich text
- ✅ Save documents automatically
- ✅ Delete documents
- ✅ View document list
- ✅ Document sharing via links
- ✅ Share documents via email
- ✅ View-only and edit permissions
- ✅ Expiring share links

### Platform Support

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ iOS (Simulator and Physical Devices)
- ✅ Android (Emulator and Physical Devices)
- ✅ macOS
- ✅ Windows
- ✅ Linux

---

## Tech Stack

### Backend

- **Runtime**: Node.js
- **Framework**: Express.js 5.1.0
- **Database**: PostgreSQL (Neon)
- **ORM**: Prisma 6.16.3
- **Authentication**: JWT (jsonwebtoken 9.0.2)
- **Password Hashing**: bcryptjs 3.0.2
- **Email**: nodemailer 7.0.10
- **Google Auth**: google-auth-library 10.5.0
- **CORS**: cors 2.8.5

### Frontend

- **Framework**: Flutter 3.8.1+
- **Language**: Dart
- **State Management**: Provider 6.1.0
- **HTTP Client**: http 1.2.0
- **Storage**: 
  - flutter_secure_storage 9.0.0 (secure token storage)
  - shared_preferences 2.2.3 (settings)
- **PDF**: pdf 3.11.1, printing 5.13.3
- **Google Sign-In**: google_sign_in 6.2.1
- **File Operations**: file_picker 8.1.2, path_provider 2.1.1

---

## Project Structure

```
BockDocs/
├── backend/                    # Node.js backend server
│   ├── controllers/            # Route controllers
│   │   ├── authController.js   # Authentication logic
│   │   └── documentController.js # Document CRUD operations
│   ├── middleware/            # Express middleware
│   │   ├── authMiddleware.js   # JWT authentication
│   │   └── optionalAuthMiddleware.js # Optional auth for shared docs
│   ├── routes/                # API route definitions
│   │   ├── authRoutes.js      # Auth endpoints
│   │   └── documentRoutes.js   # Document endpoints
│   ├── utils/                 # Utility functions
│   │   └── emailService.js    # Email sending service
│   ├── prisma/                # Database schema and migrations
│   │   ├── schema.prisma      # Prisma schema
│   │   └── migrations/        # Database migrations
│   ├── generated/             # Prisma generated client
│   ├── prismaClient.js        # Prisma client instance
│   ├── index.js               # Server entry point
│   └── package.json           # Backend dependencies
│
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

---

## Getting Started

### Prerequisites

- **Node.js** 18+ and npm
- **Flutter** 3.8.1+ and Dart SDK
- **PostgreSQL** database (Neon account recommended)
- **Google Cloud Console** account (for OAuth)
- **Email service** (Gmail or custom SMTP, optional)

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Configure environment variables:**
   Create a `.env` file in the `backend` directory:
   ```env
   # Database
   DATABASE_URL=postgresql://user:password@host/database?sslmode=require
   
   # JWT Secret
   JWT_SECRET=your_secure_jwt_secret_key_here
   
   # Google OAuth (optional)
   GOOGLE_CLIENT_ID=your_google_client_id
   
   # Email Configuration (optional)
   EMAIL_SERVICE=gmail
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASSWORD=your-app-password
   EMAIL_FROM=noreply@bockdocs.com
   
   # Frontend URL (for email links)
   FRONTEND_BASE_URL=http://localhost:8080
   FRONTEND_URL=http://localhost:5000
   
   # Server Configuration
   PORT=5050
   HOST=0.0.0.0
   NODE_ENV=development
   ```

4. **Set up Prisma:**
   ```bash
   npx prisma generate
   npx prisma migrate deploy
   ```

5. **Start the server:**
   ```bash
   npm start
   # Or for development with auto-reload:
   npm run dev
   ```

   The server will start on `http://localhost:5050` (or the port specified in `.env`).

### Frontend Setup

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint:**
   Edit `lib/config/api_config.dart` to set your backend URL:
   ```dart
   static const String _defaultLocalUrl = 'http://localhost:5050/api';
   ```

4. **Run the application:**
   ```bash
   # Web
   flutter run -d chrome
   
   # iOS Simulator
   flutter run -d "iPhone Simulator"
   
   # Android Emulator
   flutter run -d "Android Emulator"
   
   # Desktop
   flutter run -d macos  # or windows, linux
   ```

---

## Backend Documentation

### Server Configuration

The backend server (`backend/index.js`) is configured to:
- Listen on all network interfaces (`0.0.0.0`) for mobile device access
- Use CORS to allow requests from web and mobile clients
- Handle JSON request bodies
- Provide a health check endpoint at `/health`

### Controllers

#### Auth Controller (`controllers/authController.js`)

Handles all authentication-related operations:

- **signUp**: Register new users with email/password
- **signIn**: Authenticate users with email/password
- **googleAuth**: Authenticate with Google ID token
- **googleAuthWithAccessToken**: Authenticate with Google access token
- **getCurrentUser**: Get authenticated user's profile
- **updateProfile**: Update user name and email
- **changePassword**: Change user password
- **deleteAccount**: Delete user account
- **forgotPassword**: Initiate password reset
- **resetPassword**: Complete password reset with token
- **logout**: Logout (client-side token removal)

#### Document Controller (`controllers/documentController.js`)

Handles all document-related operations:

- **createDocument**: Create a new document
- **getDocument**: Get a document by ID
- **getUserDocuments**: Get all documents for a user
- **saveDocument**: Update document (supports share tokens)
- **deleteDocument**: Delete a document
- **createShareLink**: Generate a shareable link
- **getSharedDocument**: Get document via share token
- **shareDocumentWithEmail**: Share document via email

### Middleware

#### Auth Middleware (`middleware/authMiddleware.js`)

Validates JWT tokens from the `Authorization` header:
```
Authorization: Bearer <token>
```

#### Optional Auth Middleware (`middleware/optionalAuthMiddleware.js`)

Allows routes to work with either JWT tokens or share tokens, useful for shared document editing.

### Routes

#### Auth Routes (`routes/authRoutes.js`)

- `POST /api/auth/signup` - Register new user
- `POST /api/auth/signin` - Login
- `POST /api/auth/google` - Google OAuth (ID token)
- `POST /api/auth/google-access` - Google OAuth (access token)
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password with token
- `GET /api/auth/me` - Get current user (protected)
- `PUT /api/auth/profile` - Update profile (protected)
- `PUT /api/auth/password` - Change password (protected)
- `DELETE /api/auth/account` - Delete account (protected)
- `POST /api/auth/logout` - Logout (protected)

#### Document Routes (`routes/documentRoutes.js`)

- `POST /api/documents/create` - Create document (protected)
- `GET /api/documents` - Get user's documents (protected)
- `GET /api/documents/:id` - Get document by ID (protected)
- `PUT /api/documents/save/:id` - Save document (protected or share token)
- `DELETE /api/documents/delete/:id` - Delete document (protected)
- `POST /api/documents/share/:docId` - Create share link (protected)
- `GET /api/documents/share/:token` - Get shared document (public)
- `POST /api/documents/share/:docId/email` - Share via email (protected)

### Email Service

The email service (`utils/emailService.js`) supports:
- **Gmail SMTP**: Using app passwords
- **Custom SMTP**: Any SMTP server
- **Ethereal Email**: For development/testing (doesn't actually send)

Email templates are included for:
- Password reset emails
- Document share notifications

---

## Frontend Documentation

### Application Structure

The Flutter app follows a clean architecture pattern:

- **Pages**: UI screens (login, home, editor, settings)
- **Models**: Data models (Document, User)
- **Services**: Business logic and API calls
- **Widgets**: Reusable UI components
- **Utils**: Helper functions and utilities
- **Config**: Configuration files

### Key Pages

#### Login Page (`pages/login_page.dart`)
- Email/password login
- Google sign-in button
- Navigation to sign-up
- Forgot password link

#### Sign Up Page (`pages/sign_up_page.dart`)
- User registration form
- Email validation
- Password strength requirements
- Google sign-up option

#### Home Page (`pages/home_page.dart`)
- Document list view
- Create new document button
- Document search
- Document actions (edit, delete, share)

#### Editor Page (`pages/editor_page.dart`)
- Rich text editor
- Auto-save functionality
- Document title editing
- Share dialog integration

#### Settings Page (`pages/settings_page.dart`)
- User profile management
- Password change
- Account deletion
- Theme preferences

### API Configuration

The API configuration (`config/api_config.dart`) handles:
- Platform-specific URL selection
- Custom URL configuration
- Authentication token management
- Request headers

### State Management

The app uses **Provider** for state management:
- **ThemeProvider**: Dark/light theme switching
- **Document state**: Managed through API calls and local state

---

## API Reference

### Base URL

- **Development**: `http://localhost:5050/api`
- **Production**: Configure in environment variables

### Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

### Request/Response Format

All requests use JSON format:
```json
Content-Type: application/json
```

All responses are JSON:
```json
{
  "success": true,
  "data": {...},
  "error": "Error message"
}
```

### Endpoints

#### Authentication Endpoints

**POST /api/auth/signup**
```json
Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}

Response (201):
{
  "message": "User created successfully",
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "email": "john@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

**POST /api/auth/signin**
```json
Request:
{
  "email": "john@example.com",
  "password": "password123"
}

Response (200):
{
  "message": "Sign in successful",
  "token": "jwt_token_here",
  "user": {...}
}
```

**POST /api/auth/google**
```json
Request:
{
  "idToken": "google_id_token"
}

Response (200):
{
  "message": "Google authentication successful",
  "token": "jwt_token_here",
  "user": {...}
}
```

**GET /api/auth/me**
- **Auth**: Required
- **Response**: Current user object

#### Document Endpoints

**POST /api/documents/create**
```json
Request:
{
  "title": "My Document",
  "content": "Document content here"
}

Response (201):
{
  "id": 1,
  "userId": 1,
  "title": "My Document",
  "content": "Document content here",
  "createdAt": "2024-01-01T00:00:00Z",
  "lastModified": "2024-01-01T00:00:00Z"
}
```

**GET /api/documents**
- **Auth**: Required
- **Response**: Array of user's documents

**GET /api/documents/:id**
- **Auth**: Required
- **Response**: Single document object

**PUT /api/documents/save/:id**
```json
Request:
{
  "title": "Updated Title",
  "content": "Updated content",
  "shareToken": "optional_share_token"  // For shared documents
}

Response (200):
{
  "id": 1,
  "title": "Updated Title",
  "content": "Updated content",
  ...
}
```

**DELETE /api/documents/delete/:id**
- **Auth**: Required
- **Response**: `{"success": true}`

#### Sharing Endpoints

**POST /api/documents/share/:docId**
```json
Request:
{
  "permission": "edit",  // or "view"
  "expiresIn": 86400     // seconds (optional)
}

Response (200):
{
  "shareUrl": "http://localhost:8080/shared?token=...",
  "token": "share_token_here",
  "expiresAt": "2024-01-02T00:00:00Z",
  "permission": "edit"
}
```

**GET /api/documents/share/:token**
- **Auth**: Not required
- **Response**: Document with permission info

**POST /api/documents/share/:docId/email**
```json
Request:
{
  "email": "recipient@example.com",
  "permission": "edit"
}

Response (200):
{
  "success": true,
  "message": "Document shared with recipient@example.com",
  "shareUrl": "..."
}
```

---

## Database Schema

### User Model

```prisma
model User {
  id                Int        @id @default(autoincrement())
  email             String     @unique
  password          String?
  uid               String?    @unique  // Google user ID
  name              String?
  resetToken        String?
  resetTokenExpires DateTime?
  createdAt         DateTime   @default(now())
  updatedAt         DateTime   @updatedAt
  documents         Document[]
}
```

### Document Model

```prisma
model Document {
  id           Int         @id @default(autoincrement())
  userId       Int
  title        String
  content      String?
  createdAt    DateTime    @default(now())
  lastModified DateTime    @updatedAt
  user         User        @relation(fields: [userId], references: [id])
  ShareLink    ShareLink[]
}
```

### ShareLink Model

```prisma
model ShareLink {
  id         Int       @id @default(autoincrement())
  token      String    @unique
  permission String    // "view" or "edit"
  expiresAt  DateTime?
  documentId Int
  document   Document  @relation(fields: [documentId], references: [id])
}
```

### Relationships

- **User → Documents**: One-to-many
- **Document → ShareLinks**: One-to-many
- **Document → User**: Many-to-one

---

## Authentication

### Email/Password Authentication

1. User signs up with email and password
2. Password is hashed using bcrypt (10 rounds)
3. JWT token is generated and returned
4. Client stores token securely
5. Token is sent in `Authorization` header for protected routes

### Google OAuth Authentication

1. Frontend obtains Google ID token or access token
2. Token is sent to `/api/auth/google` or `/api/auth/google-access`
3. Backend verifies token with Google
4. User is created/updated in database
5. JWT token is generated and returned

### JWT Token

- **Expiration**: 7 days
- **Payload**: `{ id: userId, email: userEmail }`
- **Secret**: Configured in `JWT_SECRET` environment variable

### Password Reset Flow

1. User requests password reset via `/api/auth/forgot-password`
2. Reset token is generated and stored in database
3. Email is sent with reset link (if email is configured)
4. User clicks link and enters new password
5. Token is validated and password is updated via `/api/auth/reset-password`

---

## Document Sharing

### Share Links

Documents can be shared via:
- **Share Links**: Generate a unique token-based URL
- **Email Sharing**: Send share link directly via email

### Permissions

- **View**: Read-only access to document
- **Edit**: Full edit access to document

### Share Token Usage

When editing a shared document:
1. Include `shareToken` in the request body when saving
2. Backend validates token and permission
3. Document is updated if permission allows

### Expiration

Share links can have optional expiration dates:
- Set `expiresIn` (in seconds) when creating share link
- Links automatically expire after the specified time

---

## Email Configuration

### Gmail Setup

1. Enable 2-factor authentication on your Gmail account
2. Generate an App Password:
   - Go to Google Account → Security → App passwords
   - Create a new app password for "Mail"
3. Add to `.env`:
   ```env
   EMAIL_SERVICE=gmail
   EMAIL_USER=your-email@gmail.com
   EMAIL_PASSWORD=your-16-char-app-password
   ```

### Custom SMTP Setup

```env
EMAIL_HOST=smtp.example.com
EMAIL_PORT=587
EMAIL_SECURE=false
EMAIL_USER=your-email@example.com
EMAIL_PASSWORD=your-password
EMAIL_FROM=noreply@bockdocs.com
```

### Development Mode

If email is not configured, the system will:
- Log reset tokens to console (development only)
- Continue functioning without sending emails
- Return success responses (to prevent email enumeration)

---

## Mobile Development

### iOS Setup

#### Simulator
- Can use `localhost:5050` directly
- No additional configuration needed

#### Physical Device
1. Find your Mac's IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
2. Update `api_config.dart`:
   ```dart
   static const String _defaultMobileDevUrl = 'http://192.168.1.100:5050/api';
   ```
3. Ensure device and Mac are on the same Wi-Fi network
4. Configure code signing (see `IOS_CODE_SIGNING_SETUP.md`)

### Android Setup

#### Emulator
- Use `10.0.2.2:5050` instead of `localhost`
- Or use your computer's IP address

#### Physical Device
1. Find your computer's IP address
2. Update `api_config.dart` with the IP
3. Ensure device and computer are on the same network
4. Configure network security (see `MOBILE_SETUP.md`)

### Network Configuration

The backend server listens on `0.0.0.0` to accept connections from:
- Localhost (web, simulators)
- Local network IPs (physical devices)
- All network interfaces

---

## Deployment

### Backend Deployment

#### Environment Variables
Set all required environment variables in your hosting platform:
- `DATABASE_URL`
- `JWT_SECRET`
- `GOOGLE_CLIENT_ID`
- Email configuration
- `FRONTEND_BASE_URL`

#### Database Migrations
```bash
npx prisma migrate deploy
```

#### Production Considerations
- Use strong `JWT_SECRET`
- Enable HTTPS
- Restrict CORS origins
- Use environment-specific database
- Set up proper logging
- Configure rate limiting

### Frontend Deployment

#### Web
```bash
flutter build web
# Deploy the build/web directory
```

#### iOS
```bash
flutter build ios --release
# Archive and upload to App Store Connect
```

#### Android
```bash
flutter build apk --release
# Or
flutter build appbundle --release
# Upload to Google Play Console
```

---

## Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Find process using port 5050
lsof -i :5050
# Kill the process
kill -9 <PID>
```

**Database connection errors:**
- Verify `DATABASE_URL` in `.env`
- Check database credentials
- Ensure database is accessible
- Run `npx prisma generate` after schema changes

**JWT errors:**
- Verify `JWT_SECRET` is set
- Ensure token is sent in correct format: `Bearer <token>`
- Check token expiration

### Frontend Issues

**Cannot connect to backend:**
- Verify backend is running
- Check API URL in `api_config.dart`
- For mobile: ensure correct IP address
- Check CORS configuration
- Verify network connectivity

**Google Sign-In not working:**
- Verify `GOOGLE_CLIENT_ID` is set
- Check OAuth redirect URIs in Google Cloud Console
- Ensure correct port configuration (see `ADD_PORT_5000.txt`)

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

### Email Issues

**Emails not sending:**
- Verify email credentials in `.env`
- Check SMTP settings
- For Gmail: ensure App Password is used (not regular password)
- Check firewall/network restrictions
- Review email service logs

### Mobile-Specific Issues

**iOS Simulator connection:**
- Use `localhost:5050` directly
- No additional configuration needed

**Physical iOS device:**
- Use Mac's IP address, not `localhost`
- Ensure same Wi-Fi network
- Check firewall settings

**Android Emulator:**
- Use `10.0.2.2:5050` for localhost
- Or use computer's IP address

---

## Additional Resources

### Setup Guides

- `MOBILE_QUICK_START.md` - Quick mobile setup
- `MOBILE_SETUP.md` - Detailed mobile configuration
- `IOS_CODE_SIGNING_SETUP.md` - iOS code signing guide
- `IOS_SIMULATOR_VS_WEB.md` - Platform differences
- `RUN_ON_SIMULATOR_WITH_BACKEND.md` - Simulator setup
- `ADD_PORT_5000.txt` - Google OAuth port configuration

### Backend Documentation

- `backend/Readme.md` - Backend-specific documentation

### API Testing

Test the backend with curl:
```bash
# Health check
curl http://localhost:5050/health

# Sign up
curl -X POST http://localhost:5050/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","name":"Test User"}'

# Sign in
curl -X POST http://localhost:5050/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

---

## License

MIT License - See LICENSE file for details

---

## Support

For issues, questions, or contributions:
1. Check the troubleshooting section
2. Review existing documentation files
3. Check GitHub issues (if applicable)
4. Contact the development team

---

## Version History

- **v1.0.0** - Initial release
  - User authentication (email/password + Google OAuth)
  - Document CRUD operations
  - Document sharing (links + email)
  - Cross-platform support
  - Password recovery
  - Profile management

---



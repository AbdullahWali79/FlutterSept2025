# Doctor Patient Records

A Flutter mobile application for managing doctor-patient records with Google Drive integration.

## Features

- **Patient Management**: Add, view, edit, and delete patient records
- **Google Authentication**: Secure sign-in with Google accounts
- **Local Database**: SQLite database for offline data storage
- **Google Drive Integration**: Backup and sync patient records to Google Drive
- **File Management**: Upload and manage patient documents and images
- **Modern UI**: Clean, doctor-friendly interface with blue/white theme

## Dependencies

- `sqflite: ^2.3.0` - SQLite database
- `path_provider: ^2.0.15` - Local storage paths
- `google_sign_in: ^6.1.4` - Google authentication
- `googleapis: any` - Google APIs
- `googleapis_auth: any` - Google authentication
- `file_picker: ^5.5.0` - File selection
- `image_picker: ^1.0.5` - Camera/gallery images
- `provider: ^6.0.5` - State management

## Permissions

### Android
- Camera access for taking photos
- Storage access for file management
- Internet access for Google APIs

### iOS
- Camera usage for document photos
- Photo library access for image selection
- Internet access for Google APIs

## Project Structure

```
lib/
├── models/           # Data models
├── services/         # Business logic and API services
├── screens/          # UI screens
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Google Sign-In credentials
4. Run `flutter run` to start the app

## Google Sign-In Setup

1. Create a project in the Google Cloud Console
2. Enable the Google Sign-In API
3. Create OAuth 2.0 credentials
4. Add the credentials to your app configuration

## License

This project is licensed under the MIT License.
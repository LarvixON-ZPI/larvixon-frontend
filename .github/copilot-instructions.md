# Larvixon Frontend

Larvixon Frontend is a Flutter cross-platform mobile and web application with authentication features, built with BLoC state management and internationalization support.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Prerequisites and Setup
- Install Flutter SDK version **3.35.1** exactly - other versions may cause issues:
  ```bash
  # Method 1: Direct download (may fail due to network restrictions)
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.1-stable.tar.xz
  tar xf flutter_linux_3.35.1-stable.tar.xz -C /usr/local
  export PATH="/usr/local/flutter/bin:$PATH"
  flutter --version
  ```
  ```bash
  # Method 2: Git clone (alternative if direct download fails)
  cd /tmp && git clone https://github.com/flutter/flutter.git -b 3.35.1 --depth 1
  export PATH="/tmp/flutter/bin:$PATH"
  flutter --version
  ```
  ```bash
  # Method 3: Snap install (may not get exact version)
  sudo snap install flutter --classic
  # Note: May install different version than required
  ```
- Ensure Dart 3.9.0 is available (comes with Flutter 3.35.1)
- **CRITICAL**: Have the Larvixon backend API running at http://127.0.0.1:8000/api before testing the app

### Essential Build Commands
Bootstrap and build the repository:
```bash
flutter pub get
```
- Takes 1-3 minutes. NEVER CANCEL. Set timeout to 5+ minutes.

Build for web (most common deployment):
```bash
flutter build web --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- Takes 3-8 minutes. NEVER CANCEL. Set timeout to 15+ minutes.

Run the development server:
```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- First run takes 5-10 minutes. NEVER CANCEL. Set timeout to 15+ minutes.
- Subsequent runs take 1-3 minutes.

### Platform-Specific Builds
Build for Android:
```bash
flutter build android --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- Takes 5-15 minutes. NEVER CANCEL. Set timeout to 20+ minutes.

Build for iOS (requires macOS):
```bash
flutter build ios --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- Takes 10-20 minutes. NEVER CANCEL. Set timeout to 30+ minutes.

Build for Windows:
```bash
flutter build windows --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- Takes 8-15 minutes. NEVER CANCEL. Set timeout to 20+ minutes.

Build for Linux:
```bash
flutter build linux --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
- Takes 8-15 minutes. NEVER CANCEL. Set timeout to 20+ minutes.

### Testing and Quality Assurance
Run static analysis:
```bash
flutter analyze
```
- Takes 30 seconds - 2 minutes.

Format code (must run before CI):
```bash
dart format .
```
- Takes 10-30 seconds.

Currently no unit tests exist. If tests are added, run with:
```bash
flutter test
```

### Docker Build (Alternative)
Build web version using Docker:
```bash
docker build . -t larvixon-frontend-web
```
- Takes 10-20 minutes. NEVER CANCEL. Set timeout to 30+ minutes.

## Validation Requirements

### Manual Testing Scenarios
**CRITICAL**: Always test these scenarios after making changes:
1. **Authentication Flow**: 
   - Navigate to login page
   - Register a new user account
   - Log in with created credentials
   - Verify authentication state persists
2. **API Integration**: 
   - Ensure API calls work with backend
   - Test API_BASE_URL configuration
   - Verify error handling for network issues
3. **Multi-Platform Testing**:
   - Web: Test in browser after `flutter run -d web-server`
   - Mobile: Test on emulator/device with `flutter run`

### Backend Dependency
- **ALWAYS** ensure the Larvixon backend is running at http://127.0.0.1:8000/api
- App will not function properly without the backend API
- Use default API_BASE_URL unless specifically overridden

## Development Workflow

### Configuration Management
The app uses compile-time configuration via --dart-define:
- `API_BASE_URL`: Backend API URL (defaults to http://127.0.0.1:8000/api)
- Always pass --dart-define=API_BASE_URL=... for builds and runs

### VS Code Integration
Use .vscode/launch.json for consistent development:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter run with API_BASE_URL",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--dart-define=API_BASE_URL=http://127.0.0.1:8000/api"]
    }
  ]
}
```

### Code Quality Requirements
Before committing changes:
1. Run `dart format .`
2. Run `flutter analyze` and fix all issues
3. Test authentication flow manually
4. Verify app builds successfully for target platforms

## Key Project Areas

### Repository Structure
```
lib/
├── main.dart                    # App entry point
├── core/                        # Core functionality
│   ├── api_client.dart         # HTTP client with dio
│   ├── app_router.dart         # GoRouter configuration
│   ├── auth_interceptor.dart   # Auth token handling
│   ├── token_storage.dart      # Secure token storage
│   └── constants/              # API endpoints and config
├── src/
│   ├── authentication/         # Auth module (BLoC pattern)
│   │   ├── bloc/              # Auth BLoC state management
│   │   ├── presentation/      # Auth UI and forms
│   │   ├── auth_repository.dart
│   │   └── auth_datasource.dart
│   └── home/                   # Home module
├── l10n/                       # Internationalization
└── extensions/                 # Dart extensions
```

### Important Files to Check After Changes
- Always check `lib/core/api_client.dart` after modifying API calls
- Always check `lib/core/constants/api_base.dart` after changing endpoints
- Always check `lib/src/authentication/` files after auth changes
- Review `pubspec.yaml` after adding dependencies

### Dependencies
Key packages used:
- `flutter_bloc`: State management
- `dio`: HTTP client
- `flutter_secure_storage`: Secure storage
- `go_router`: Navigation
- `equatable`: Value equality
- `flutter_localizations`: Internationalization

### Build Artifacts
- Web builds output to: `build/web/`
- Android builds output to: `build/app/outputs/`
- Generated files are in `.dart_tool/` and `build/` - never commit these

## Troubleshooting

### Common Issues
- **"Target of URI doesn't exist"**: Run `flutter pub get` first
- **Build fails**: Ensure Flutter 3.35.1 is installed exactly
- **API connection issues**: Verify backend is running and accessible
- **Certificate errors**: Check API_BASE_URL configuration

### Network Requirements
- Internet access required for initial `flutter pub get`
- Backend API must be accessible at configured URL
- Docker builds may fail in restricted network environments
- Flutter SDK download may fail due to certificate issues - use git clone method as alternative

### Known Limitations
- Flutter SDK download from official source may be blocked by network security policies
- Docker builds may encounter SSL certificate issues
- When network restrictions apply, use the git clone installation method
- Some cloud/CI environments may require proxy configuration for Flutter downloads

## Time Expectations
- **NEVER CANCEL** build commands - they may take 15+ minutes
- Initial setup: 5-10 minutes
- Code changes and hot reload: 1-5 seconds
- Full rebuild: 3-15 minutes depending on platform
- Docker build: 10-20 minutes
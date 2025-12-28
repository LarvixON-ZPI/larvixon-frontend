<!-- markdownlint-disable MD041 -->

[![Flutter CI](https://github.com/LarvixON-ZPI/larvixon-frontend/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/LarvixON-ZPI/larvixon-frontend/actions/workflows/flutter_ci.yml)

# Larvixon App

A Flutter powered app for the LarvixON project.

## Requirements

- Flutter **3.35.1** // Used for development, other versions may work but are not tested
- Dart **3.9.0**

If your Flutter version is below **3.35.1** and you're encountering issues, consider following

```bash
cd /path/to/flutter
git checkout 3.35.1
```

or simply upgrade to the latest stable version.

```bash
flutter upgrade 
```

## How to run

To run the Larvixon App, follow these steps:

1. Make sure you have the correct Flutter version installed on your machine.
2. Run the Larvixon backend.
3. Clone the repository to your local machine.
4. Navigate to the project directory.
5. Run the following commands:

```bash
# Unity submodule
git submodule update --init --recursive

# Flutter dependencies
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api --web-port=3000
```

If you don't specify the API_BASE_URL, it will fallback to default value *<http://127.0.0.1:8000/api>*

### Run with mock backend

To run the app with a mock backend, use the following command:

```bash
flutter run -t lib/main_dev.dart --web-port=3000
```

### Running with VS Code (launch.json)

If you're using VS Code, you can preconfigure `--dart-define` values in `.vscode/launch.json`.  
Here’s an example configuration:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter run with API_BASE_URL",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=API_BASE_URL=http://127.0.0.1:8000/api",
        "--web-port=3000"
      ]
    }
  ]
}
```

### Generate translations

To generate localization files, run the following command:

```bash
flutter gen-l10n
```

## Development

### Creating new releases

Release builds are automatically created via GitHub Actions when a version tag (e.g., `v1.0.0`) is pushed. The workflow builds for:

- **Android**
- **Windows**
- **Linux**
- **Web** (deployed to GitHub Pages)

To create a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Or trigger manually via the GitHub Actions "workflow_dispatch" with a version tag input.

#### Creating offline releases

To create an "offline" release (using mock backend), use a tag pattern like `v1.0.0-offline`.

```bash
git tag v1.0.0-offline
git push origin v1.0.0-offline
```

### 🚀 Creating new features

We provide automated scripts to scaffold new features with proper Clean Architecture structure:

#### Create a new feature

```bash
# Create a complete feature structure
dart scripts/new_feature.dart "Feature Name"

# This creates:
# - lib/src/feature_name/ with full Clean Architecture folders
# - test/src/feature_name/ for testing
# - README.md with detailed guidance
# - Template files (repository interface, implementation, page)
```

#### Clean up feature folders

```bash
# List all features
dart scripts/cleanup_features.dart

# Preview cleanup for specific feature
dart scripts/cleanup_features.dart analysis --dry-run

# Clean empty directories and files from a feature
dart scripts/cleanup_features.dart feature_name

# Interactive cleanup (asks for confirmation)
dart scripts/cleanup_features.dart feature_name --interactive
```

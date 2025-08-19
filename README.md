# Larvixon App 


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

# How to run

To run the Larvixon App, follow these steps:

1. Make sure you have the correct Flutter version installed on your machine.
2. Run the Larvixon backend.
3. Clone the repository to your local machine.
4. Navigate to the project directory.
5. Run the following commands:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

If you don't specify the API_BASE_URL, it will fallback to default value *http://127.0.0.1:8000/api*


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
        "--dart-define=API_BASE_URL=http://127.0.0.1:8000/api"
      ]
    }
  ]
}
=======
5. Make sure the backend is listening on the correct URL, if needed change it in `lib/core/constants/api_base.dart` // Will make swapping environments easier soon
6. Run the following commands:

```bash
flutter pub get
flutter run -d windows (linux) # other platforms not tested yet
```

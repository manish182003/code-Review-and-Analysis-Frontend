# Code Review and Analysis Frontend

![Flutter](https://img.shields.io/badge/Flutter-v3.7-blue?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-v3.7-green?logo=dart) ![GetX](https://img.shields.io/badge/GetX-v4-orange) ![GoRouter](https://img.shields.io/badge/GoRouter-v15-purple) ![Dio](https://img.shields.io/badge/Dio-v5-red)

Welcome to the frontend of the **Code Review and Analysis** project! This Flutter mobile app provides a seamless and intuitive interface for AI-driven code review, documentation generation, and code complexity analysis. With features like JWT-based authentication, auto-logout, file uploads, markdown rendering, and speech-to-text, it delivers a robust user experience for developers. Built with modern Flutter practices, it leverages GetX for state management, Go Router for navigation, and Dio for network requests.

## :rocket: Features

- **Code Review**: Upload code files for AI-powered review with actionable feedback.
- **Documentation Generation**: Generate and view markdown-based documentation for code.
- **Code Complexity Analysis**: Analyze code complexity with AI-driven insights.
- **Authentication**: Secure JWT-based login/register with guest access (3 free requests).
- **Auto Logout**: Automatically logs out after 8 hours of session expiry.
- **File Uploads**: Pick and upload single code files using `file_picker` and `dio`.
- **Markdown Rendering**: Display AI-generated markdown with `flutter_markdown_plus`.
- **Speech-to-Text**: Convert voice input to text for queries using `speech_to_text`.
- **Responsive UI**: Adaptive layouts with `sizer` for various screen sizes.
- **Navigation**: Smooth and scalable routing with `go_router`.
- **State Management**: Efficient and reactive with `getx`.
- **Animations**: Engaging Lottie animations for mic and loading states.
- **Error Handling**: Graceful handling of network, file, and auth errors.
- **Secure Storage**: JWT tokens stored securely with `flutter_secure_storage`.

## :wrench: Tech Stack

- **Framework**: Flutter (v3.7.2+)
- **Language**: Dart
- **HTTP Client**: Dio (for API requests)
- **State Management**: GetX (reactive state management)
- **Navigation**: Go Router (declarative routing)
- **Markdown Rendering**: Flutter Markdown Plus
- **File Picker**: File Picker (for code file uploads)
- **Speech-to-Text**: Speech to Text (voice input)
- **Secure Storage**: Flutter Secure Storage (for JWT tokens)
- **UI/UX**:
  - Google Fonts (consistent typography)
  - Sizer (responsive layouts)
  - Lottie (animations for mic and loading)
  - Emoji Picker Flutter (emoji support in text inputs)
- **Utilities**:
  - Logger (debug logging)
  - Flutter Dotenv (environment variables)
  - Flutter Toast (user notifications)
  - Permission Handler (file and mic permissions)
  - Device Info Plus (device-specific info)
  - URL Launcher (external links)

## :open_file_folder: Project Structure

```
├── lib/
│   ├── main.dart          # App entry point
│   ├── routes/
│   │   ├── app_routes.dart # Route definitions
│   │   ├── router.dart     # Go Router setup
│   ├── controllers/
│   │   ├── auth_controller.dart # Auth state management
│   │   ├── code_controller.dart # Code review/doc/complexity logic
│   ├── models/
│   │   ├── user_model.dart # User data model
│   │   ├── code_response.dart # API response models
│   ├── services/
│   │   ├── api_service.dart # Dio API client
│   │   ├── storage_service.dart # Secure storage
│   ├── views/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── code_review_screen.dart
│   │   ├── docs_screen.dart
│   │   ├── complexity_screen.dart
│   ├── widgets/
│   │   ├── custom_button.dart # Reusable UI components
│   │   ├── markdown_viewer.dart # Markdown renderer
│   │   ├── file_picker_widget.dart # File upload UI
├── assets/
│   ├── icons/             # Icon assets
│   ├── animations/        # Lottie animations (e.g., mic_animation.json)
├── .env                   # Environment variables
├── pubspec.yaml           # Dependencies and config
```

## :gear: Prerequisites

- **Flutter SDK**: v3.7.2 or higher
- **Dart SDK**: Included with Flutter
- **IDE/Emulator**: Android Studio (Android) or Xcode (iOS)
- **Backend Server**: Running backend API (see backend README)
- **Environment Variables**: Configured in `.env`
- **Permissions**: Storage and microphone access for file uploads and speech-to-text

## 🔧 Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd code-review-frontend
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Environment Variables**:
   Create a `.env` file in the root directory:
   ```
   API_BASE_URL=http://localhost:5000
   ```
   Replace `localhost:5000` with your backend API URL.

4. **Configure Permissions**:
   - For Android, ensure `AndroidManifest.xml` includes:
     ```xml
     <uses-permission android:name="android.permission.INTERNET"/>
     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
     <uses-permission android:name="android.permission.RECORD_AUDIO"/>
     ```
   - For iOS, update `Info.plist`:
     ```xml
     <key>NSMicrophoneUsageDescription</key>
     <string>Allow microphone access for speech-to-text.</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>Allow access to files for uploads.</string>
     ```

5. **Run the App**:
   ```bash
   flutter run
   ```
   Ensure a device or emulator is connected (e.g., Android emulator, iOS simulator).

## 📱 App Workflow

1. **Authentication**:
   - **Login/Register**: Users sign in or register with email/password.
   - **Guest Mode**: Access 3 free AI requests without login.
   - **Auto Logout**: Session expires after 8 hours (JWT token expiry).

2. **Code Submission**:
   - Select a code file using the file picker.
   - Upload via `dio` to the backend for review, documentation, or complexity analysis.
   - View results in a markdown viewer.

3. **Speech-to-Text**:
   - Tap the mic icon to record voice queries.
   - Converted text is used for API requests or inputs.

4. **Markdown Rendering**:
   - AI-generated markdown (e.g., documentation, code reviews) is displayed with `flutter_markdown_plus`.
   - Supports code blocks, tables, and links.

5. **Navigation**:
   - `go_router` handles routes like `/login`, `/home`, `/code-review`, `/docs`, and `/complexity`.
   - Deep linking and nested routes for seamless navigation.

## 🎨 UI/UX Details

- **Responsive Layouts**: Uses `sizer` to adapt to different screen sizes (mobile, tablet).
- **Typography**: Google Fonts (e.g., Roboto) for a clean, professional look.
- **Animations**:
  - Lottie animation for microphone during speech-to-text (`mic_animation.json`).
  - Loading indicators for API calls.
- **Custom Widgets**:
  - Reusable buttons, text inputs, and markdown viewers.
  - File picker UI with drag-and-drop support (Android/iOS).
- **Feedback**:
  - `flutter_toast` for success/error notifications.
  - Emoji picker for user feedback in text fields.

## 🔐 Security Features

- **JWT Storage**: Tokens stored in `flutter_secure_storage` to prevent unauthorized access.
- **Session Management**: Auto-logout after 8 hours, validated via JWT expiration.
- **Permissions**: Runtime checks for storage and microphone using `permission_handler`.
- **Network Security**: HTTPS API calls with `dio` and error handling for connectivity issues.

## 🐛 Error Handling

- **Network Errors**: Handles timeouts, no internet, and server errors with user-friendly messages.
- **File Errors**: Validates file size, format, and existence before upload.
- **Auth Errors**: Redirects to login on token expiry or invalid credentials.
- **Speech-to-Text Errors**: Notifies users if microphone access is denied.
- **Logging**: Uses `logger` for debugging in development mode.

## 🧪 Testing

- **Unit Tests**:
  - Test API services (`api_service.dart`) using mock Dio responses.
  - Test models (`user_model.dart`, `code_response.dart`) for serialization.
- **Widget Tests**:
  - Test custom widgets (`custom_button.dart`, `markdown_viewer.dart`) for rendering.
- **Integration Tests**:
  - Test navigation flows with `go_router`.
  - Test file uploads and speech-to-text functionality.
- **Run Tests**:
  ```bash
  flutter test
  ```

## 🚀 Performance Optimizations

- **GetX**: Reactive state management minimizes rebuilds.
- **Dio**: Configured with caching and interceptors for efficient API calls.
- **Lazy Loading**: Routes and widgets loaded on-demand with `go_router`.
- **Asset Management**: Optimized icons and Lottie animations for faster loading.

## 📝 Future Improvements

- Add offline mode for viewing cached results.
- Support multiple file uploads.
- Implement dark/light theme toggling.
- Add unit tests for speech-to-text and file picker.
- Integrate real-time code preview in markdown viewer.

## :page_facing_up: License

Licensed under the [ISC License](LICENSE).

## :envelope: Contact

For questions or feedback, open an issue in the repository or email [your-email@example.com](mailto:your-email@example.com).

## :star: Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit changes (`git commit -m "Add YourFeature"`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

---

Happy coding! :rocket:
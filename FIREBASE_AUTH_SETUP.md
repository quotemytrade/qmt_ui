# Firebase Authentication Setup Guide

This guide walks through the Firebase authentication setup for Gmail, Apple, and Email login options.

## Files Created/Modified

### New Files:

1. **lib/core/services/auth_service.dart** - Firebase authentication service
2. **lib/core/providers/auth_provider.dart** - Riverpod providers for auth state
3. **lib/widgets/auth/login_dialog.dart** - Main login dialog UI
4. **lib/widgets/auth/email_login_form.dart** - Email login/signup form
5. **lib/core/config/firebase_config.dart** - Firebase initialization

### Modified Files:

1. **lib/main.dart** - Added Firebase initialization
2. **lib/widgets/common/app_bar/custom_app_bar.dart** - Integrated login dialog and user profile

## Setup Steps

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Enable the following authentication methods:
   - **Email/Password**: Authentication → Sign-in method → Email/Password
   - **Google**: Authentication → Sign-in method → Google
   - **Apple**: Authentication → Sign-in method → Apple

### 2. Android Setup

1. Add your app in Firebase Console:
   - Go to Project Settings → Add App → Android
   - Enter your package name (usually from `AndroidManifest.xml`)
   - Download `google-services.json`
   - Place it in `android/app/`

2. Update `android/build.gradle.kts`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

3. Update `android/app/build.gradle.kts`:

```gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services'
}
```

4. Configure Google Sign-In SHA-1:
   - Get your SHA-1: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
   - Add to Firebase Console → Project Settings → Your App

### 3. iOS Setup

1. Add your app in Firebase Console:
   - Go to Project Settings → Add App → iOS
   - Enter your bundle ID (from Xcode)
   - Download `GoogleService-Info.plist`
   - Open `ios/Runner.xcworkspace` in Xcode
   - Add the plist file using Xcode (File → Add Files)

2. Configure Apple Sign-In:
   - Xcode: Runner → Signing & Capabilities → + Capability → Sign In with Apple

3. Update `ios/Podfile` to include Firebase pods (usually automatic)

### 4. Web Setup (if needed)

1. Add your web app in Firebase Console:
   - Go to Project Settings → Add App → Web
   - Copy the configuration

2. Update `web/index.html`:

```html
<!-- Firebase SDK -->
<script src="https://www.gstatic.com/firebasejs/10.x.x/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.x.x/firebase-auth.js"></script>
```

### 5. Environment Variables

Add to your `.env` file:

```
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

## Features Implemented

### Authentication Methods:

- ✅ Google Sign-In
- ✅ Apple Sign-In
- ✅ Email/Password Sign-In
- ✅ Email/Password Sign-Up
- ✅ Password Reset
- ✅ Sign Out

### UI Components:

- Login Dialog with multiple auth options
- Email login/signup form with validation
- User profile display in app bar
- Error handling and user feedback
- Loading states

## Usage

### Show Login Dialog:

```dart
showDialog(
  context: context,
  builder: (context) => const LoginDialog(),
);
```

### Access Current User:

```dart
final currentUser = ref.watch(currentUserProvider);
```

### Sign Out:

```dart
await ref.read(signOutProvider(null).future);
```

## Important Notes

1. **iOS Apple Sign-In**: Only works on physical iOS 13+ devices
2. **Web**: Requires Firebase Hosting or custom domain setup
3. **Email Validation**: Currently allows any email format - customize as needed
4. **Security**: Never commit `google-services.json` or `GoogleService-Info.plist`
5. **Testing**: Use Firebase Emulator Suite for local testing

## Troubleshooting

### Google Sign-In Issues:

- Verify SHA-1 is added to Firebase
- Check OAuth 2.0 consent screen is configured
- Ensure `google-services.json` is in correct location

### Apple Sign-In Issues:

- Verify Apple Sign-In capability is enabled in Xcode
- Check bundle ID matches Firebase configuration
- Ensure team ID is set in iOS project

### Firebase Initialization:

- Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before Firebase init
- Check Firebase configuration files are in correct locations

## Next Steps

1. Run `flutter pub get` to ensure all dependencies are installed
2. Generate Firebase configuration files for each platform
3. Test authentication on desired platforms
4. Customize UI styling to match your theme
5. Add additional user profile fields as needed

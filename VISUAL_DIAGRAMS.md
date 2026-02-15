# Firebase Authentication - Visual Diagrams & Flowcharts

## 1. Complete System Diagram

```
┌──────────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                              │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─ CustomAppBar ─────────────────────────────────────────────┐   │
│  │ "QuoteMyTrade"              [Log In] or [Profile ▼]       │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                      │
│           ▲                                   │                    │
│           │                                   │                    │
│           │ Shows Login                       │ Opens                │
│           │                                   ▼                    │
│  ┌────────┴───────────────────────────────────────────────────┐   │
│  │          LoginDialog                                        │   │
│  │  ┌─────────────────────────────────────────────────────┐  │   │
│  │  │ Welcome Back                                        │  │   │
│  │  │                                                     │  │   │
│  │  │ [ 🔍 Continue with Google ]  ─┐                    │  │   │
│  │  │ [ 🍎 Continue with Apple  ]  ─┼─ Calls Handlers    │  │   │
│  │  │ [ ✉️  Continue with Email  ]  ─┤                    │  │   │
│  │  │                                 │                   │  │   │
│  │  │        ▼ (on Email click)       │                   │  │   │
│  │  │ ┌───────────────────────────┐   │                   │  │   │
│  │  │ │  EmailLoginForm          │   │                   │  │   │
│  │  │ │ Email: [ ]               │   │                   │  │   │
│  │  │ │ Password: [ ]            │   │                   │  │   │
│  │  │ │ [ Sign In ]              │   │                   │  │   │
│  │  │ └───────────────────────────┘   │                   │  │   │
│  │  └─────────────────────────────────┘                   │  │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
                              │                              ▲
                              │ Triggers                     │
                              ▼ Handlers                     │ Auth State
                                                        Changes
┌──────────────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT (Riverpod)                       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  authServiceProvider                                               │
│       │                                                            │
│       ├─→ signInWithGoogleProvider                               │
│       │          │                                               │
│       │          └─→ authService.signInWithGoogle()             │
│       │                                                          │
│       ├─→ signInWithAppleProvider                               │
│       │          │                                              │
│       │          └─→ authService.signInWithApple()              │
│       │                                                         │
│       ├─→ signInWithEmailProvider                              │
│       │          │                                             │
│       │          └─→ authService.signInWithEmail()             │
│       │                                                        │
│       ├─→ signUpWithEmailProvider                             │
│       │          │                                            │
│       │          └─→ authService.signUpWithEmail()            │
│       │                                                       │
│       ├─→ signOutProvider                                    │
│       │          │                                           │
│       │          └─→ authService.signOut()                   │
│       │                                                      │
│       └─→ currentUserProvider ◄─────────────────────────────┐
│                │                                             │
│                └─ Watches authStateChanges Stream           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │                                ▲
                              │ Uses                           │
                              ▼                                │
┌──────────────────────────────────────────────────────────────────────┐
│                   SERVICE LAYER (AuthService)                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─ FirebaseAuth Instance ─────────────────────────────────────┐  │
│  │ • currentUser                                              │  │
│  │ • authStateChanges (Stream)                                │  │
│  │ • signInWithCredential(credential)                         │  │
│  │ • createUserWithEmailAndPassword()                         │  │
│  │ • signInWithEmailAndPassword()                             │  │
│  │ • signOut()                                                │  │
│  │ • sendPasswordResetEmail()                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌─ GoogleSignIn Instance ──────────────────────────────────────┐  │
│  │ • signIn()                                                 │  │
│  │ • signOut()                                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌─ SignInWithApple ────────────────────────────────────────────┐  │
│  │ • getAppleIDCredential()                                   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
                              │
                              │ Communicates
                              ▼
┌──────────────────────────────────────────────────────────────────────┐
│                    FIREBASE BACKEND                                  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Firebase Auth Service                                             │
│  ├─ Google OAuth Provider                                          │
│  ├─ Apple OAuth Provider                                           │
│  ├─ Email/Password Provider                                        │
│  └─ User Session Manager                                           │
│                                                                      │
│  Cloud Storage                                                      │
│  ├─ User Credentials (Encrypted)                                   │
│  ├─ User Sessions                                                  │
│  └─ Auth Tokens                                                    │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 2. Authentication Method Comparison

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     AUTHENTICATION METHODS                              │
├──────────────────┬──────────────────┬──────────────────────────────────┤
│  GOOGLE SIGN-IN  │  APPLE SIGN-IN   │    EMAIL/PASSWORD                │
├──────────────────┼──────────────────┼──────────────────────────────────┤
│                  │                  │                                  │
│ User Flow:       │ User Flow:       │ User Flow:                       │
│ 1. Click button  │ 1. Click button  │ 1. Click button                  │
│ 2. Enter Google  │ 2. Biometric or  │ 2. Enter email                   │
│    credentials   │    password      │ 3. Enter password                │
│ 3. Grant perms   │ 3. Confirm       │ 4. Click Sign In                 │
│ 4. Logged in ✓   │ 4. Logged in ✓   │ 5. Logged in ✓                   │
│                  │                  │                                  │
│ Security:        │ Security:        │ Security:                        │
│ • OAuth 2.0      │ • OAuth 2.0      │ • Firebase managed               │
│ • No password    │ • Biometric auth │ • Email verification (optional)  │
│ • Auto verified  │ • Auto verified  │ • Password reset option          │
│                  │                  │                                  │
│ Platforms:       │ Platforms:       │ Platforms:                       │
│ ✅ Android       │ ✅ iOS 13+       │ ✅ Android                       │
│ ✅ iOS           │ ✅ macOS 10.15+  │ ✅ iOS                           │
│ ✅ Web           │ ⚠️ Web (limited) │ ✅ Web                           │
│                  │                  │                                  │
│ Data Collected:  │ Data Collected:  │ Data Collected:                  │
│ • Email          │ • Email          │ • Email                          │
│ • Name (opt)     │ • Name (opt)     │ • Password (hashed)              │
│ • Photo (opt)    │ • Photo (opt)    │ • Display name (on signup)       │
│                  │                  │                                  │
└──────────────────┴──────────────────┴──────────────────────────────────┘
```

---

## 3. User State Lifecycle

```
┌────────────────────────────────────────────────────────────────┐
│                  USER STATE LIFECYCLE                          │
└────────────────────────────────────────────────────────────────┘

                    App Launches
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Firebase Initializes          │
        │  • Loads session from cache    │
        │  • Connects to auth service    │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Check Current User            │
        │  (currentUserProvider)         │
        └────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
    ┌──────────────┐           ┌──────────────┐
    │ User = null  │           │ User exists  │
    │              │           │              │
    │ Show:        │           │ Show:        │
    │ "Log In"     │           │ Profile      │
    │ button       │           │ Logout btn   │
    └──────────────┘           └──────────────┘
          │                          │
          │                          │
          ▼                          ▼
    ┌──────────────────────────────────────┐
    │  User Clicks "Log In" or Logout      │
    └──────────────────────────────────────┘
          │                    │
          ▼                    ▼
    ┌──────────────┐   ┌──────────────┐
    │ Login Dialog │   │ Sign Out     │
    │              │   │              │
    │ Select Auth  │   │ Clear Session│
    │ Method       │   │              │
    └──────────────┘   │ user = null  │
          │            │              │
          ▼            │ Back to      │
    ┌──────────────────────────────┐ │
    │ Firebase Authentication      │ │
    │ • Google: OAuth flow         │ │
    │ • Apple: OAuth flow          │ │
    │ • Email: Email/Pass verify   │ │
    └──────────────────────────────┘ │
          │                          │
          ▼                          │
    ┌──────────────────────────────┐ │
    │ Create/Get User Account      │ │
    │ • Store credentials          │ │
    │ • Create session             │ │
    │ • Generate auth token        │ │
    └──────────────────────────────┘ │
          │                          │
          ▼                          ▼
    ┌──────────────────────────────┐
    │ authStateChanges Emits Event │
    └──────────────────────────────┘
          │
          ▼
    ┌──────────────────────────────┐
    │ currentUserProvider Updates  │
    └──────────────────────────────┘
          │
          ▼
    ┌──────────────────────────────┐
    │ UI Rebuilds (if watching)    │
    └──────────────────────────────┘
          │
          ▼
    ┌──────────────────────────────┐
    │ App Bar Updates:             │
    │ • Show profile instead of    │
    │   login button (or vice      │
    │   versa)                     │
    └──────────────────────────────┘
```

---

## 4. Email Sign-Up Form State Machine

```
    START
      │
      ▼
  ┌─────────────────────┐
  │  Show Sign In Mode  │
  │  Fields:            │
  │  • Email            │
  │  • Password         │
  │  • [Sign In] btn    │
  └─────────────────────┘
      │        ▲
      │ Click  │ toggle
      │ "Sign  │ click
      │  Up"   │
      │        │
      ▼        │
  ┌──────────────────────┐
  │ Show Sign Up Mode    │
  │ Fields:              │
  │ • Name               │
  │ • Email              │
  │ • Password           │
  │ • [Create Account]   │
  └──────────────────────┘
      │
      ├─ Validate Fields
      │  ├─ Email valid?
      │  ├─ Password ≥ 6 chars?
      │  └─ Name filled (signup)?
      │
      ├─ Yes → Continue
      │   │
      │   ▼
      │  Call Firebase API
      │   │
      │   ├─ Email exists?
      │   │  └─ Yes → Show error "Email already in use"
      │   │
      │   ├─ Account created?
      │   │  └─ Yes → Update display name
      │   │
      │   ▼
      │  User Logged In! ✓
      │   │
      │   ▼
      │  Close Dialog
      │   │
      │   ▼
      │  Show Profile
      │
      └─ No → Show error
         │  └─ Auto-dismiss after 3s
         │
         ▼
      Stay in Form
      (Allow retry)
```

---

## 5. Network Communication Sequence

```
Timeline of Events:

App Launch
├─ T+0ms: Firebase.initialize()
│   │
│   ▼
├─ T+100ms: Check currentUser (cached)
│   │
│   └─→ authStateChanges.listen()
│       └─→ UI updates with cached user (or null)
│
User Clicks "Log In"
├─ T+0ms: Show LoginDialog
│
User Clicks "Sign In with Google"
├─ T+0ms: _handleGoogleSignIn() called
├─ T+50ms: GoogleSignIn.signIn() launches Google chooser
├─ T+2000ms: User selects account and logs in
├─ T+2100ms: GoogleSignIn returns credentials
├─ T+2150ms: Firebase.signInWithCredential() called
├─ T+2200ms: Firebase sends to backend (network latency ~200-500ms)
│
Firebase Backend Processing
├─ T+2400ms: Verify OAuth token with Google
├─ T+2600ms: Find or create user account
├─ T+2700ms: Create session token
├─ T+2800ms: Return user data + token
│
Back to App
├─ T+3000ms: signInWithCredential() completes
├─ T+3050ms: User object received
├─ T+3100ms: authStateChanges emits new User
├─ T+3150ms: currentUserProvider updates
├─ T+3200ms: CustomAppBar rebuilds
│   │
│   ├─ currentUser is no longer null
│   └─ Shows profile instead of "Log In"
│
├─ T+3250ms: Dialog closes
├─ T+3300ms: Show success SnackBar
│
Done! User is logged in ✓
```

---

## 6. Error Handling Flow

```
Try Authentication
    │
    ├─ Catches Exception
    │
    ▼
Is it FirebaseAuthException?
    │
    ├─ YES
    │  │
    │  ├─ Code: "user-not-found"
    │  │  └─ Show: "No account with this email"
    │  │
    │  ├─ Code: "wrong-password"
    │  │  └─ Show: "Password is incorrect"
    │  │
    │  ├─ Code: "weak-password"
    │  │  └─ Show: "Password must be at least 6 characters"
    │  │
    │  ├─ Code: "email-already-in-use"
    │  │  └─ Show: "Email already registered"
    │  │
    │  ├─ Code: "network-request-failed"
    │  │  └─ Show: "No internet connection"
    │  │
    │  └─ Code: others
    │     └─ Show: "Authentication failed: {message}"
    │
    ├─ NO (Generic Exception)
    │  │
    │  └─ Show: "An unexpected error occurred"
    │
    ▼
Display Error Message
    │
    ├─ In container with red background
    ├─ 3-line height for readability
    ├─ Auto-dismiss after 3 seconds
    │
    ▼
User Can Retry
```

---

## 7. Component Hierarchy

```
App
├─ MaterialApp.router
│
├─ LandingPage (or other pages)
│  │
│  └─ CustomAppBar (PreferredSizeWidget)
│     │
│     └─ Row
│        ├─ Logo section
│        │
│        └─ Navigation section
│           │
│           └─ Consumer (watches auth state)
│              │
│              ├─ NOT LOGGED IN
│              │  └─ ElevatedButton "Log In"
│              │     │
│              │     └─ onPressed: showDialog
│              │        │
│              │        └─ LoginDialog
│              │           │
│              │           └─ Column
│              │              ├─ Title
│              │              ├─ Auth buttons (Google/Apple/Email)
│              │              └─ Terms text
│              │                 │
│              │                 └─ (Toggle to EmailLoginForm)
│              │                    │
│              │                    └─ Column
│              │                       ├─ Back button
│              │                       ├─ Email input
│              │                       ├─ Password input
│              │                       ├─ Sign In button
│              │                       └─ Toggle SignUp/SignIn
│              │
│              └─ LOGGED IN
│                 └─ PopupMenuButton
│                    ├─ Profile avatar + name
│                    │
│                    └─ Menu items
│                       └─ Logout option
```

---

## 8. Data Flow: State to UI

```
Firebase (Ground Truth)
    │
    ▼
AuthService
    │
    ├─ currentUser property
    │
    └─ authStateChanges Stream
        │
        ▼
    auth_provider.dart
        │
        └─ currentUserProvider
           │
           ├─ Listens to: authStateChanges
           │
           ├─ Emits: AsyncValue<User?>
           │   ├─ AsyncValue.loading
           │   ├─ AsyncValue.data(user)
           │   └─ AsyncValue.error(exception)
           │
           ▼
    CustomAppBar.build()
        │
        └─ ref.watch(currentUserProvider)
           │
           ├─ Triggers rebuild on change
           │
           ▼
        .when(
          data: (user) {
            if (user != null)
              Show: Profile + Menu
            else
              Show: "Log In" Button
          },
          loading: () => Show: Spinner,
          error: (e, st) => Show: "Log In" Button,
        )
           │
           ▼
        UI Updates

Flow Summary:
Firebase Change → authStateChanges Stream → currentUserProvider
→ CustomAppBar watches → Automatically rebuilds → UI updates
```

---

These diagrams show how all the pieces fit together! 🧩✨

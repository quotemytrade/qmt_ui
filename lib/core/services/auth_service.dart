import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:js' as js;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ✅ WEB: Use Firebase Google Sign-In directly
  // ✅ FIXED: Google Sign-In for Flutter WEB
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('DEBUG: signInWithGoogle starting');

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // ✅ CRITICAL: Force account picker EVERY time
      googleProvider.setCustomParameters({
        'prompt': 'select_account', // ← This forces account picker
      });

      print('DEBUG: Calling signInWithPopup');
      final UserCredential userCredential = await _firebaseAuth.signInWithPopup(
        googleProvider,
      );

      print('DEBUG: Google sign-in success: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      print('ERROR: Google sign-in failed: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      print('DEBUG: signInWithApple starting');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      print('DEBUG: Calling signInWithCredential for Apple');
      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } catch (e) {
      print('ERROR: Apple sign-in failed: $e');
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      print('DEBUG: signInWithEmail: $email');
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      print('DEBUG: signUpWithEmail: $email');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ COMPLETE logout
  Future<void> signOut() async {
    try {
      print('DEBUG: signOut starting');

      // Sign out from Firebase
      await _firebaseAuth.signOut();
      print('DEBUG: Firebase signed out');

      // Sign out from Google (web)
      try {
        js.context.callMethod('gapi.auth2.getAuthInstance', []).then((auth) {
          auth.callMethod('signOut', []);
        });
      } catch (e) {
        print('DEBUG: Google sign-out skipped (web specific): $e');
      }

      print('DEBUG: signOut completed');
    } catch (e) {
      print('ERROR in signOut: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}

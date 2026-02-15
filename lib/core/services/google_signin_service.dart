import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Centralized wrapper around google_sign_in for mobile + web.
class GoogleSignInService {
  // Singleton
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;

  /// TODO: Replace these with your real client IDs
  /// - ANDROID / iOS client id usually not needed explicitly
  /// - WEB client id is required on Flutter Web
  static const String _webClientId =
      '161756217795-o73hh7e5o82ebmnl4op4hjkg97d7eikm.apps.googleusercontent.com';

  bool _initialized = false;

  /// Must be called once on app startup (e.g. via a Provider or in main).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? _webClientId : null,
      scopes: const <String>['email', 'profile'],
    );

    try {
      // Try restore previous session silently
      _currentUser = await _googleSignIn.signInSilently();
      debugPrint(
        '[GoogleSignInService] Initialized. '
        'Current user: ${_currentUser?.email}',
      );
    } catch (e, st) {
      debugPrint('[GoogleSignInService] initialize() error: $e\n$st');
      // Do not rethrow – app should still work, user can sign in manually
    }
  }

  /// Main sign‑in entry. Handles web vs mobile.
  Future<GoogleSignInAccount?> signIn() async {
    await initialize();

    try {
      debugPrint('[GoogleSignInService] Starting sign-in (kIsWeb=$kIsWeb)...');

      if (kIsWeb) {
        return await _signInWeb();
      } else {
        _currentUser = await _googleSignIn.signIn();
      }

      if (_currentUser == null) {
        throw Exception('User cancelled Google sign‑in');
      }

      debugPrint(
        '[GoogleSignInService] Sign-in success: ${_currentUser!.email}',
      );
      return _currentUser;
    } catch (e, st) {
      debugPrint('[GoogleSignInService] signIn() error: $e\n$st');
      rethrow;
    }
  }

  /// Web-specific sign‑in. The plugin internally uses the Google Identity Services
  /// popup flow; we just surface better errors.
  Future<GoogleSignInAccount?> _signInWeb() async {
    try {
      _currentUser = await _googleSignIn.signIn();

      if (_currentUser == null) {
        // Most common case when user closes the popup.
        throw Exception('Google sign‑in popup was closed');
      }

      return _currentUser;
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('popup_closed')) {
        throw Exception('Google sign‑in popup was closed by the user');
      }
      throw Exception('Google web sign‑in failed: $e');
    }
  }

  /// Returns the Google ID token that you send to your backend (`/auth/login/google`).
  Future<String?> getIdToken() async {
    await initialize();

    if (_currentUser == null) {
      debugPrint('[GoogleSignInService] getIdToken(): no current user');
      return null;
    }

    try {
      final auth = await _currentUser!.authentication;
      debugPrint(
        '[GoogleSignInService] Got ID token '
        '(${auth.idToken?.substring(0, 15)}...)',
      );
      return auth.idToken;
    } catch (e, st) {
      debugPrint('[GoogleSignInService] getIdToken() error: $e\n$st');
      rethrow;
    }
  }

  /// Optional helper if you also want the Google access token.
  Future<String?> getAccessToken() async {
    await initialize();

    if (_currentUser == null) return null;

    try {
      final auth = await _currentUser!.authentication;
      return auth.accessToken;
    } catch (e, st) {
      debugPrint('[GoogleSignInService] getAccessToken() error: $e\n$st');
      return null;
    }
  }

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<bool> isSignedIn() async {
    await initialize();
    return _googleSignIn.isSignedIn();
  }

  Future<void> signOut() async {
    await initialize();
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      debugPrint('[GoogleSignInService] Signed out');
    } catch (e, st) {
      debugPrint('[GoogleSignInService] signOut() error: $e\n$st');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await initialize();
    try {
      await _googleSignIn.disconnect();
      _currentUser = null;
      debugPrint('[GoogleSignInService] Disconnected');
    } catch (e, st) {
      debugPrint('[GoogleSignInService] disconnect() error: $e\n$st');
      rethrow;
    }
  }
}

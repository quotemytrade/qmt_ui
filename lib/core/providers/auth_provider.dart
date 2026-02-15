import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/auth_models.dart';
import '../services/secure_storage_service.dart';
import '../services/logger_service.dart';

// ===========================
// CONFIG
// ===========================
const String apiBaseUrl = 'http://localhost:8000';

// ===========================
// AUTH PROVIDER
// ===========================
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final userRefreshTriggerProvider = StateProvider<int>((ref) => 0);

// ===========================
// AUTH NOTIFIER
// ===========================
class AuthNotifier extends AsyncNotifier<AuthState> {
  final _storage = SecureStorageService();

  @override
  Future<AuthState> build() async {
    final restored = await _restoreSession();
    return restored
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  // ===========================
  // GOOGLE LOGIN (WEB SAFE)
  // ===========================
  Future<AuthResponse?> loginWithGoogle() async {
    try {
      state = const AsyncLoading();
      LoggerService.debug('Google login started');

      // 🔥 Force clean Firebase state
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }

      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});

      await FirebaseAuth.instance.signInWithPopup(provider);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Firebase user missing after Google login');
      }

      final idToken = await user.getIdToken(true);
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      return await _loginToBackend(
        endpoint: '/auth/login/google',
        payload: {'id_token': idToken},
      );
    } catch (e, st) {
      LoggerService.error('Google login failed', e, st);
      state = AsyncError(e, st);
      return null;
    }
  }

  // ===========================
  // APPLE LOGIN
  // ===========================
  Future<AuthResponse?> loginWithApple() async {
    try {
      state = const AsyncLoading();
      LoggerService.debug('Apple login started');

      if (!await SignInWithApple.isAvailable()) {
        throw Exception('Apple Sign-In not available');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [],
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null) {
        throw Exception('Apple ID token missing');
      }

      return await _loginToBackend(
        endpoint: '/auth/login/apple',
        payload: {
          'id_token': idToken,
          'authorization_code': appleCredential.authorizationCode,
        },
      );
    } catch (e, st) {
      LoggerService.error('Apple login failed', e, st);
      state = AsyncError(e, st);
      return null;
    }
  }

  // ===========================
  // BACKEND LOGIN (COMMON)
  // ===========================
  Future<AuthResponse> _loginToBackend({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception('Backend auth failed');
    }

    final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

    await _storage.saveAccessToken(authResponse.accessToken);
    await _storage.saveRefreshToken(authResponse.refreshToken);

    ref.read(userRefreshTriggerProvider.notifier).state++;

    state = const AsyncData(AuthState.authenticated());
    LoggerService.info('Login successful');

    return authResponse;
  }

  // ===========================
  // LOGOUT
  // ===========================
  Future<void> logout() async {
    try {
      state = const AsyncLoading();
      LoggerService.debug('Logout started');

      final accessToken = await _storage.getAccessToken();
      if (accessToken != null) {
        await http.post(
          Uri.parse('$apiBaseUrl/auth/logout'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );
      }

      await FirebaseAuth.instance.signOut();
      await _storage.clearTokens();

      state = const AsyncData(AuthState.unauthenticated());
      LoggerService.info('Logout successful');
    } catch (e, st) {
      LoggerService.error('Logout failed', e, st);
      state = AsyncError(e, st);
    }
  }

  // ===========================
  // RESTORE SESSION
  // ===========================
  Future<bool> _restoreSession() async {
    try {
      final token = await _storage.getAccessToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$apiBaseUrl/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<AuthResponse?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncLoading();
      LoggerService.debug('Email login started');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/login/email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode != 200) {
        throw Exception('Email login failed');
      }

      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

      await _storage.saveAccessToken(authResponse.accessToken);
      await _storage.saveRefreshToken(authResponse.refreshToken);

      state = const AsyncData(AuthState.authenticated());
      LoggerService.info('Email login successful');

      return authResponse;
    } catch (e, st) {
      LoggerService.error('Email login failed', e, st);
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      state = const AsyncLoading();
      LoggerService.debug('Email signup started');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/signup/email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'display_name': displayName,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Email signup failed');
      }

      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

      await _storage.saveAccessToken(authResponse.accessToken);
      await _storage.saveRefreshToken(authResponse.refreshToken);

      state = const AsyncData(AuthState.authenticated());
      LoggerService.info('Email signup successful');

      return authResponse;
    } catch (e, st) {
      LoggerService.error('Email signup failed', e, st);
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

// ===========================
// CURRENT USER
// ===========================
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  ref.watch(userRefreshTriggerProvider);

  LoggerService.debug('Fetching current user profile');
  final storage = SecureStorageService();
  final token = await storage.getAccessToken();

  if (token == null) return null;

  final response = await http.get(
    Uri.parse('$apiBaseUrl/auth/profile'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) return null;
  return UserModel.fromJson(jsonDecode(response.body));
});

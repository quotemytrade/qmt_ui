import 'package:flutter/foundation.dart';

// ===========================
// USER MODEL
// ===========================
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String provider;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.provider,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      provider: json['provider'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'provider': provider,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, displayName: $displayName)';
}

// ===========================
// AUTH RESPONSE MODEL
// ===========================
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String tokenType;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.tokenType = 'bearer',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokenType: json['token_type'] as String? ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'token_type': tokenType,
    };
  }
}

// ===========================
// AUTH STATE
// ===========================
@immutable
abstract class AuthState {
  const AuthState();

  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error(String message) = _Error;
}

class _Unauthenticated extends AuthState {
  const _Unauthenticated();
}

class _Authenticated extends AuthState {
  const _Authenticated();
}

class _Loading extends AuthState {
  const _Loading();
}

class _Error extends AuthState {
  final String message;
  const _Error(this.message);
}

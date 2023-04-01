import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.email,
    required this.isEmailVerified
  });

  factory AuthUser.fromUser(User user) {
    return AuthUser(
      email: user.email,
      isEmailVerified: user.emailVerified
    );
  }
}

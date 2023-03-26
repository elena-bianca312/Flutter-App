import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerfied;
  const AuthUser(this.isEmailVerfied);

  factory AuthUser.fromUser(User user) {
    return AuthUser(user.emailVerified);
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';

extension FirebaseUserMapper on User {
  AuthUser toDomain() {
    return AuthUser(
      uid: uid,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
    );
  }
}

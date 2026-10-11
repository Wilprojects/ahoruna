import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uid,
    required super.displayName,
    required super.email,
    super.photoUrl,
  });

  factory UserProfileModel.fromSources({
    required User user,
    Map<String, dynamic>? data,
  }) {
    return UserProfileModel(
      uid: user.uid,
      displayName: data?['displayName'] as String? ?? user.displayName ?? '',
      email: user.email ?? data?['email'] as String? ?? '',
      photoUrl: data?['photoUrl'] as String? ?? user.photoURL,
    );
  }
}

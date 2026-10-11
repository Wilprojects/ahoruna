import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';
import 'package:ahoruna/src/features/profile/data/models/user_profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();

  Future<void> updateDisplayName({required String displayName});
}

class FirebaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  FirebaseProfileRemoteDataSource(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _requireUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('No existe un usuario autenticado.');
    }

    return user;
  }

  @override
  Future<UserProfileModel> getProfile() async {
    final user = _requireUser();

    final snapshot = await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .get();

    return UserProfileModel.fromSources(user: user, data: snapshot.data());
  }

  @override
  Future<void> updateDisplayName({required String displayName}) async {
    final user = _requireUser();
    final normalizedName = displayName.trim();

    await user.updateDisplayName(normalizedName);

    await _firestore.collection(FirestoreCollections.users).doc(user.uid).set({
      'displayName': normalizedName,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await user.reload();
  }
}

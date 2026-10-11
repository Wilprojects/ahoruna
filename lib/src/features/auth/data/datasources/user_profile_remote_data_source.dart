import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';

abstract interface class UserProfileRemoteDataSource {
  Future<void> createProfile({required User user, required String displayName});

  Future<void> ensureProfile({required User user});
}

class FirestoreUserProfileRemoteDataSource
    implements UserProfileRemoteDataSource {
  FirestoreUserProfileRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> createProfile({
    required User user,
    required String displayName,
  }) async {
    await _firestore.collection(FirestoreCollections.users).doc(user.uid).set({
      'displayName': displayName.trim(),
      'email': user.email,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> ensureProfile({required User user}) async {
    final reference = _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid);

    final snapshot = await reference.get();

    if (snapshot.exists) {
      return;
    }

    await reference.set({
      'displayName': user.displayName ?? '',
      'email': user.email,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

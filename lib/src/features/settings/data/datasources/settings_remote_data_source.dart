import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';
import 'package:ahoruna/src/features/settings/data/models/user_preferences_model.dart';

abstract interface class SettingsRemoteDataSource {
  Future<UserPreferencesModel> getPreferences();

  Future<void> updatePreferences(UserPreferencesModel preferences);
}

class FirestoreSettingsRemoteDataSource implements SettingsRemoteDataSource {
  FirestoreSettingsRemoteDataSource(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _requireUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('No existe un usuario autenticado.');
    }

    return user;
  }

  DocumentReference<Map<String, dynamic>> _preferencesReference(String uid) {
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .collection(FirestoreCollections.settings)
        .doc(FirestoreCollections.preferencesDocument);
  }

  @override
  Future<UserPreferencesModel> getPreferences() async {
    final user = _requireUser();

    final reference = _preferencesReference(user.uid);

    final snapshot = await reference.get();

    if (!snapshot.exists) {
      final defaultPreferences = UserPreferencesModel.defaults();

      await reference.set({
        ...defaultPreferences.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return defaultPreferences;
    }

    return UserPreferencesModel.fromMap(snapshot.data());
  }

  @override
  Future<void> updatePreferences(UserPreferencesModel preferences) async {
    final user = _requireUser();

    await _preferencesReference(user.uid).set({
      ...preferences.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

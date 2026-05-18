import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore-backed profile for `users/{uid}`.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.selectedLanguage,
  });

  final String uid;
  final String fullName;
  final String email;
  final String selectedLanguage;

  factory UserProfile.fromFirestore(
    String uid,
    Map<String, dynamic> data,
  ) {
    return UserProfile(
      uid: uid,
      fullName: (data['fullName'] as String?)?.trim() ?? '',
      email: (data['email'] as String?)?.trim() ?? '',
      selectedLanguage: (data['selectedLanguage'] as String?)?.trim() ?? 'en',
    );
  }
}

/// Reads the signed-in user's profile document from Firestore.
class UserProfileService {
  UserProfileService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  /// Returns `null` when there is no signed-in user or no `users/{uid}` doc.
  Future<UserProfile?> fetchCurrentUserProfile() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) {
      return null;
    }

    return UserProfile.fromFirestore(user.uid, data);
  }
}

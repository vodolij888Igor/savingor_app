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

  /// First name for dashboard greeting: Firestore profile, then Auth displayName,
  /// then email prefix. Returns `null` when no usable name is available.
  Future<String?> resolveGreetingFirstName() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data != null) {
        for (final String field in <String>['fullName', 'name', 'displayName']) {
          final String? rawName = _nonEmptyString(data[field]);
          if (rawName != null) {
            return _firstNameFrom(rawName);
          }
        }
      }
    }

    final String? authDisplayName = _nonEmptyString(user.displayName);
    if (authDisplayName != null) {
      return _firstNameFrom(authDisplayName);
    }

    final String? email = _nonEmptyString(user.email);
    if (email != null && email.contains('@')) {
      final String prefix = email.split('@').first.trim();
      if (prefix.isNotEmpty) {
        return prefix;
      }
    }

    return null;
  }

  static String? _nonEmptyString(Object? value) {
    if (value == null) {
      return null;
    }
    final String trimmed = value.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _firstNameFrom(String value) {
    final List<String> parts =
        value.trim().split(RegExp(r'\s+')).where((String part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return value.trim();
    }
    return parts.first;
  }
}

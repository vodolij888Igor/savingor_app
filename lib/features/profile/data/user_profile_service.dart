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

  /// Updates `users/{uid}.fullName` and keeps Auth displayName in sync.
  /// Throws [UserProfileException] with a user-friendly message on failure.
  Future<void> updateFullName(String fullName) async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const UserProfileException('You need to be signed in to edit your profile.');
    }

    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      throw const UserProfileException('Please enter your full name.');
    }

    try {
      await _firestore.collection('users').doc(user.uid).set(
        <String, dynamic>{
          'fullName': trimmed,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      await user.updateDisplayName(trimmed);
    } on FirebaseException {
      throw const UserProfileException(
        'Could not save your changes. Please try again.',
      );
    }
  }

  /// Securely changes the password: re-authenticates with [currentPassword],
  /// then calls `updatePassword`. Never stores or logs passwords.
  /// Throws [UserProfileException] with a user-friendly message on failure.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    final String? email = _nonEmptyString(user?.email);
    if (user == null || email == null) {
      throw const UserProfileException(
        'You need to be signed in to change your password.',
      );
    }

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword.trim());
    } on FirebaseAuthException catch (e) {
      throw UserProfileException(_changePasswordMessageForCode(e.code));
    }
  }

  static String _changePasswordMessageForCode(String code) {
    switch (code) {
      case 'wrong-password':
      case 'invalid-credential':
      case 'user-mismatch':
        return 'Current password is incorrect.';
      case 'weak-password':
        return 'New password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'requires-recent-login':
        return 'For security, please sign in again and retry.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Could not update your password. Please try again.';
    }
  }

  /// Sends a password reset email to the signed-in user's email address.
  /// Throws [UserProfileException] with a user-friendly message on failure.
  Future<void> sendPasswordResetEmail() async {
    final User? user = _firebaseAuth.currentUser;
    final String? email = _nonEmptyString(user?.email);
    if (email == null) {
      throw const UserProfileException(
        'No email is linked to this account.',
      );
    }

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const UserProfileException(
          'Network error. Check your connection and try again.',
        );
      }
      throw const UserProfileException(
        'Could not send the reset email. Please try again.',
      );
    }
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

/// Thrown when a profile operation fails with a user-facing message.
class UserProfileException implements Exception {
  const UserProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}

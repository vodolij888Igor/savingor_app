import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Email/Password authentication and Firestore user profile on sign-up.
class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(
        messageForCode(e.code),
        code: e.code,
      );
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    String selectedLanguage = 'en',
  }) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;
      final String? uid = user?.uid;
      if (uid == null) {
        throw const AuthServiceException(
          'Account was created but your profile could not be saved. Please try again.',
        );
      }

      final String trimmedName = fullName.trim();
      if (trimmedName.isNotEmpty) {
        await user!.updateDisplayName(trimmedName);
      }

      await _upsertUserProfile(
        uid: uid,
        fullName: trimmedName,
        email: email.trim(),
        selectedLanguage: _normalizeLanguageCode(selectedLanguage),
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(
        messageForCode(e.code),
        code: e.code,
      );
    } on AuthServiceException {
      rethrow;
    } on FirebaseException catch (e) {
      throw AuthServiceException(
        'Could not save your profile. Please try again.',
        code: e.code,
      );
    }
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  /// One document per user at `users/{uid}`. [SetOptions.merge] avoids duplicate
  /// docs; [createdAt] is written only when the document does not exist yet.
  Future<void> _upsertUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String selectedLanguage,
  }) async {
    final DocumentReference<Map<String, dynamic>> docRef =
        _firestore.collection('users').doc(uid);
    final DocumentSnapshot<Map<String, dynamic>> existing = await docRef.get();

    final Map<String, dynamic> data = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'selectedLanguage': selectedLanguage,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (!existing.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await docRef.set(data, SetOptions(merge: true));
  }

  static String _normalizeLanguageCode(String code) {
    const allowed = <String>{'en', 'uk', 'ru', 'fr', 'de', 'es'};
    final normalized = code.toLowerCase().trim();
    return allowed.contains(normalized) ? normalized : 'en';
  }

  /// Maps [FirebaseAuthException.code] values to short English messages for UI.
  static String messageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support if you need help.';
      case 'user-not-found':
        return 'No account found with this email. Check the address or create an account.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Try signing in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email and password sign-in is not enabled. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

/// Thrown when a Firebase auth operation fails with a mapped user message.
class AuthServiceException implements Exception {
  const AuthServiceException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

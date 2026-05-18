import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Email/Password authentication. Not wired to UI yet.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

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
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
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

  Future<void> signOut() => _firebaseAuth.signOut();

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

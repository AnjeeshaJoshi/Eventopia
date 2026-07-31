import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-credential':
          return 'The email address or password is incorrect.';
        case 'invalid-email':
          return 'Enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'Check your internet connection and try again.';
        case 'operation-not-allowed':
          return 'This sign-in method is not available right now.';
        case 'requires-recent-login':
          return 'Please sign in again before making this change.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        default:
          return 'We could not complete the sign-in request. Please try again.';
      }
    } else if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to access this resource.';
        case 'unavailable':
          return 'Service is temporarily unavailable. Please try again shortly.';
        default:
          return 'We could not complete that request. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again later.';
  }
}

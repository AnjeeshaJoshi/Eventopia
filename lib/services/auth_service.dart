import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<User> register(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!;
  }

  /// Creates an account without changing the administrator's active session.
  /// Firebase client SDKs otherwise sign in as the newly-created organizer.
  Future<User> registerAsAdministrator(String email, String password) async {
    const appName = 'organizerRegistration';
    late final FirebaseApp secondaryApp;
    try {
      secondaryApp = Firebase.app(appName);
    } catch (_) {
      secondaryApp = await Firebase.initializeApp(
        name: appName,
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
    try {
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } finally {
      await secondaryAuth.signOut();
      await secondaryApp.delete();
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is signed in.');
    }

    await user.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

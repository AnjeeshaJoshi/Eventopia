import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../utils/error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<UserModel?>? _userSubscription;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _authService.authStateChanges.listen((firebaseUser) async {
      await _userSubscription?.cancel();
      if (firebaseUser != null) {
        _userSubscription = _firestoreService.userStream(firebaseUser.uid).listen((user) {
          _currentUser = user;
          notifyListeners();
        });
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signIn(email, password);
      // Populate the role before LoginScreen decides which dashboard to open.
      // The Firestore stream below keeps it current after this initial read.
      _currentUser = await _firestoreService.getUser(credential.user!.uid);
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'attendee',
    String? organization,
    bool preserveCurrentSession = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Create Firebase Authentication account
      final firebaseUser = preserveCurrentSession
          ? await _authService.registerAsAdministrator(email, password)
          : await _authService.register(email, password);

      // Convert String to UserRole
      final userRole = UserRole.values.firstWhere(
            (e) => e.name == role,
        orElse: () => UserRole.attendee,
      );

      // Create Firestore user document
      final user = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        phone: phone,
        role: userRole,
        organization: organization,
        profileImage: null,
        // Admin-created organizers must replace the temporary password on
        // their first sign-in. Self-registered attendees are not affected.
        mustChangePassword:
            preserveCurrentSession && userRole == UserRole.organizer,
        createdAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestoreService.createUser(user);

      if (!preserveCurrentSession) _currentUser = user;
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String currentPwd, String newPwd) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.changePassword(newPwd);
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(mustChangePassword: false);
        await _firestoreService.updateUserModel(_currentUser!);
      }
    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}

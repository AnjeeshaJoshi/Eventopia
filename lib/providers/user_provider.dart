import 'dart:io';

import 'package:flutter/material.dart';
import '../models.dart'; // for UserRole enum
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Filtered list of organizer users
  List<UserModel> get organizers => _users.where((u) => u.role == UserRole.organizer).toList();
  
  /// Filtered list of attendee users
  List<UserModel> get attendeeUsers => _users.where((u) => u.role == UserRole.attendee).toList();

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _firestoreService.getAllUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.updateUser(
        user.uid,
        user.toJson(),
      );
      final idx = _users.indexWhere((u) => u.uid == user.uid);
      if (idx >= 0) {
        _users[idx] = user;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _users.firstWhere((u) => u.uid == uid);
      if (user.role == UserRole.admin) {
        throw Exception('Cannot delete admin user');
      }
      await _firestoreService.deleteUser(uid);
      _users.removeWhere((u) => u.uid == uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    String? organization,
    String? profileImagePath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final existing = _users.where((u) => u.uid == uid).firstOrNull ??
          await _firestoreService.getUser(uid);
      if (existing == null) throw StateError('User profile not found.');
      String? imageUrl = existing.profileImage;

      if (profileImagePath != null) {
        imageUrl = await _storageService.uploadProfileImage(
          File(profileImagePath),
          existing.uid,
        );
      }

      final updated = existing.copyWith(
        name: name,
        phone: phone,
        organization: organization,
        profileImage: imageUrl,
      );

      await _firestoreService.updateUser(
        updated.uid,
        updated.toJson(),
      );
      final idx = _users.indexWhere((u) => u.uid == uid);
      if (idx >= 0) {
        _users[idx] = updated;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

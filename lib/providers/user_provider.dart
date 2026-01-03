import 'dart:io';

import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String? avatarPath;

  const UserProfile({required this.name, required this.email, this.avatarPath});

  UserProfile copyWith({String? name, String? email, String? avatarPath}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

/// User Provider - manages profile & avatar (in-memory stub)
class UserProvider extends ChangeNotifier {
  UserProfile _currentUser = const UserProfile(
    name: 'Segond',
    email: 'user@example.com',
  );
  bool _updating = false;

  UserProfile get currentUser => _currentUser;
  bool get isUpdating => _updating;

  Future<void> updateProfile({String? name, String? email}) async {
    _updating = true;
    notifyListeners();
    // TODO: Persist to backend/local storage
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = _currentUser.copyWith(name: name, email: email);
    _updating = false;
    notifyListeners();
  }

  Future<void> updateAvatar(String? avatarPath) async {
    _updating = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = _currentUser.copyWith(avatarPath: avatarPath);
    _updating = false;
    notifyListeners();
  }

  Future<void> uploadAvatar(File imageFile) async {
    await updateAvatar(imageFile.path);
  }
}

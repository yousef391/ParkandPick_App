import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    // TODO: integrate real auth
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return _isLoggedIn;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return _isLoggedIn;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  User? _user;
  User? get user => _user;

  String? _errorMessage; // <-- add this
  String? get errorMessage => _errorMessage; // <-- getter

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------------------
  // Login
  // ---------------------------
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email, password);
      _errorMessage = null; // clear error on success
      return _user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message; // capture Firebase error
      return false;
    } catch (e) {
      _errorMessage = e.toString(); // capture other errors
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // ---------------------------
  // Signup
  // ---------------------------
  Future<bool> signup(String email, String password,String name) async {
    _setLoading(true);
    try {
      _user = await _authService.signUp(email, password,name);
      _errorMessage = null;
      return _user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // ---------------------------
  // Logout
  // ---------------------------
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  // ---------------------------
  // Auto-login (check local storage)
  // ---------------------------
  Future<bool> tryAutoLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      _user = _authService.currentUser;
      notifyListeners();
    }
    return loggedIn;
  }
}

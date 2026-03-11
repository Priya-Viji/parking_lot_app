import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  String? _errorMessage; 
  String? get errorMessage => _errorMessage; 

  User? get user => _authService.currentUser;

  //Helpers

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  // Login

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final result = await _authService.login(email, password);
      _setError(null);
      return result != null;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Signup

   Future<bool> signup(String email, String password, String name) async {
    _setLoading(true);
    try {
      final result = await _authService.signUp(email, password, name);
      _setError(null);
      return result != null;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  // Auto-login
  
  Future<bool> tryAutoLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      notifyListeners();
    }
    return loggedIn;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------
  // Sign up
  // ---------------------------
  Future<User?> signUp(String email, String password,String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user locally
      await _saveUserLocally(result.user);

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // ---------------------------
  // Login
  // ---------------------------
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user locally
      await _saveUserLocally(result.user);

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // ---------------------------
  // Logout
  // ---------------------------
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------------------------
  // Save user info locally
  // ---------------------------
  Future<void> _saveUserLocally(User? user) async {
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('userEmail', user.email ?? '');
    await prefs.setBool('isLoggedIn', true);
  }

  // ---------------------------
  // Get current user from Firebase
  // ---------------------------
  User? get currentUser => _auth.currentUser;

  // ---------------------------
  // Check if logged in locally
  // ---------------------------
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // ---------------------------
  // Auth state changes
  // ---------------------------
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

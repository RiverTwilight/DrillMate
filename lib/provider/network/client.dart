import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClient {
  final String apiBaseUrl;
  final storage = const FlutterSecureStorage();
  User? _currentUser;
  final _streamController = StreamController<User?>.broadcast();

  AuthClient({required this.apiBaseUrl});

  User? get currentUser => _currentUser;

  Stream<User?> get onAuthStateChange => _streamController.stream;

  Future<void> signInWithPassword(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Handle your user authentication logic and session management here
      // For example, you could parse the user from response and set to _currentUser
      _currentUser = User.fromJson(
          jsonDecode(response.body)); // Assuming User is a model class
      _streamController.add(_currentUser);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Handle account creation logic here
      _currentUser = User.fromJson(jsonDecode(response.body));
      _streamController.add(_currentUser);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<void> signOut() async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': _currentUser?.id}),
    );

    if (response.statusCode == 200) {
      _currentUser = null;
      _streamController.add(_currentUser);
    } else {
      throw Exception('Failed to log out');
    }
  }

  Future<void> deleteAccount() async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/delete_account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': _currentUser?.id}),
    );

    if (response.statusCode == 200) {
      _currentUser = null;
      _streamController.add(_currentUser);
    } else {
      throw Exception('Failed to delete account');
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/update_password'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'userId': _currentUser?.id, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update password');
    }
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    // Assuming you have a way to verify the user's session or token
    // This could be a call to your API to validate the current session token
    return _currentUser != null;
  }
}

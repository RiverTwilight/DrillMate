import 'dart:async';
import 'dart:convert';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// TODO Adapt for new auth client
class AuthProvider {
  final _auth = Supabase.instance.client.auth;

  User? get user => _auth.currentUser;

  bool get loggedIn {
    return user != null;
  }

  final storage = const FlutterSecureStorage();

  Stream<User?> get userStream {
    // Create a new StreamController.
    final StreamController<User?> _streamController = StreamController<User?>();

    // Emit the current session data.
    _streamController.add(_auth.currentUser);

    // Listen for changes in the auth state.
    final authSubscription = _auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        // Emit the new user as the stream data.
        _streamController.add(session?.user);
      } else {
        // Emit null when the user is not signed in.
        _streamController.add(null);
        // restoreLogin();
      }
    });

    // Make sure to cancel the subscription when the stream is cancelled.
    _streamController.onCancel = authSubscription.cancel;

    return _streamController.stream;
  }

  Future<void> restoreLogin() async {
    String? loginCreditJson = await storage.read(key: 'loginCredit');

    if (loginCreditJson == null) {
      return;
    }

    Map<String, String> loginCredit = jsonDecode(loginCreditJson);

    if (loginCredit['email'] == null || loginCredit['password'] == null) {
      return;
    }

    print("Start restore login");

    await _auth.signInWithPassword(
      email: loginCredit['email'],
      password: loginCredit['password'] as String,
    );
  }

  Future<void> login(String email, String password) async {
    // final storage = const FlutterSecureStorage();

    // print("Store login credition");

    // storage.write(
    //     key: 'loginCredit',
    //     value: jsonEncode({'password': password, 'email': email}));

    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signup(String email, String password) async {
    final dataManager = DataProvider();

    await _auth.signUp(email: email, password: password);

    await dataManager.createAccount(user!.id,
        avatarUrl: "asdfasd", nickname: "asdfasdf", email: email);
  }

  Future<void> logout() async {
    await storage.delete(key: 'userInfo');

    return _auth.signOut();
  }

  Future<void> deleteUser() async {
    final res = await Supabase.instance.client.functions.invoke(
      'deleteAccount',
      body: {"uid": user!.id},
    );

    print(res.status);

    return _auth.signOut();
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final UserResponse res = await _auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }

  // Future<void> loginWithGoogle(OAuthCredential credential) {
  //   return _auth.signInWithCredential(credential);
  // }

  Future<User?> checkIfUserIsLoggedIn() async {
    return _auth.currentUser; // Check if user is logged in
  }
}

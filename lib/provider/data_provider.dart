import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

enum ServiceType { supabase, selfhost }

String generateInviteCode(String userId) {
  final input = userId + DateTime.now().millisecondsSinceEpoch.toString();
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);

  // Return the first 8 characters of the hash as the invite code
  return digest.toString().substring(0, 8);
}

class DataProvider extends ChangeNotifier {
  ServiceType serviceProvider = ServiceType.supabase;
  final SupabaseQueryBuilder usersRef =
      Supabase.instance.client.from('Account');
  Map<String, dynamic> _userInfo = {};

  Map<String, dynamic> get userInfo => _userInfo;

  final storage = const FlutterSecureStorage();

  Future<void> loadData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      try {
        _userInfo = await _getAccountInfo(user.id);

        // Store the user info along with the current timestamp
        await storage.write(key: 'userInfo', value: jsonEncode(_userInfo));
        await storage.write(
            key: 'userInfoTimestamp', value: DateTime.now().toIso8601String());
      } catch (e) {
        print("Use cached user info");
        // Error (possibly offline), attempt to load from local storage
        String? userInfoJson = await storage.read(key: 'userInfo');
        String? timestamp = await storage.read(key: 'userInfoTimestamp');

        if (userInfoJson != null && timestamp != null) {
          DateTime storedTimestamp = DateTime.parse(timestamp);

          // Verify that the stored data is not expired (e.g., within 7 days)
          if (DateTime.now().difference(storedTimestamp).inDays < 7) {
            _userInfo = jsonDecode(userInfoJson);
          }
        }
      }
    }

    notifyListeners();
  }

  Future<void> createAccount(String uid,
      {String avatarUrl = 'default_avatar_url',
      String nickname = 'User_BD8CJO',
      String email = 'jon@doe.com',
      String inviteBy = ''}) async {
    // print("create account for $uid");

    Map<String, dynamic> userData = {
      'uid': uid,
      'avatarUrl': avatarUrl,
      'nickname': nickname,
      'deleted': false,
      'email': email,
      'inviteCode': generateInviteCode(uid)
    };

    if (serviceProvider == ServiceType.supabase) {
      print("Cretea use profile");
      await usersRef.insert([userData]).then((value) => print("Success"));
    }
  }

  Future<void> deleteAccount(String uid) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      return usersRef.delete().eq('uid', uid);
    } else {
      throw Exception('No user is currently signed in');
    }
  }

  Future<Map<String, dynamic>> _getAccountInfo(String uid) async {
    // print("query $uid");
    final querySnapshot = await usersRef.select().eq('uid', uid);

    if (querySnapshot.isNotEmpty) {
      final docSnapshot = querySnapshot.first;

      return docSnapshot as Map<String, dynamic>;
    } else {
      throw Exception('No user is currently signed in');
    }
  }

  bool get isLifetimePlus {
    return _userInfo['own_lifetime_plus'];
  }

  bool get isPlus {
    if (_userInfo['uid'] == null) {
      return false;
    }

    if (isLifetimePlus) {
      return true;
    }

    int unixTimestamp = _userInfo['plus_expire_date'];

    DateTime dateFromUnix =
        DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

    return dateFromUnix.isAfter(DateTime.now());
  }

  // Future<void> modifyAccountInfo(Map<String, dynamic> updates) async {
  //   final user = Supabase.instance.client.auth.currentUser;
  //   if (user != null) {
  //     await usersRef.doc(user.uid).update(updates);
  //   } else {
  //     throw Exception('No user is currently signed in');
  //   }
  // }
}

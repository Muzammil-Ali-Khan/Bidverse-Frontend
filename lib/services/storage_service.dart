import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/UserModel.dart';

class StorageService {
  static const storage = FlutterSecureStorage();

  // keys
  static const _authToken = 'auth-token';
  static const _authUser = 'auth-user';
  static const _currentScreen = "current-screen";

  static Future<String> getAuthToken() async {
    return await storage.read(key: _authToken) ?? "";
  }

  static Future<void> setAuthToken(String token) async {
    await storage.write(key: _authToken, value: token);
  }

  static Future<void> deleteAuthToken() async {
    await storage.delete(key: _authToken);
  }

  static Future<void> setAuthUser(UserModel user) async {
    String userJson = jsonEncode(user.toJson());
    await storage.write(key: _authUser, value: userJson);
  }

  static Future<UserModel?> getAuthUser() async {
    var userJsonString = await storage.read(key: _authUser);

    Map<String, dynamic> userJson;
    if (userJsonString != null) {
      userJson = jsonDecode(userJsonString);
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  static Future<void> deleteAuthUser() async {
    await storage.delete(key: _authUser);
  }

  static Future<String> getCurrentScreen() async {
    return await storage.read(key: _currentScreen) ?? "";
  }

  static Future<void> setCurrentScreen(String screen) async {
    await storage.write(key: _currentScreen, value: screen);
  }

  static Future<void> deleteCurrentScreen() async {
    await storage.delete(key: _currentScreen);
  }
}

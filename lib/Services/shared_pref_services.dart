import 'dart:convert';

import 'package:ar_industrial/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String logKey = 'logKey';
  static Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(logKey, value);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(logKey);
  }

  static Future<void> setuser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
  
  static Future<UserModel> getuser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userstrig = prefs.getString('user').toString();
    Map<String, dynamic> usermap = jsonDecode(userstrig);
    return UserModel.fromJson(usermap);
  }
}
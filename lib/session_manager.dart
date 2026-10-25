import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _loginStatusKey = 'is_logged_in';

  Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_loginStatusKey, isLoggedIn);
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginStatusKey) ?? false;
  }

  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_loginStatusKey);
  }
}

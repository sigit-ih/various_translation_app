import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // key-value
  // https://pub.dev/packages/shared_preferences/example

  SharedPreferencesHelper();

  // Panggil SharedPreferences
  static Future<SharedPreferences> get sharedpreferences =>
      SharedPreferences.getInstance();

  // key
  static final String KEY_LANGUAGE = 'language';
  // static final String KEY_PASSWORD = 'KEY_PASSWORD';
  // static final String KEY_ISREMEMBER = 'KEY_ISREMEMBER';
  // static final String KEY_ISLOGIN = 'KEY_ISLOGIN';
  // static final String KEY_TOKEN = 'KEY_TOKEN';

  // Setter & Getter untuk data
  // Simpan language
  static Future saveLanguage(String language) async {
    final preference = await sharedpreferences;
    return preference.setString(KEY_LANGUAGE, language);
  }

  // Memanggil language
  static Future<String> readLanguage() async {
    try {
      final preference = await sharedpreferences;
      return preference.getString(KEY_LANGUAGE) ??
          'English'; // Default ke English jika tidak ada
    } catch (e) {
      print("Error reading language: $e");
      return 'English'; // Default ke English jika ada error
    }
  }

  // Simpan password
  // static Future savePassword(String password) async {
  //   final preference = await sharedpreferences;
  //   return preference.setString(KEY_PASSWORD, password);
  // }

  // Memanggil password
  // static Future<String> readPassword() async {
  //   final preference = await sharedpreferences;
  //   return preference.getString(KEY_PASSWORD) ?? '';
  // }

  // Simpan isRemember
  // static Future saveIsRemember(bool isRemember) async {
  //   final preference = await sharedpreferences;
  //   return preference.setBool(KEY_ISREMEMBER, isRemember);
  // }

  // Memanggil isRemember
  // static Future<bool> readIsRemember() async {
  //   final preference = await sharedpreferences;
  //   return preference.getBool(KEY_ISREMEMBER) ?? false;
  // }

  // Simpan isLogin
  // static Future saveIsLogin(bool isLogin) async {
  //   final preference = await sharedpreferences;
  //   return preference.setBool(KEY_ISLOGIN, isLogin);
  // }

  // Memanggil isLogin
  // static Future<bool> readIsLogin() async {
  //   final preference = await sharedpreferences;
  //   return preference.getBool(KEY_ISLOGIN) ?? false;
  // }

  // Simpan token
  // static Future saveToken(String token) async {
  //   final preference = await sharedpreferences;
  //   return preference.setString(KEY_TOKEN, token);
  // }

  // Memanggil token
  // static Future<String> readToken() async {
  //   final preference = await sharedpreferences;
  //   return preference.getString(KEY_TOKEN) ?? '';
  // }

  // Clear all data
  static Future clearAllData() async {
    final preference = await sharedpreferences;
    await Future.wait(<Future>[
      preference.remove(KEY_LANGUAGE),
      // preference.remove(KEY_PASSWORD),
      // preference.remove(KEY_ISREMEMBER),
      // preference.remove(KEY_ISLOGIN),
      // preference.remove(KEY_TOKEN),
    ]);
  }
}

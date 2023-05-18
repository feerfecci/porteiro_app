import 'package:shared_preferences/shared_preferences.dart';

class LocalInfos {
  static Future createCache(String user, String senha) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('user', user);
    preferences.setString('senha', senha);
  }

  static Future readCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? getUser = preferences.getString('user');
    String? getSenha = preferences.getString('senha');
    List infosCache = [getUser, getSenha];
    return infosCache;
  }

  static Future removeCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.remove('user');
    preferences.remove('senha');
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class Authentication{
  static SharedPreferences _sharedPreferences;

  static Future<SharedPreferences> get _instance async => _sharedPreferences ??= await SharedPreferences.getInstance();

  //call this method in main init
  static Future<SharedPreferences> init() async {
    _sharedPreferences = await _instance;
    return _sharedPreferences;
  }

  static getToken(String tokenName) async{
    return _instance.then((value) => value.get(tokenName));
  }

  static setToken(String token,json) async {
    var pref = await _instance;
    pref.setString(token, json);
  }

  static Future<Set<String>> getAllKeys() async{
    var pref = await _instance;
    return pref.getKeys();
  }

  static Future<bool> checkKey(String key) async{
    var pref = await _instance;
    return pref.containsKey(key);
  }

  static removeKey(String key) async {
    var pref = await _instance;
    pref.remove(key);
  }

  static removeToken() async{
    var pref = await _instance;
    pref.clear();
  }


}
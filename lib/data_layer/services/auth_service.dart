import 'package:shared_preferences/shared_preferences.dart';

class Authentication{
  static SharedPreferences _sharedPreferences;

  static getToken(String tokenName) async{
    if (_sharedPreferences == null){
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences.getString(tokenName);
  }
  static setToken(String token,json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(token, json);
  }

  static removeTokens() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }


}
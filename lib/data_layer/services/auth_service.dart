import 'package:shared_preferences/shared_preferences.dart';

class Authentication{
  static SharedPreferences sharedPreferences;

  static getToken(String tokenName) async{
    if (sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }
    return sharedPreferences.getString(tokenName);
  }
  static setToken(String token,json) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(token, json);
  }

  static removeTokens() async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }


}
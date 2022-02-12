import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class LoginAPI{
  static Future<dynamic> getUser({@required String email, @required String password}) async {
    var dio = Dio();

    //dio throws an error if response is not 201
    try {
      var response = await dio.post(URLS.userLoginUrl, data: {
        'email': email,
        'password': password,
        'user_type': "VOL",
      });
      return {'data': response.data};
    } on DioError catch (e) {
      return {'error': e.message[0].toString()};
    }
  }

  static Future<String> logInCheck({@required String id,@required token}) async {
    var dio = Dio();
    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.userLoginCheckUrl+id);
      return response.statusCode.toString();
    } on DioError catch (e) {
      print(e.response.data);
      return e.response.data['detail'].toString();
    }
  }
}

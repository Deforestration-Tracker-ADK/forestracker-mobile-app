import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class LoginAPI{
  final String email;
  final String password;
  var jsonResponse;
  Map data;
  final url = Uri.parse('API');

  LoginAPI({@required this.email, @required this.password}){
    data = {'email': this.email, 'password': this.password};
  }


  Future getUser() async {
    var response = await http.post(this.url, body: this.data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        Authentication.setToken("token", jsonResponse['token']);
        Authentication.setToken("userID", jsonResponse['userID']);
        return jsonResponse;
      }
      else{
        throw('undefined user');
      }
    }
  }
}

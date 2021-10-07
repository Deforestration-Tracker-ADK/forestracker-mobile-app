import 'package:flutter/cupertino.dart';
import 'package:forest_tracker/presentation_layer/utilities/validation.dart';

abstract class LoginEvents{}

class GetUser extends LoginEvents{
  final String email;
  final String password;
  String validEmail;
  String validPassword;

  GetUser({@required this.email,@required this.password}){
    this.validEmail = validateUsername(this.email);
    this.validPassword = validatePassword(this.password);
  }

}

class LogoutUser extends LoginEvents{}
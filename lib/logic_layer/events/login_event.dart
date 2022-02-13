import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:forest_tracker/presentation_layer/utilities/validation.dart';

abstract class LoginEvents extends Equatable{}

class GetUser extends LoginEvents{
  final String username;
  final String password;
  String validEmail;
  String validPassword;

  GetUser({@required this.username,@required this.password}){
    this.validEmail = validateUsername(this.username);
    this.validPassword = validatePassword(this.password);
  }

  @override
  List<Object> get props => [username,password];

}

class LoginCheck extends LoginEvents{
  @override
  List<Object> get props => [];
}

class LogoutUser extends LoginEvents{
  @override
  List<Object> get props => [];
}
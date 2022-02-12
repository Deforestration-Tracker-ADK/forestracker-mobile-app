import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:forest_tracker/presentation_layer/utilities/validation.dart';

abstract class LoginEvents extends Equatable{}

class GetUser extends LoginEvents{
  final String email;
  final String password;
  String validEmail;
  String validPassword;

  GetUser({@required this.email,@required this.password}){
    this.validEmail = validateUsername(this.email);
    this.validPassword = validatePassword(this.password);
  }

  @override
  List<Object> get props => [email,password];

}

class LoginCheck extends LoginEvents{
  @override
  List<Object> get props => [];
}

class LogoutUser extends LoginEvents{
  @override
  List<Object> get props => [];
}
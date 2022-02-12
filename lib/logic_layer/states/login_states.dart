import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:forest_tracker/data_layer/models/user.dart';

// ignore: must_be_immutable
abstract class LoginStates extends Equatable{
  final bool isValidEmail;
  final bool isValidPassword;

  LoginStates({this.isValidEmail,this.isValidPassword});

  @override
  List<Object> get props => [this.isValidEmail,this.isValidPassword];
}

class InitialState extends LoginStates{}

class LoginWithInvalidCredentials extends LoginStates{
  final String errorMsg;
  LoginWithInvalidCredentials({this.errorMsg});
  @override
  List<String> get props => [errorMsg];
}

class LoginCredentialLoading extends LoginStates{}


class LoginWithCorrectCredentials extends LoginStates{
  LoginWithCorrectCredentials();

  @override
  List<User> get props => [];
}


class LogoutState extends LoginStates{}

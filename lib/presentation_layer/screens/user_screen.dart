import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/logic_layer/events/login_event.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

// ignore: must_be_immutable
class UserPage extends StatelessWidget {
  final String name;
  SharedPreferences sharedPreferences;

  UserPage({ this.name});

  _logOut(context) async{
    Authentication.removeToken();
    //Authentication.removeKey('token');
    //Authentication.removeKey('userID');
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.add(LogoutUser());
    Navigator.pushReplacementNamed(context, LoginScreen.id);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        child: Center(
          child: TextButton(
            child: Text('LogOut'),
            onPressed:()=> _logOut(context),
          ),
        ),
      ),
    );
  }
}

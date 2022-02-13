import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/Constants.dart';
import 'package:forest_tracker/logic_layer/events/login_event.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/navigation_cubit.dart';
import 'package:forest_tracker/logic_layer/states/login_states.dart';
import 'package:forest_tracker/presentation_layer/utilities/validation.dart';
import 'package:forest_tracker/presentation_layer/utilities/components.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  BlocConsumer<LoginBloc, LoginStates>(
                      listener: (context, state) {
                    if (state is LoginWithInvalidCredentials) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                elevation: 5,
                                title: Text('Login Error'),
                                content: Text(state.errorMsg),
                              ));
                    }
                  }, builder: (context, state) {
                    if (state is InitialState ||
                        state is LogoutState ||
                        state is LoginWithInvalidCredentials) {
                      return loginForm(context);
                    } else if (state is LoginWithCorrectCredentials) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        //used to return circular progress indicator until the frame build
                        BlocProvider.of<NavigationCubit>(context).navigate(0);
                        Navigator.pushReplacementNamed(context, MainPage.id);
                      });
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form loginForm(context) {
    return Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              validator: (value) => validateUsername(value),
              onChanged: (value) {
                email = value;
              },
              decoration:
                  TextFieldDecoration.copyWith(hintText: 'Enter username'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              obscureText: true,
              textAlign: TextAlign.center,
              validator: (value) => validatePassword(value),
              onChanged: (value) {
                password = value;
              },
              decoration: TextFieldDecoration.copyWith(
                hintText: 'Enter password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            customButton(
              color: Colors.greenAccent,
              text: 'SignIn',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              onPressed: () async {
                if (!_formkey.currentState.validate()) return null;
                showSpinner = true;
                try {
                  final bloc = BlocProvider.of<LoginBloc>(context);
                  bloc.add(GetUser(email: email, password: password));
                  showSpinner = false;
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            Center(
              child: new InkWell(
                  child: new Text('Forget Password'),
                  onTap: () => launch(
                      URLS.forgetPasswordUrl)),
            )
          ],
        ));
  }
}

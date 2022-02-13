import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/login_bloc.dart';
import 'package:forest_tracker/logic_layer/events/login_event.dart';
import 'package:forest_tracker/logic_layer/states/login_states.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginCheck());
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3), lowerBound: 0.0, upperBound: 1.0,
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.forward();

  }


  checkLoginStatus(LoginStates state) async {
    if (state is LoginWithCorrectCredentials) {
      Navigator.pushReplacementNamed(context, MainPage.id);
    } else if(state is LoginWithInvalidCredentials) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc,LoginStates>(
      listener: (context,state) {
        if(state is !LoginWithInvalidCredentials && state is !LoginWithCorrectCredentials){
          context.read<LoginBloc>().add(LoginCheck());
        }
        else{
          checkLoginStatus(state);
        }
      },
      builder:(context,state)=>Scaffold(
          backgroundColor: Colors.greenAccent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  flex: 4,
                  child: Container(
                    child: FadeTransition(
                        opacity: _animation,
                        child: Hero(
                            tag: 'logo',
                            child: Image.asset('assets/images/logo.png'))),
                    height: 300.0,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: DelayedDisplay(
                      delay: Duration(seconds: 3),
                      child: Text(
                        'Forest Tracker',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

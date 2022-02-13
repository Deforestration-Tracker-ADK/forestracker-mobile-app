import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/user.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/data_layer/services/login_services.dart';
import 'package:forest_tracker/logic_layer/events/login_event.dart';
import 'package:forest_tracker/logic_layer/states/login_states.dart';

class LoginBloc extends Bloc<LoginEvents,LoginStates>{
  LoginBloc() : super(InitialState());

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async*{
    if(event is GetUser){
      yield* _loginUser(event);
    }
    else if(event is LoginCheck){
      yield* _loginCheck(event);
    }
    else if(event is LogoutUser){
      yield LogoutState();
    }
  }

  Stream<LoginStates> _loginUser(LoginEvents event) async* {
    if(event is GetUser){
      if(event.validPassword !=null || event.validEmail !=null){
        yield LoginWithInvalidCredentials();
      }
      else{
        yield LoginCredentialLoading();
        User user = await getUser(event.email,event.password);
        if (user !=null){
          yield LoginWithCorrectCredentials();
        }
        else {yield LoginWithInvalidCredentials(errorMsg: "Invalid username or password");}
      }
      // else{
      //   yield LoginCredentialLoading();
      //   final response = await LoginAPI.getUser(email: event.email, password: event.password);
      //   if (response.containsKey('data')) {
      //     await Authentication.setToken('email', event.email);
      //     await Authentication.setToken('password', event.password);
      //     await Authentication.setToken('token', response['data']['token']);
      //     await Authentication.setToken('id', response['data']['id'].toString());
      //     yield LoginWithCorrectCredentials();
      //   } else if (response.containsKey('error')) {
      //     yield LoginWithInvalidCredentials(errorMsg: response['error']['detail']);
      //   }
      // }
    }
  }

  Stream<LoginStates> _loginCheck(LoginEvents events) async*{
    final token = await Authentication.getToken("token");
    final userId = await Authentication.getToken("id");
    await Future.delayed(Duration(seconds: 5));
    // final response = await LoginAPI.logInCheck(id: userId, token: token);
    // if (response == '201') {
    //   yield LoginWithCorrectCredentials();
    // } else {
    //   yield LoginWithInvalidCredentials(errorMsg: response['error']['detail']);
    // }

    if (token == "user") {
      yield LoginWithCorrectCredentials();
    } else {
      yield LoginWithInvalidCredentials();
    }

  }

  Future<User> getUser(String email, String password) async{
    var user = ['username', 'Avi123@'];
    if(user.contains(email) && user.contains(password)){
      Authentication.setToken("token", 'user');
      Authentication.setToken("userID", '1');
      await Future.delayed(Duration(seconds: 3));
      return User(email: email,password: password);
    }
    return null;
  }

}


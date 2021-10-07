import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/user.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/logic_layer/Events/login_event.dart';
import 'package:forest_tracker/logic_layer/states/login_states.dart';

class LoginBloc extends Bloc<LoginEvents,LoginStates>{
  LoginBloc() : super(InitialState());

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async*{
    if(event is GetUser){
      if(event.validPassword !=null || event.validEmail !=null){
        yield LoginWithInvalidCredentials();
      }
      else{
        yield LoginCredentialLoading();
        User user = await getUser(event.email,event.password);
        if (user !=null){
          yield LoginWithCorrectCredentials(user: user);
        }
        else {yield LoginWithInvalidCredentials(errorMsg: "Invalid username or password");}
      }
    }
    else if(event is LogoutUser){
      yield LogoutState();
    }
  }

  Future<User> getUser(String email, String password) async{
    var user = ['username', '123456'];
    if(user.contains(email) && user.contains(password)){
      Authentication.setToken("token", 'user'); //until connecting to real api
      Authentication.setToken("userID", '1');
      await Future.delayed(Duration(seconds: 3));
      return User(email: email,password: password);
    }
    return null;

    // var apiData = LoginAPI(email: email, password: password);
    // var user1 = await apiData.getUser();
  }

}


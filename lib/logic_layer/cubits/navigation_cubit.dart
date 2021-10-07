import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/states/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationStates> {
  NavigationCubit() : super(NavigationStates(index: 0));

  void navigate(int value) =>emit(NavigationStates(index: value));

}

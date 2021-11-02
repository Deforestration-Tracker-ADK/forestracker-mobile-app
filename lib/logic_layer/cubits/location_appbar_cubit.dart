import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/states/location_appbar_states.dart';

class LocationAppBarCubit extends Cubit<LocationAppBarStates> {
  LocationAppBarCubit() : super(LocationAppBarStates(isSearched: false));

  void isSearched(bool isTap) =>emit(LocationAppBarStates(isSearched: isTap));

}
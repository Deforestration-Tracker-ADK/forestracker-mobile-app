import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/states/selected_location_state.dart';

class SelectLocationCubit extends Cubit<SelectLocationStates> {
  SearchPlaces searchPlaces;
  SelectLocationCubit({this.searchPlaces}) : super(LoadingState());

  void getLocationName(double lat,double lng) async{
    emit(LoadingState());
    String coordinates = '$lat,$lng';
    var response = await searchPlaces.selectedLocation(lat, lng);
    print(response);
    if(response != null) {
      emit(SelectedPlace(place: response.locationName));
    }
    else{
      emit(SelectedPlace(place:coordinates));
    }

  }

}
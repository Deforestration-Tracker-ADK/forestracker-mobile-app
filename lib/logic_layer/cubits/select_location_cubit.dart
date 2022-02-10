import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/states/selected_location_state.dart';

class SelectLocationCubit extends Cubit<SelectLocationStates> {
  SearchPlaces searchPlaces;
  SelectLocationCubit({this.searchPlaces}) : super(LoadingState());

  void getLocationName(double lat,double lng) async{
    emit(LoadingState());
    var response = await searchPlaces.selectedLocation(lat, lng);
    if(response != null) {
      emit(SelectedPlace(place: response.locationName,lat: lat,lon: lng));
    }
    else{
      String coordinates = '$lat,$lng';
      emit(SelectedPlace(place:coordinates,lat: lat,lon: lng));
    }

  }

}
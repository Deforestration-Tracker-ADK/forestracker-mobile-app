import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/events/map_event.dart';
import 'package:forest_tracker/logic_layer/states/map_state.dart';

class MapBloc extends Bloc<MapEvents,MapStates>{
  final GeoLocator geoLocator;
  final SearchPlaces searchPlaces;

  MapBloc({this.geoLocator,this.searchPlaces}) : super(MapLoading());

  @override
  Stream<MapStates> mapEventToState(MapEvents event) async*{
    if(event is GetCurrentLocation){
      yield* _getCurrentLocation();
    }
    if(event is SelectPlace){
      yield* _getSearchedLocation(event);
    }
  }

  Stream<MapStates> _getCurrentLocation() async*{
    yield MapLoading();
    Location location = await geoLocator.getCurrentLocation();
    yield CurrentLocation(location: location);
  }

  Stream<MapStates> _getSearchedLocation(SelectPlace event) async*{
    SearchedPlace searchedPlace = await searchPlaces.searchPlace(event.placeId);
    yield SelectedPlace(location: searchedPlace.geometry.location);
  }

}
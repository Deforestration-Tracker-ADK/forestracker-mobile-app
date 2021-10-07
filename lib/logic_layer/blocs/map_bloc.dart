import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:forest_tracker/data_layer/services/location_service.dart';
import 'package:forest_tracker/logic_layer/events/map_event.dart';
import 'package:forest_tracker/logic_layer/states/map_state.dart';

class MapBloc extends Bloc<MapEvents,MapStates>{
  final GeoLocator geoLocator;
  final SearchPlaces searchPlaces = SearchPlaces();

  MapBloc({this.geoLocator}) : super(MapLoading());

  @override
  Stream<MapStates> mapEventToState(MapEvents event) async*{
    if(event is GetCurrentLocation){
      yield* _getCurrentLocation();
    }
    if(event is SearchPlace){
      yield* getSearchPlaces(event);
    }
  }

  Stream<MapStates> _getCurrentLocation() async*{
    yield MapLoading();
    Location location = await geoLocator.getCurrentLocation();
    yield CurrentLocation(latitude: location.latitude,longitude: location.longitude);
  }

  Stream<MapStates> getSearchPlaces(SearchPlace event) async*{
    yield ResultLoading();
    List<Place> places = await searchPlaces.getSearchedPlaces(event.place);
    yield SearchedPlaces(places: places);

  }

}
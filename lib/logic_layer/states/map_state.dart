import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/map.dart';

abstract class MapStates extends Equatable{
  final Location location;
  MapStates({this.location});
}

class MapLoading extends MapStates{
  @override
  List<Object> get props => const [];
}

class ResultLoading extends MapStates{
  @override
  List<Object> get props => const [];
}

class CurrentLocation extends MapStates{
  final Location location;

  CurrentLocation({this.location}):
        super(location: location);

  @override
  List<Location> get props => [location];

}

class SearchedPlaces extends MapStates{
  final List<Place> places;

  SearchedPlaces({this.places});

  @override
  List<Place> get props => places;
}

class SelectedPlace extends MapStates{
  final Location location;
  SelectedPlace({this.location}):
      super(location: location);

  @override
  List<Location> get props => [location];
}


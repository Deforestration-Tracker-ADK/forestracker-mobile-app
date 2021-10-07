import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/map.dart';

abstract class MapStates extends Equatable{

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
  final double latitude;
  final double longitude;

  CurrentLocation({this.latitude, this.longitude});

  @override
  List<double> get props => [latitude,longitude];

}

class SearchedPlaces extends MapStates{
  final List<Place> places;

  SearchedPlaces({this.places});

  @override
  List<Place> get props => places;
}


import 'package:equatable/equatable.dart';

abstract class SelectLocationStates extends Equatable{
  final String place;
  final double lat;
  final double lon;

  SelectLocationStates({this.place, this.lat, this.lon});
}

class LoadingState extends SelectLocationStates{
  @override
  List<Object> get props => [];
}

class SelectedPlace extends SelectLocationStates{
  final String place;
  final double lat;
  final double lon;

  SelectedPlace({this.place,this.lat,this.lon});

  @override
  List<Object> get props => [place,lat,lon];
}
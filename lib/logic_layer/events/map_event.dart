import 'package:equatable/equatable.dart';

abstract class MapEvents extends Equatable{
}

class GetCurrentLocation extends MapEvents{
  @override
  List<Object> get props => const [];
}

class SearchPlace extends MapEvents{
  final String place;
  SearchPlace({this.place});

  @override
  List<Object> get props => [place];

}

class SelectPlace extends MapEvents{
  final String placeId;
  SelectPlace({this.placeId});
  @override
  List<Object> get props => [placeId];

}
class Dismiss extends MapEvents{
  @override
  List<Object> get props => const [];
}
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
class Dismiss extends MapEvents{
  @override
  List<Object> get props => const [];
}
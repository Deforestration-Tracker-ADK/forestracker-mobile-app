import 'package:equatable/equatable.dart';

class LocationAppBarStates extends Equatable{
  final bool isSearched;

  LocationAppBarStates({this.isSearched});
  @override
  List<bool> get props => [isSearched];

}
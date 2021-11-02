import 'package:equatable/equatable.dart';

abstract class SelectLocationStates extends Equatable{
  final String place='';
}

class LoadingState extends SelectLocationStates{
  @override
  List<Object> get props => [];
}

class SelectedPlace extends SelectLocationStates{
  final String place;

  SelectedPlace({this.place});

  @override
  List<String> get props => [place];
}
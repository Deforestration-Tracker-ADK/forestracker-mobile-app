import 'package:equatable/equatable.dart';

abstract class MultiChoicesState extends Equatable{
  final List<bool> choices=[];
}

class Initial extends MultiChoicesState{
  @override
  List<Object> get props => [];
}

class TappedChoice extends MultiChoicesState{
  final List<bool> choices;
  TappedChoice({this.choices});
  @override
  List<bool> get props => this.choices;
}
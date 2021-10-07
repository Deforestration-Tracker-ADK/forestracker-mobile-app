import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class NavigationStates extends Equatable{
  final int index;
  NavigationStates({this.index});

  @override
  List<Object> get props => [this.index];
}

import 'package:equatable/equatable.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class MultipleChoices extends Equatable{
  final List<bool> _choices = List.filled(reasons.length, false);

  List<bool> get choices => this._choices;

  void updateValue(int index,bool value){
    this._choices[index] = value;
  }

  @override
  List<bool> get props => _choices;

}
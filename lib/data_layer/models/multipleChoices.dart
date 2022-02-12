import 'package:equatable/equatable.dart';

class MultipleChoices extends Equatable {
  final bool choice;

  MultipleChoices({this.choice});

  @override
  List<bool> get props => [choice];

  factory MultipleChoices.fromJson(Map<String, dynamic> jsonData) {
    return MultipleChoices(choice: jsonData['choice'] as bool);
  }

  Map<String, dynamic> toJson() => {'choice': this.choice};
}
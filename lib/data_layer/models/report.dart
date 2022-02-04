import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/images.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class CreateReport extends Equatable{
  final String name;
  final String location;
  final int radioValue;
  final List<bool> choices;
  final String description;
  final Images images;

  CreateReport({this.name, this.location, this.radioValue, this.choices, this.description, this.images});

  @override
  List<Object> get props => [name,location,radioValue,choices,description,images];

  factory CreateReport.fromJson(Map<String,dynamic> jsonData){
    return CreateReport(
      name: jsonData['name'] as String,
      location: jsonData['location'] as String,
      radioValue: jsonData['radioValue'] as int,
      choices: jsonData['choices'] as List<bool>,
      description: jsonData['description'] as String,
      images: Images.fromJson(jsonData['images'])
    );
  }

}

class MultipleChoices extends Equatable{
  List<bool> _choices = List.filled(reasons.length, false);

  List<bool> get multiChoices => this._choices;

  void updateValue(int index,bool value){
    this._choices[index] = value;
  }

  @override
  List<bool> get props => _choices;

}
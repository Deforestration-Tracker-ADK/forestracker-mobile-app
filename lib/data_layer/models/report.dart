
import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/images.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class Report extends Equatable{
  final String name;
  final String location;
  final String radioValue;
  final List<String> choices;
  final String description;
  final Images images;

  Report({this.name, this.location, this.radioValue, this.choices, this.description, this.images});

  @override
  List<Object> get props => [name,location,radioValue,choices,description,images];

  factory Report.fromJson(Map<String,dynamic> jsonData){
    return Report(
      name: jsonData['name'] as String,
      location: jsonData['location'] as String,
      radioValue: jsonData['radioValue'] as String,
      choices: jsonData['choices'] as List<String>,
      description: jsonData['description'] as String,
      images: Images.fromJson(jsonData['images'])
    );
  }

  Map<String,dynamic> toJson ()=>{
    'name':this.name,
    'location':this.location,
    'radioValue' : this.radioValue,
    'choices' : this.choices,
    'description' : this.description,
    'images' : this.images.toJson()
  };



}

class MultipleChoices extends Equatable{
  List<bool> _choices = List.filled(reasons.length, false);

  List<bool> get multiChoices => this._choices;

  void updateValue(int index,bool value){
    this._choices[index] = value;
  }

  void clearValues() {
    this._choices = List.filled(reasons.length, false);
  }

  List<String> convertToStringList(){
    return _choices.map((element)=> element? "true":"false").toList();
  }

  List<bool> convertToBoolList(List<String> list){
    _choices = list.map((element)=> element=="true"?true:false).toList();
    return _choices;
  }

  @override
  List<bool> get props => _choices;

}
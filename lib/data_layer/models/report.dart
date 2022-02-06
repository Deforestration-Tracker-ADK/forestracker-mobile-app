import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/images.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';

class Report extends Equatable{
  String name;
  String location;
  String radioValue;
  List<MultipleChoices> choices;
  String description;
  List<Images> imagesPath;
  String dateTime;

  Report({this.name, this.location, this.radioValue, this.choices, this.description, this.imagesPath,this.dateTime});

  Report copyWith({String name,String location,String radioValue,List<MultipleChoices> choices,String description,List<Images> imagesPath}){
    return Report(
      name: this.name??name,
      location: this.location??location,
      radioValue: this.radioValue??radioValue,
      choices: this.choices??choices,
      description: this.description??description,
      imagesPath: this.imagesPath??imagesPath,
      dateTime: this.dateTime
    );
  }

  @override
  List<Object> get props => [name,location,radioValue,choices,description,imagesPath];

  factory Report.fromJson(Map<String,dynamic> jsonData){
    var list1 = jsonData["images"] as List;
    List<Images> images = list1.map((image) => Images.fromJson(image)).toList();

    var list2 = jsonData["choices"] as List;
    List<MultipleChoices> choices = list2.map((choice) => MultipleChoices.fromJson(choice)).toList();
    return Report(
      name: jsonData['name'] as String,
      location: jsonData['location'] as String,
      radioValue: jsonData['radioValue'] as String,
      choices: choices,
      description: jsonData['description'] as String,
      imagesPath: images,
      dateTime: jsonData['date'] as String
    );
  }

  Map<String,dynamic> toJson ()=>{

    'name':this.name,
    'location':this.location,
    'radioValue' : this.radioValue,
    'choices' : this.choices.map((choice) => MultipleChoices(choice: choice.choice).toJson()).toList(),
    'description' : this.description,
    'images' : this.imagesPath.map((image) => Images(imagePath: image.imagePath).toJson()).toList(),
    'date' :this.dateTime
  };

  void addImage(XFile imageFile){
    this.imagesPath.add(Images(imagePath: imageFile.path));
    print("successfully added");
  }

  void addImages(List<String> imageFiles){
    List<Images> images = imageFiles.map((filePath) => Images(imagePath: filePath)).toList();
    this.imagesPath.addAll(images);
    print("successfully added all");
  }

  List<String> getImages(){
    List<String> imagesPath = this.imagesPath.map((image) => image.imagePath).toList();
    return imagesPath;
  }

  void deleteImage(int index){
    this.imagesPath.removeAt(index);
    print("Successfully deleted");
  }

  void updateList(int index){
    this.imagesPath.removeRange(index, imagesPath.length);
  }

  void clearList(){
    this.imagesPath.clear();
  }

  void updateValue(int index,bool value){
    this.choices[index] = MultipleChoices(choice: value);
  }

  List<bool> getChoiceList(){
    return this.choices.map((choice) => choice.choice).toList();
  }

  void clearValues() {
    //.clear() cannot be used since size of choice is fixed
    this.choices = List.filled(reasons.length, MultipleChoices(choice: false));
  }
}

class MultipleChoices extends Equatable{
  final bool choice;

  MultipleChoices({this.choice});

  @override
  List<bool> get props => [choice];

  factory MultipleChoices.fromJson(Map<String,dynamic> jsonData){
    return MultipleChoices(
        choice: jsonData['choice'] as bool);
  }

  Map<String,dynamic> toJson() => {
    'choice' : this.choice
  };

  // List<String> convertToStringList(){
  //   return _choices.map((element)=> element? "true":"false").toList();
  // }
  //
  // List<bool> convertToBoolList(List<String> list){
  //   _choices = list.map((element)=> element=="true"?true:false).toList();
  //   return _choices;
  // }

}
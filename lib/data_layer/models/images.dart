import 'package:equatable/equatable.dart';

class Images extends Equatable{
  final String imagePath;

  Images({this.imagePath});

  @override
  List<String> get props => [imagePath];

  factory Images.fromJson(Map<String,dynamic> jsonData){
    return Images(
        imagePath: jsonData['image'] as String);
  }

  Map<String,dynamic> toJson() => {
    'image' : this.imagePath
  };

}
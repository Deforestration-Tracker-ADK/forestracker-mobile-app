import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class Images extends Equatable{
  final List<String> images;

  Images({this.images});

  @override
  List<Object> get props => [images];

  factory Images.fromJson(Map<String,dynamic> jsonData){
    return Images(
        images: jsonData['images'] as List<String>);
  }

  Map<String,dynamic> toJson() => {
    'images' : this.images
  };

  void addImage(XFile imageFile){
    images.add(imageFile.path);
    print("successfully added");
  }

  void addImages(List<String> imageFiles){
    images.addAll(imageFiles);
    print("successfully added all");
  }

  List<String> getImages(){
    return images;
  }

  void deleteImage(int index){
    images.removeAt(index);
    print("Success fully deleted");
  }

  void updateList(int index){
    images.removeRange(index, images.length);
  }

  void clearList(){
    images.clear();
  }

}
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class Images extends Equatable{
  final List<XFile> images;

  Images({this.images});

  @override
  List<Object> get props => [images];

  factory Images.fromJson(Map<String,dynamic> jsonData){
    return Images(
        images: jsonData['images'] as List<XFile>);
  }

  void addImage(XFile imageFile){
    images.add(imageFile);
    print("successfully added");
  }

  void addImages(List<XFile> imageFiles){
    images.addAll(imageFiles);
    print("successfully added all");
  }

  List<XFile> getImages(){
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
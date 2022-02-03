import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagesEvent extends Equatable{
  final List<XFile> images;
  ImagesEvent({this.images});
}

class AddImagesEvent extends ImagesEvent{
  @override
  List<Object> get props => [];

}

class SelectImagesEvent extends ImagesEvent{
  SelectImagesEvent(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class DeleteImageEvent extends ImagesEvent{
  final int imageId;
  DeleteImageEvent({this.imageId}) ;

  @override
  List<Object> get props => [imageId];

}

class RemoveImagesEvent extends ImagesEvent{
  @override
  List<Object> get props => [];

}
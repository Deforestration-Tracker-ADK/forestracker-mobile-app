
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImagesState extends Equatable{
  final List<XFile> images;
  ImagesState({this.images});
}

class ImageLoading extends ImagesState{
  @override
  List<Object> get props => [];

}

class AddImages extends ImagesState{
  AddImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];

}

class SelectImages extends ImagesState{
  SelectImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class SelectMaxImages extends ImagesState{
  SelectMaxImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class DeleteImage extends ImagesState{
  DeleteImage(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];

}
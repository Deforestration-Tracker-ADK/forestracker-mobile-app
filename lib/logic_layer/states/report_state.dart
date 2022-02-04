
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ReportState extends Equatable{
  final int value;
  final List<XFile> images;
  final List<bool> choices;
  ReportState({this.choices,this.images,this.value});
}

class MultiChoiceLoading extends ReportState{
  @override
  List<Object> get props => [];
}

class MultipleChoice extends ReportState{
  final List<bool> choices;
  MultipleChoice({this.choices});

  @override
  List<Object> get props => choices;
}


class TapedLoading extends ReportState{
  @override
  List<Object> get props => [];
}

class TappedChoice extends ReportState{
  final int value;
  TappedChoice({this.value});
  @override
  List<Object> get props => [value];
}

class ImageLoading extends ReportState{
  @override
  List<Object> get props => [];
}

class AddImages extends ReportState{
  AddImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];

}

class SelectImages extends ReportState{
  SelectImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class SelectMaxImages extends ReportState{
  SelectMaxImages(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class DeleteImage extends ReportState{
  DeleteImage(List<XFile> images) : super(images: images);
  @override
  List<Object> get props => [images];

}

class Error extends ReportState{
  final String error;

  Error({this.error});

  @override
  List<Object> get props => [error];

}

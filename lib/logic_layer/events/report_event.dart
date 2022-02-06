import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/report.dart';

abstract class ReportEvent extends Equatable{
  final List<String> images;
  ReportEvent({this.images});
}

class ReportInitialEvent extends ReportEvent{
  final Report report;

  ReportInitialEvent({this.report});

  @override
  List<Report> get props => [report];

}

class RadioButtonEvent extends ReportEvent{
  final int value;

  RadioButtonEvent({this.value});

  @override
  List<Object> get props => [value];
}

class MultiChoiceEvent extends ReportEvent{
  final int index;
  final bool tapped;

  MultiChoiceEvent({this.index, this.tapped});

  @override
  List<Object> get props => [index,tapped];
}

class DescriptionEvent extends ReportEvent{
  final String description;

  DescriptionEvent(this.description);

  @override
  List<Object> get props => [description];


}

class AddImagesEvent extends ReportEvent{
  @override
  List<Object> get props => [];

}

class SelectImagesEvent extends ReportEvent{
  SelectImagesEvent(List<String> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class DeleteImageEvent extends ReportEvent{
  final int imageId;
  DeleteImageEvent({this.imageId}) ;

  @override
  List<Object> get props => [imageId];

}

class RemoveImagesEvent extends ReportEvent{
  @override
  List<Object> get props => [];

}

class ClearDataEvent extends ReportEvent{
  @override
  List<Object> get props => [];
}

class DraftSavingEvent extends ReportEvent{
  final String location;
  final String date;

  DraftSavingEvent({this.location,this.date});
  @override
  List<Object> get props => [location];
}

class SaveDraftEvent extends ReportEvent{
  @override
  List<Object> get props => [];

}

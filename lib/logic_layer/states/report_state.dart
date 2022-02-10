
import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/report.dart';

abstract class ReportState extends Equatable{
  final int value = 0;
  final List<String> images;
  final List<bool> choices;
  final String warning;
  ReportState({this.choices,this.images,this.warning});
}


class Loading extends ReportState{
  @override
  List<Object> get props => [];

}

class InvalidReportName extends ReportState{
  final String warning;

  InvalidReportName({this.warning}):super(warning: warning);

  @override
  List<String> get props => [warning];

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
  AddImages(List<String> images) : super(images: images);
  @override
  List<Object> get props => [images];

}

class SelectImages extends ReportState{
  SelectImages(List<String> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class SelectMaxImages extends ReportState{
  SelectMaxImages(List<String> images) : super(images: images);
  @override
  List<Object> get props => [images];
}

class DeleteImage extends ReportState{
  DeleteImage(List<String> images) : super(images: images);
  @override
  List<Object> get props => [images];

}

class DraftSaving extends ReportState{
  @override
  List<Object> get props => [];
}

class DraftSaved extends ReportState{
  final Report draftReport;

  DraftSaved({this.draftReport});

  @override
  List<Object> get props => [draftReport];
}

class LoadingEdit extends ReportState{
  @override
  List<Object> get props => [];

}

class EditLoaded extends ReportState{
  final String reportName;

  EditLoaded({this.reportName});
  @override
  List<String> get props => [reportName];

}

class Error extends ReportState{
  final String error;

  Error({this.error});

  @override
  List<Object> get props => [error];

}


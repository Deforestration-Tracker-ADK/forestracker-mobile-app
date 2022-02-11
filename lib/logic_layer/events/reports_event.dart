import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable{
  final String reportName;

  ReportsEvent({this.reportName});
}

class LoadDraftReports extends ReportsEvent {
  @override
  List<Object> get props => [];
}

class EditReport extends ReportsEvent {
  EditReport({String reportName}) : super(reportName: reportName);

  EditReport copyWith({String reportName}){
    return EditReport(reportName: reportName??this.reportName);
  }

  @override
  List<String> get props => [reportName];
}

class LoadingEditEvent extends ReportsEvent{
  @override
  List<Object> get props => [];

}

class DeleteDraftReport extends ReportsEvent{
  final String reportName;

  DeleteDraftReport({this.reportName});

  @override
  List<String> get props => [reportName];

}

class LoadSendReports extends ReportsEvent {
  @override
  List<Object> get props => [];
}

class DeleteSendReport extends ReportsEvent{
  final String reportName;

  DeleteSendReport({this.reportName});

  @override
  List<String> get props => [reportName];

}

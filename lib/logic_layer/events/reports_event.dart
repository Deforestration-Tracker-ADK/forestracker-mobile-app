import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable{
  final String reportName;

  ReportsEvent({this.reportName});
}

class LoadReports extends ReportsEvent {
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

class DeleteReport extends ReportsEvent{
  final String reportName;

  DeleteReport({this.reportName});

  @override
  List<String> get props => [reportName];

}

class GetAllSendReports extends ReportsEvent {
  @override
  List<Object> get props =>[];
}


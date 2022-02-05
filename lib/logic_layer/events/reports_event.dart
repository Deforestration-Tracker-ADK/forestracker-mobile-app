import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable{
  final int reportId;

  ReportsEvent({this.reportId});
}

class LoadProjects extends ReportsEvent {
  @override
  List<Object> get props => [];
}

class EditReport extends ReportsEvent {
  EditReport({int reportId}) : super(reportId: reportId);

  EditReport copyWith({int reportId}){
    return EditReport(reportId: reportId??this.reportId);
  }

  @override
  List<int> get props => [reportId];
}

class GetAllSendReports extends ReportsEvent {
  @override
  List<Object> get props =>[];
}


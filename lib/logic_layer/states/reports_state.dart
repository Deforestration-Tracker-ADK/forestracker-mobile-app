import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/report.dart';

abstract class ReportsState extends Equatable{
}

class ReportsLoading extends ReportsState{
  @override
  List<Object> get props => [];
}

class SendReportsLoading extends ReportsState{
  @override
  List<Object> get props => [];
}

class ReportsLoaded extends ReportsState{
  final List<Report> reports;
  ReportsLoaded({this.reports});

  ReportsLoaded copyWith({List<Report> reports}){
    return ReportsLoaded(
      reports: reports ?? this.reports,
    );
  }

  @override
  List<Report> get props => reports;
}

class EditReportLoading extends ReportsState{
  @override
  List<Object> get props => [];

}

class SendReportsLoaded extends ReportsState{
  final List<Report> reports;
  SendReportsLoaded({this.reports});

  SendReportsLoaded copyWith({List<Report> reports}){
    return SendReportsLoaded(
      reports: reports ?? this.reports,
    );
  }

  @override
  List<Report> get props => reports;
}


// class ProjectLoaded extends ReportsStates{
//   Project project;
//   bool applied;
//   ProjectLoaded({this.project,this.applied});
//
//   ProjectLoaded copyWith({Project project,bool applied}){
//     return ProjectLoaded(
//         project: project??this.project,
//         applied: applied??this.applied
//     );
//   }
// }

class ReportsErrors extends ReportsState{
  final String error;
  ReportsErrors({this.error});

  @override
  List<String> get props => [error];
}





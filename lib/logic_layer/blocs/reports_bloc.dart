import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/report_services.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent,ReportsState>{
  final ReportAPI _reportAPI = ReportAPI.getInstance();
  ReportsBloc() : super(ReportsLoading());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) async*{
    if(event is LoadReports){
      yield* _loadDraftReports(event);
    }
    if(event is DeleteReport){
      yield* _deleteReport(event);
    }



  }

  Stream<ReportsState> _loadDraftReports(ReportsEvent event) async*{
    yield ReportsLoading();
    var list = await _reportAPI.getDraftReports();
    //reversed to get the latest one first
    List<Report> draftReports = new List.from(list.reversed);
    await Future.delayed(Duration(milliseconds: 1000));
    yield ReportsLoaded(reports: draftReports);
  }

  Stream<ReportsState> _deleteReport(ReportsEvent event) async*{
    _reportAPI.deleteDraftReport(event.reportName);
    var list = await _reportAPI.getDraftReports();
    List<Report> draftReports = new List.from(list.reversed);
    yield ReportsLoaded(reports: draftReports);
  }

}
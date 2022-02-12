import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/report_services.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class ReportsBloc extends Bloc<ReportsEvent,ReportsState>{
  ReportsBloc() : super(ReportsLoading());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) async*{
    if(event is LoadDraftReports){
      yield* _loadDraftReports(event);
    }
    if(event is DeleteDraftReport){
      yield* _deleteReport(event);
    }

    if(event is LoadSendReports){
      yield* _loadSendReports(event);
    }
    if(event is DeleteSendReport){
      yield* _deleteSendReport(event);
    }
  }

  Stream<ReportsState> _loadDraftReports(ReportsEvent event) async*{
    yield ReportsLoading();
    var list = await ReportAPI.getDraftReports(Constant.DRAFT_REPORT);
    //reversed to get the latest one first
    List<Report> draftReports = new List.from(list.reversed);
    await Future.delayed(Duration(milliseconds: 1000));
    yield ReportsLoaded(reports: draftReports);
  }

  Stream<ReportsState> _deleteReport(ReportsEvent event) async*{
    ReportAPI.deleteReport(event.reportName,Constant.DRAFT_REPORT);
    var list = await ReportAPI.getDraftReports(Constant.DRAFT_REPORT);
    List<Report> draftReports = new List.from(list.reversed);
    yield ReportsLoaded(reports: draftReports);
  }

  Stream<ReportsState> _loadSendReports(ReportsEvent event) async*{
    yield SendReportsLoading();
    var list = await ReportAPI.getDraftReports(Constant.SEND_REPORT);
    //reversed to get the latest one first
    List<Report> sendReport = new List.from(list.reversed);
    await Future.delayed(Duration(milliseconds: 1000));
    yield SendReportsLoaded(reports: sendReport);

    // yield SendReportsLoading();
    // final token = await Authentication.getToken("token");
    // final userId = await Authentication.getToken("id");
    // var response = await ReportAPI.getAllSendReports(userId: userId, token: token);
    // if(response is String){
    //   yield SendReportsErrors(error: response);
    // }else{
    //   yield SendReportsLoaded(reports: response);
    // }

  }

  //Not a real functionality. Just for the local purpose only
  Stream<ReportsState> _deleteSendReport(ReportsEvent event) async*{
    ReportAPI.deleteReport(event.reportName,Constant.SEND_REPORT);
    var list = await ReportAPI.getDraftReports(Constant.SEND_REPORT);
    List<Report> draftReports = new List.from(list.reversed);
    yield SendReportsLoaded(reports: draftReports);
  }

}
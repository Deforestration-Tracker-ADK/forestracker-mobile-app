import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/map.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/data_layer/services/report_services.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation/report_creation_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  Report report = Report().copyWith(
      name: ReportCreationPage.reportNameController.value.text,
      radioValue: 0.toString(),
      choices: List.filled(Constant.REASONS.length, MultipleChoices(choice: false)),
      description: ReportCreationPage.descriptionController.value.text,
      imagesPath: List.empty(growable: true));

  ReportBloc() : super(Loading());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is RadioButtonEvent) {
      yield* _radioOption(event);
    }

    if (event is MultiChoiceEvent) {
      yield* _multiChoice(event);
    }

    if (event is SelectImagesEvent) {
      yield* _selectImages(event);
    }

    if (event is DeleteImageEvent) {
      yield* _deleteImages(event);
    }

    if (event is RemoveImagesEvent) {
      yield* _removeImages(event);
    }

    if (event is ClearDataEvent) {
      yield* _clearData(event);
    }

    if (event is DraftSavingEvent) {
      yield* _saveReport(event,Constant.DRAFT_REPORT,Constant.DRAFT_REPORT_LOADING);
    }

    if (event is ReportSendingEvent) {
      //yield* _sendReport(event, Constant.SEND_REPORT_LOADING);
      yield* _saveReport(event,Constant.SEND_REPORT,Constant.SEND_REPORT_LOADING);
    }

    if (event is EditEvent) {
      yield* _editReport(event);
    }
  }

  Stream<ReportState> _radioOption(RadioButtonEvent event) async* {
      yield TapedLoading();
      this.report.radioValue = event.value.toString();
      yield TappedChoice(value: event.value);
  }

  Stream<ReportState> _multiChoice(MultiChoiceEvent event) async* {
    yield MultiChoiceLoading();
    report.updateValue(event.index, event.tapped);
    yield MultipleChoice(choices: report.getChoiceList());
  }

  Stream<ReportState> _selectImages(SelectImagesEvent event) async* {
      yield ImageLoading();
      report.addImages(event.images);

      if (report.getImages().length > 5) {
        report.updateList(5);
        yield SelectMaxImages(report.getImages());
      } else {
        yield SelectImages(report.getImages());
      }
  }

  Stream<ReportState> _deleteImages(DeleteImageEvent event) async* {

      yield ImageLoading();
      report.deleteImage(event.imageId);
      yield DeleteImage(report.getImages());

  }

  Stream<ReportState> _removeImages(RemoveImagesEvent event) async* {
    try {
      report.clearList();
      yield SelectImages(report.getImages());
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _clearData(ReportEvent event) async* {
    try {
      report.clearList();
      ReportCreationPage.descriptionController.clear();
      ReportCreationPage.reportNameController.clear();
      report.clearValues();
      yield SelectImages(report.getImages());
      yield MultipleChoice(
        choices: List.filled(Constant.REASONS.length, false),
      );
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _editReport(EditEvent event) async* {
    report = event.report;
    ReportAPI.deleteReport(event.report.name,Constant.DRAFT_REPORT);
    yield LoadingEdit();
    ReportCreationPage.reportNameController.text = report.name;
    ReportCreationPage.descriptionController.text = report.description;
    yield TappedChoice(value: int.parse(report.radioValue));
    yield MultipleChoice(choices: report.getChoiceList());
    yield SelectImages(report.getImages());
    yield EditLoaded(reportName: report.name);
  }

  Stream<ReportState> _saveReport(ReportEvent event,String action,String message) async* {
    String reportName = ReportCreationPage.reportNameController.text;
    final Report report = _loadReport(event);
    yield PendingReport(message: message);
    if (reportName.trim().isNotEmpty) {
        try {
          //update report name to identify the draft reports and send reports in shared space
          final String key = action+reportName ;
          bool isAccepted = await ReportAPI.saveReport(key, report);
          await Future.delayed(Duration(milliseconds: 1500));
          if (isAccepted) {
            if(action == Constant.DRAFT_REPORT){
              yield DraftSaved(draftReport: report);
            }
            else{
              yield ReportSend(sendReport:report);
            }
          } else {
            yield Loading();
            yield InvalidReportName(warning: "Report Name has already used!");
          }
        } catch (e) {
          yield Error(error: e.toString());
        }
    } else {
      yield Loading();
      yield InvalidReportName(warning: "Report Name Can not be Empty!");
    }
  }

  Stream<ReportState> _sendReport(ReportEvent event,String message) async* {
    String reportName = ReportCreationPage.reportNameController.text;
    final Report report = _loadReport(event);
    yield PendingReport(message: message);
    if (reportName.trim().isNotEmpty) {
      final token = await Authentication.getToken("token");
      var response = await ReportAPI.createReport(report, token);
      if(response=='201'){
        yield ReportSend(sendReport:report);
      }
      else{
        yield Error(error: response);
      }
    } else {
      yield Loading();
      yield InvalidReportName(warning: "Report Name Can not be Empty!");
    }
  }



  Report _loadReport(ReportEvent event){
    return Report(
        name: ReportCreationPage.reportNameController.text.trim(),
        description: ReportCreationPage.descriptionController.text.trim(),
        location: Location(latitude: event.lat, longitude: event.lng),
        radioValue: this.report.radioValue,
        choices: this.report.choices,
        imagesPath: this.report.imagesPath,
        dateTime: event.date);
  }
}

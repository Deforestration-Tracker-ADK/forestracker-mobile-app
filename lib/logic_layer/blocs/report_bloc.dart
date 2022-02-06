import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class ReportBloc extends Bloc<ReportEvent,ReportState>{
  final Report report = Report().copyWith(
    name: ReportCreationPage.reportNameController.value.text,
    radioValue: 0.toString(),
    choices: List.filled(reasons.length, MultipleChoices(choice: false)),
    description: ReportCreationPage.descriptionController.value.text,
    imagesPath: List.empty(growable: true)
  );
  ReportBloc() : super(Loading());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async*{

    if (event is RadioButtonEvent) {
      yield* _radioOption(event);
    }

    if (event is MultiChoiceEvent){
      yield* _multiChoice(event);
    }

    if (event is SelectImagesEvent){
      yield* _selectImages(event);
    }

    if (event is DeleteImageEvent){
      yield* _deleteImages(event);
    }

    if( event is RemoveImagesEvent){
      yield* _removeImages(event);
    }

    if(event is ClearDataEvent){
      yield* _clearData(event);
    }

    if (event is DraftSavingEvent){
      yield* _saveDraftReport(event);
    }
  }

  Stream<ReportState> _radioOption(RadioButtonEvent event) async*{
    try{
      yield TapedLoading();
      this.report.radioValue = event.value.toString();
      yield TappedChoice(value: event.value);
    }
    catch (e){
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _multiChoice(MultiChoiceEvent event) async*{
    yield MultiChoiceLoading();
    report.updateValue(event.index, event.tapped);
    yield MultipleChoice(choices: report.getChoiceList());
  }

  Stream<ReportState> _selectImages(SelectImagesEvent event) async* {
    try {
      yield ImageLoading();
      report.addImages(event.images);

      if(report.getImages().length>5){
        report.updateList(5);
        yield SelectMaxImages(report.getImages());
      }
      else{
        yield SelectImages(report.getImages());
      }
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _deleteImages(DeleteImageEvent event) async* {
    try {
      yield ImageLoading();
      report.deleteImage(event.imageId);
      yield DeleteImage(report.getImages());
    } catch (e) {
      yield Error(error: e.toString());
    }
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
      yield MultipleChoice(choices: List.filled(reasons.length, false),);

    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _saveDraftReport(DraftSavingEvent event) async* {
    String reportName = ReportCreationPage.reportNameController.value.text;
    if(reportName.trim().isNotEmpty){
      var load = await Authentication.getToken(reportName);
      if(load == null){
        final Report draftReport = Report(
            name : ReportCreationPage.reportNameController.value.text,
            description  :ReportCreationPage.descriptionController.value.text,
            location:  event.location,
            radioValue:   this.report.radioValue,
            choices:  this.report.choices,
            imagesPath:   this.report.imagesPath,
            dateTime: event.date
        );

        try{
          yield DraftSaving();
          await Authentication.setToken(reportName, json.encode(draftReport.toJson()));
          await Future.delayed(Duration(milliseconds: 1500));
          yield DraftSaved(draftReport: draftReport);
          yield* _clearData(event);
        }
        catch(e){
          yield Error(error: e.toString());
        }
      }else{
        yield Loading();
        yield InvalidReportName(warning: "Report Name has already used!");
      }
    }
    else{
      yield Loading();
      yield InvalidReportName(warning: "Report Name Can not be Empty!");
    }

  }
}
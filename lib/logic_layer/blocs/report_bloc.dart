import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/images.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation_page.dart';

class ReportBloc extends Bloc<ReportEvent,ReportState>{
  String reportName = ReportCreationPage.reportNameController.value.text;
  String location;
  String description = ReportCreationPage.descriptionController.value.text;
  final Images images;
  final MultipleChoices multipleChoices;
  ReportBloc({this.multipleChoices, this.images}) : super(MultipleChoice(choices: multipleChoices.multiChoices));

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
  }

  Stream<ReportState> _radioOption(RadioButtonEvent event) async*{
    try{
      yield TapedLoading();
      yield TappedChoice(value: event.value);
    }
    catch (e){
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _multiChoice(MultiChoiceEvent event) async*{
    yield MultiChoiceLoading();
    multipleChoices.updateValue(event.index, event.tapped);
    yield MultipleChoice(choices: multipleChoices.multiChoices);
  }

  Stream<ReportState> _selectImages(SelectImagesEvent event) async* {
    try {
      yield ImageLoading();
      images.addImages(event.images);

      if(images.getImages().length>5){
        images.updateList(5);
        yield SelectMaxImages(images.getImages());
      }
      else{
        yield SelectImages(images.getImages());
      }
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _deleteImages(DeleteImageEvent event) async* {
    try {
      yield ImageLoading();
      images.deleteImage(event.imageId);
      yield DeleteImage(images.getImages());
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _removeImages(RemoveImagesEvent event) async* {
    try {
      images.clearList();
      yield SelectImages(images.getImages());
    } catch (e) {
      yield Error(error: e.toString());
    }
  }

  Stream<ReportState> _clearData(ClearDataEvent event) async* {
    try {
      images.clearList();
      multipleChoices.clearValues();
      ReportCreationPage.descriptionController.clear();
      ReportCreationPage.reportNameController.clear();
      yield SelectImages(images.getImages());
      yield MultipleChoice(choices: multipleChoices.multiChoices);

    } catch (e) {
      yield Error(error: e.toString());
    }
  }






}
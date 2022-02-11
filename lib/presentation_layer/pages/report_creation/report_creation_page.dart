import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/logic_layer/states/selected_location_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation/page_buttons/save_draft_button.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation/page_buttons/send_report_button.dart';
import 'package:forest_tracker/presentation_layer/utilities/components.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';
import 'package:intl/intl.dart';
import 'page_buttons/add_photo_button.dart';

class ReportCreationPage extends StatelessWidget {
  static const String id = 'report_page';
  static final reportNameController = TextEditingController();
  static final descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> arguments = ModalRoute.of(context).settings.arguments ;
    bool isCreated = arguments['isCreated'] as bool;
    Report report = arguments['report'] as Report;
    String draftButtonText = isCreated?'Save Draft':'Update Draft';

    if(!isCreated){
      context.read<SelectLocationCubit>().getLocationName(report.location.latitude,report.location.longitude);
      context.read<ReportBloc>().add(EditEvent(report: report));
    }
    return WillPopScope(
      onWillPop: ()=>isCreated? willPopUpReportCreateSelection(context):willPopUpReportEditSelection(context, report),
      //to hide the keyboard when touch the screen
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.greenAccent,
          appBar: AppBar(
            title: isCreated?Text('Create Report'):Text('Edit Report'),
          ),
          body: BlocListener<ReportBloc,ReportState>(
            listener: (context,state){
              if(state is LoadingEdit){
                dialogMsg(context, "Please wait..!!");
              }
              if(state is EditLoaded){
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.greenAccent.shade100,
                elevation: 5,
                shadowColor: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView(
                    children: [
                      descriptionTile('1. ', 'Report Name :'),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: reportNameController,
                          maxLines: double.maxFinite.toInt(),
                          minLines: 1,
                          textAlignVertical: TextAlignVertical.top,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Enter Report Name...',
                              hintStyle: TextFontDecoration.copyWith(
                                  fontStyle: FontStyle.italic, color: Colors.grey)),
                          style: TextFontDecoration,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      descriptionTile('2. ', 'Location : '),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                        child: Builder(builder: (context) {
                          final locationCubit =
                              context.watch<SelectLocationCubit>().state;
                          if (locationCubit is LoadingState) {
                            return Center(
                              child: LinearProgressIndicator(),
                            );
                          } else {
                            return Text(
                              locationCubit.place,
                              style: TextFontDecoration,
                              maxLines: double.maxFinite.toInt(),
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      descriptionTile('3. ', 'Do you suspect any deforestation activities in above area ?'),
                      radioButton('Yes', 0),
                      radioButton('No', 1),
                      SizedBox(
                        height: 15,
                      ),
                      descriptionTile('4. ', 'Any suspicious reasons ?'),
                      BlocBuilder<ReportBloc, ReportState>(
                          buildWhen: (prevState, state) {
                        if (state is MultipleChoice) {
                          return true;
                        }
                        return false;
                      }, builder: (context, state) {
                        List<bool> choiceState = context.watch<ReportBloc>().report.getChoiceList();
                        return Column(
                            children: Constant.REASONS
                                .map((reason) => multipleChoices(
                                    reason,
                                    choiceState[Constant.REASONS.indexOf(reason)],
                                    Constant.REASONS.indexOf(reason),
                                    context))
                                .toList());
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      descriptionTile('5. ', 'Description (Optional) : '),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10),
                        child: TextField(
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: double.maxFinite.toInt(),
                          minLines: 1,
                          textAlignVertical: TextAlignVertical.top,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'Type here...',
                              hintStyle: TextFontDecoration.copyWith(
                                  fontStyle: FontStyle.italic, color: Colors.grey)),
                          style: TextFontDecoration,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      AddPhotosButton(color: Colors.grey),
                      SizedBox(
                        height: 15,
                      ),
                      SaveDraftButton(color: Colors.lightGreen,
                        text: draftButtonText),
                      SizedBox(
                        height: 8,
                      ),
                      SendReportButton(color: Colors.red,text: 'Send Report'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> willPopUpReportCreateSelection(BuildContext context) async{
    bool willLeave = false;
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: Center(child: Text('Are You Sure?')),
              content:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Your Entered Data Will Be Cleared !!",style: TextFontDecoration.copyWith(fontSize: 15),),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customButton(
                          elevation: 2.0,
                          color: Colors.red,
                          text: 'OK',
                          onPressed: () {
                            willLeave = true;
                            context.read<ReportBloc>().add(ClearDataEvent());
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: customButton(
                          elevation: 2.0,
                          color: Colors.lightBlue,
                          text: 'Cancel',
                          onPressed:  () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              elevation: 3,
              scrollable: true,
              actionsAlignment: MainAxisAlignment.center,
            ));
    return willLeave;
  }
  Future<bool> willPopUpReportEditSelection(BuildContext context,Report report) async{
    bool willPop =false;
    final bloc = BlocProvider.of<ReportBloc>(context,listen: false);
    String date = DateFormat("yyyy.MM.dd ':' hh:mm aaa").format(DateTime.now());
    bloc.add(DraftSavingEvent(lat:report.location.latitude, lng:report.location.longitude,date: date));

    //do not need to pop up or do anything
    //according to the state changes, save draft button class will react
    if(bloc.state is InvalidReportName) {
      willPop =false;
    }

    if(bloc.state is DraftSaved) {
      willPop =false;
    }
    return willPop;
  }

  ListTile radioButton(String text, int value) {
    return ListTile(
      title: Text(text),
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(vertical: -4, horizontal: -2),
      contentPadding: EdgeInsets.only(left: 5, top: 5),
      leading: BlocBuilder<ReportBloc,ReportState>(
        buildWhen: (prevState,state){
          if(state is TapedLoading || state is TappedChoice){
            return true;
          }
          return false;
        },
        builder: (context,state) {
          return Radio<int>(
            groupValue:  context.watch<ReportBloc>().report.getRadioValue(),
            value: value,
            onChanged: (value) {
                context.read<ReportBloc>().add(RadioButtonEvent(value: value));
            },
          );
        }
      ),
    );
  }

  ListTile multipleChoices(
      String option, bool value, int index, BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(vertical: -4, horizontal: -2),
      contentPadding: EdgeInsets.only(left: 5, top: 5),
      leading: Checkbox(
          value: value,
          onChanged: (value) {
            context.read<ReportBloc>().add(MultiChoiceEvent(index :index, tapped: value));
          }),
      title: Text(option),
    );
  }
}

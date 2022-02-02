import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/image_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/multi_choices_cubit.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/states/add_image_state.dart';
import 'package:forest_tracker/logic_layer/states/multi_choices_state.dart';
import 'package:forest_tracker/logic_layer/states/selected_location_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/components.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';
import 'add_photo_button.dart';

class ReportCreationPage extends StatefulWidget {
  static const String id = 'report_page';
  @override
  _ReportCreationPageState createState() => _ReportCreationPageState();
}

class _ReportCreationPageState extends State<ReportCreationPage> {
  int _groupValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text('Create Report'),
      ),
      body: Padding(
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
                descriptionTile('3. ',
                    'Do you suspect any deforestation activities in above area ?'),
                radioButton('Yes', 0),
                radioButton('No', 1),
                SizedBox(
                  height: 15,
                ),
                descriptionTile('4. ', 'Any suspicious reasons ?'),
                BlocBuilder<MultiChoicesCubit, MultiChoicesState>(
                    buildWhen: (prevState, state) {
                  if (state is TappedChoice) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
                  return Column(
                      children: reasons
                          .map((reason) => multipleChoices(
                              reason,
                              state.choices[reasons.indexOf(reason)],
                              reasons.indexOf(reason),
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
                BlocBuilder<ImagesBloc,ImagesState>(
                  buildWhen: (prevState,state){
                    if(state is AddImages ||state is SelectImages ||state is SelectMaxImages|| state is DeleteImage ){return true;}
                    return false;
                  },
                  builder: (context,state) {
                    return AddPhotosButton(
                      color: Colors.grey,
                      text: (state.images !=null && state.images.length!=0)?'+ Add Photos (${state.images.length})':'+ Add Photos',
                    );
                  }
                ),
                SizedBox(
                  height: 15,
                ),
                customButton(
                    color: Colors.lightGreen,
                    text: 'Save Draft',
                    onPressed: () {}),
                SizedBox(
                  height: 8,
                ),
                customButton(
                    color: Colors.red, text: 'Send Report', onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<dynamic> popUpSelection(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             backgroundColor: Colors.greenAccent,
  //             title: Center(child: Text('Select option')),
  //             content: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 IconButton(
  //                     onPressed: () {},
  //                     icon: Icon(
  //                       Icons.camera_alt,
  //                       size: 50,
  //                     )),
  //                 Spacer(),
  //                 IconButton(
  //                     onPressed: () {}, icon: Icon(Icons.photo, size: 50))
  //               ],
  //             ),
  //             elevation: 3,
  //             scrollable: true,
  //             actionsAlignment: MainAxisAlignment.center,
  //           ));
  // }

  ListTile radioButton(String text, int value) {
    return ListTile(
      title: Text(text),
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(vertical: -4, horizontal: -2),
      contentPadding: EdgeInsets.only(left: 5, top: 5),
      leading: Radio<int>(
        groupValue: _groupValue,
        value: value,
        onChanged: (value) {
          setState(() {
            _groupValue = value;
          });
        },
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
            context.read<MultiChoicesCubit>().onTap(index, value);
          }),
      title: Text(option),
    );
  }
}

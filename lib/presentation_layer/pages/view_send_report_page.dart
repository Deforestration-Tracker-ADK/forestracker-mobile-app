import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/states/selected_location_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/components.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class ReportReviewPage extends StatelessWidget {
  static const String id = 'review_page';
  Report report;

  @override
  Widget build(BuildContext context) {
    report = ModalRoute.of(context).settings.arguments as Report;
    context.read<SelectLocationCubit>().getLocationName(report.location.latitude,report.location.longitude);

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text('Send Report'),
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
                  child:
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        report.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:TextFontDecoration ,
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                descriptionTile('2. ', 'Location : '),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10),
                  child: Builder(builder: (context) {
                    final locationCubit = context.watch<SelectLocationCubit>().state;
                    if (locationCubit is LoadingState) {
                      return Center(
                        child: LinearProgressIndicator(),
                      );
                    } else {
                      return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            locationCubit.place,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:TextFontDecoration ,
                          ));
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
                Column(
                      children: Constant.REASONS
                          .map((reason) => multipleChoices(
                          reason,
                        report.choices[Constant.REASONS.indexOf(reason)].choice,
                          Constant.REASONS.indexOf(reason),
                          ))
                          .toList()),
                SizedBox(
                  height: 15,
                ),
                descriptionTile('5. ', 'Description (Optional) : '),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10),
                  child:
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        report.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextFontDecoration,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                customButton(
                    text: "View Images",
                    color: Colors.blueGrey,
                    onPressed: ()=>gridView(context)
                ),

                SizedBox(
                  height: 15,
                ),
                customButton(
                  text: "Finish Review",
                  color: Colors.blue,
                  onPressed: ()=>Navigator.pop(context)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> gridView(BuildContext context) {
    var len = report.imagesPath.length;
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        title: Center(
          child: Text(
            'Images',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        content: len==0?Text("No Images Selected!!"):Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey,width: 2)),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: SingleChildScrollView(
                        child: GridView.builder(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                            itemCount: len,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(report.imagesPath.map((image) => image.imagePath).toList()[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  )
                              );
                            })
                    )
                )));
              }

  ListTile radioButton(String text, int value) {
    return ListTile(
      title: Text(text),
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(vertical: -4, horizontal: -2),
      contentPadding: EdgeInsets.only(left: 5, top: 5),
      leading: Radio<int>(
              groupValue: int.parse(report.radioValue) ,
              value: value,
            )

      );
  }

  ListTile multipleChoices(
      String option, bool value, int index) {
    return ListTile(
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(vertical: -4, horizontal: -2),
      contentPadding: EdgeInsets.only(left: 5, top: 5),
      leading: Checkbox(
          value: value,
          ),
      title: Text(option),
    );
  }
}

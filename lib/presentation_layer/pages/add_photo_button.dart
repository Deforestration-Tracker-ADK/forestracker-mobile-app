import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotosButton extends StatelessWidget {
  List<XFile> images = [];
  final ImagePicker _picker = ImagePicker();
  final Color color;
  final double borderRadius;
  final double minWidth;
  final double height;
  final String text;
  final TextStyle style;
  AddPhotosButton(
      {this.color,
      this.borderRadius = 30,
      this.minWidth = 200.0,
      this.height = 42.0,
      this.text,
      this.style});

  getImageFiles(ImageSource imageSources, BuildContext context) async {
    if (imageSources == ImageSource.gallery) {
      var imageFiles = await _picker.pickMultiImage();
      images = imageFiles;
    } else {
      var imageFile = await _picker.pickImage(source: imageSources);
      images = [imageFile];
    }
    context.read<ReportBloc>().add(SelectImagesEvent(images.map((image) => image.path).toList()));

  }

  Future<Widget> popUpSelection(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.greenAccent,
              title: Center(child: Text('Select option')),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () =>
                          getImageFiles(ImageSource.camera, context),
                      icon: Icon(
                        Icons.camera_alt,
                        size: 50,
                      )),
                  Spacer(),
                  IconButton(
                      onPressed: () =>
                          getImageFiles(ImageSource.gallery, context),
                      icon: Icon(Icons.photo, size: 50))
                ],
              ),
              elevation: 3,
              scrollable: true,
              actionsAlignment: MainAxisAlignment.center,
            ));
  }

  Future<dynamic> gridView(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(10.0),
        title: Center(
          child: Text(
            'Images',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        content: BlocBuilder<ReportBloc,ReportState>(
          buildWhen: (preState,state){
            if(state is DeleteImage){
              return true;
            }
            return false;
          },
          builder:(context,state){
          var len = context.read<ReportBloc>().images.getImages().length;
          if (len==0){
            return Text("No Images Selected!!");
          }
          else {
            return Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey,width: 2)),
                width: MediaQuery.of(context).size.width * 0.5,
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
                                    File(context.read<ReportBloc>().images.getImages()[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(top: 5, right: 5,
                                      child: Container(color: Colors.white70,
                                          child: IconButton(icon: Icon(Icons.delete), color: Colors.red[900],
                                            onPressed: (){
                                              context.read<ReportBloc>().add(DeleteImageEvent(imageId: index));
                                            },
                                          )
                                      )
                                  )
                                ],
                              )
                          );
                        })
                )
            );
          }
          }
        ),
        actions: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(
               child: customButton(
                 elevation: 2.0,
                 color: Colors.lightGreen,
                 text: '+ Add',
                 onPressed: () {
                   context.read<ReportBloc>().add(AddImagesEvent());
                   Navigator.of(context).pop();
                   return popUpSelection(context);
                 },
               ),
             ),
              SizedBox(width: 15,),
             Expanded(
               child: customButton(
                 elevation: 2.0,
                 color: Colors.lightBlue,
                 text: 'Done',
                 onPressed:  () {
                   Navigator.of(context).pop();
                 },
               ),
             ),
           ],
         )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc, ReportState>(
      listenWhen: (prevState, state){
        if(state is SelectMaxImages){
          return true;
        }
        return false;
      },
      listener: (context, state) => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Can only select 5 photos!'),
            duration: Duration(seconds: 1),
          ))
        },
      buildWhen: (prevState, state) {
        if (state is AddImages ||
            state is SelectImages ||
            state is SelectMaxImages ||
            state is DeleteImage) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return customButton(
          color: color,
          borderRadius: borderRadius,
          text: text,
          style: style,
          minWidth: minWidth,
          height: height,
          onPressed: () {
            if (state.images != null && state.images.length != 0) {
              context.read<ReportBloc>().add(SelectImagesEvent(state.images));
              return gridView(context);
            } else {
              context.read<ReportBloc>().add(AddImagesEvent());
              return popUpSelection(context);
            }
          },
        );
      },
    );
  }
}

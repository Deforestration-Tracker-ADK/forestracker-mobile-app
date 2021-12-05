import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotosButton extends StatelessWidget {
  List<XFile> images=[];
  final ImagePicker _picker = ImagePicker();
  final Color color;
  final double borderRadius;
  final double minWidth;
  final double height;
  final String text;
  final TextStyle style;
  AddPhotosButton({this.color, this.borderRadius=30, this.minWidth=200.0, this.height=42.0, this.text, this.style}) ;

  getImageFiles(ImageSource imageSources) async{
    if(imageSources == ImageSource.gallery){
      var imageFiles = await _picker.pickMultiImage();
      images = imageFiles;
    }
    else{
      var imageFile = await _picker.pickImage(source: imageSources);
      images.add(imageFile);
    }
    print(images.length);
  }

  Future<dynamic> popUpSelection(BuildContext context) {
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
                  onPressed: () =>getImageFiles(ImageSource.camera),
                  icon: Icon(
                    Icons.camera_alt,
                    size: 50,
                  )),
              Spacer(),
              IconButton(
                  onPressed: () =>getImageFiles(ImageSource.gallery), icon: Icon(Icons.photo, size: 50))
            ],
          ),
          elevation: 3,
          scrollable: true,
          actionsAlignment: MainAxisAlignment.center,
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        child: MaterialButton(
          onPressed: ()=>popUpSelection(context),
          minWidth: minWidth,
          height: height,
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );
  }
}

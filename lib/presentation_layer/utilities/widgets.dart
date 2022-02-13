import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_tracker/data_layer/models/article.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/presentation_layer/utilities/validation.dart';

import 'components.dart';

Function function = () {};

Widget customNewsTile(Article article, BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0), topRight: Radius.circular(12)),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 5.0, bottom: 5.0),
          child: ExpandablePanel(
            header: Text(
              article.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            expanded: Text(parseHtmlString(article.description),
                softWrap: true,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.0,
                )),
            theme: ExpandableThemeData(useInkWell: true),
            collapsed: null,
          ),
        )
      ],
    );

// ),

Widget customCard(Widget child,
        {double border = 16,
        Color shadowColor = Colors.green,
        Color color = Colors.greenAccent}) =>
    Card(
      elevation: 5,
      shadowColor: shadowColor,
      margin: EdgeInsets.all(10.0),
      color: color,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(border)),
      child: child,
    );

Widget buttonBar(String text, Function onPressed) => ButtonBar(
      buttonPadding: EdgeInsets.only(right: 5),
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(text),
        )
      ],
    );

Widget customButton(
        {Color color,
        String text,
        double minWidth = 200.0,
        double height = 42.0,
        double borderRadius = 30.0,
        double padding = 16.0,
        double elevation = 5.0,
        Function onPressed,
        TextStyle style}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Material(
        elevation: elevation,
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minWidth,
          height: height,
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );

Container badgeIcon({double width = 75, double height = 75}) => Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage('assets/images/logo.png'), fit: BoxFit.fill),
      ),
    );

Widget customProjectTile(Project project, Function onPressed,
    {Function onTap, bool noIcon = false}) {
  bool isFav = project.isFav;
  Widget favIcon = noIcon
      ? SizedBox(
          height: 20,
        )
      : IconButton(
          icon: isFav
              ? Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
              : Icon(Icons.star_border),
          onPressed: () => onTap(project),
        );
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      favIcon,
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            badgeIcon(),
            SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          project.projectID.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          project.organization,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        project.location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 15),
            scrollDirection: Axis.horizontal,
            child: Text(
              project.onDate,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          buttonBar('More...', () => onPressed(project)),
        ],
      )
    ],
  );
}

Widget customReportTile(
    {int index,
    Report report,
    Function onEdit,
    Function onDelete,
    Animation<double> animation,
    String buttonText}) {
  Widget deleteIcon = IconButton(
    icon: Icon(
      Icons.delete,
      color: Colors.red,
    ),
    onPressed: () => onDelete(report, index),
  );
  return FadeTransition(
    opacity: animation,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        deleteIcon,
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              badgeIcon(),
              SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        report.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                ),
              )
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 15),
              scrollDirection: Axis.horizontal,
              child: Text(
                report.dateTime,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            buttonBar(buttonText, () => onEdit(report)),
          ],
        )
      ],
    ),
  );
}

ListTile descriptionTile(String term1, String term2) {
  return ListTile(
      visualDensity: VisualDensity(vertical: -4),
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      contentPadding: EdgeInsets.all(0),
      title: Text(
        term2,
        style: TextFontDecoration.copyWith(
            fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        maxLines: double.maxFinite.toInt(),
      ),
      leading: Text(
        term1,
        style: TextFontDecoration.copyWith(
            fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ));
}

Future<Widget> dialogMsg(BuildContext context, String text,
    {isNotify = false, fontSize = 14,Color textColor}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      if (isNotify == true) {
        Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.of(context).pop();
        });
      }
      return AlertDialog(
        title: Center(
          child: Text(
            text,
            style: TextStyle(
                color: isNotify ? textColor??Colors.red : Colors.black, fontSize: 14),
          ),
        ),
        content: isNotify ? null : Center(child: CircularProgressIndicator()),
        elevation: 3,
        scrollable: true,
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}

Future<Widget> errorPopUp(BuildContext context, Function onPressed,{String msg}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      //to avoid dismissing pop up using back button
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Colors.redAccent,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Oops..!!!",
                  style: TextStyle(fontSize: 40, color: Colors.black)),
              Text(
                msg??"Something Went Wrong",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          content: Image.asset('assets/images/error.png'),
          elevation: 30,
          actions: [
            Center(child: IconButton(onPressed:onPressed, icon: const Icon(Icons.refresh_rounded),iconSize: 50,)),
          ],
        ),
      );
    },
  );
}

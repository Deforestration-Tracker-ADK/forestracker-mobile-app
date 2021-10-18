import 'package:flutter/material.dart';
import 'package:forest_tracker/data_layer/models/article.dart';
import 'package:forest_tracker/data_layer/models/project.dart';

import 'components.dart';


String buttonText = 'View more..';
Function function = (){};

Widget customNewsTile(Article article,BuildContext context,Function onPressed) => Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      height: MediaQuery.of(context).size.height/3,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12)),
      ),
    ),
    SizedBox(
      height: 8.0,
    ),
    Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: Text(
        article.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    ),
    buttonBar(buttonText,onPressed),
  ],
);


Widget customCard(Widget child, {double border = 16}) => Card(
      elevation: 5,
      shadowColor: Colors.green,
      margin: EdgeInsets.all(10.0),
      color: Colors.greenAccent,
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
        Function onPressed,
        TextStyle style}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
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

Widget customTile(Project project, Function onPressed,  {Function onTap , bool noIcon = false}) {
  bool isFav = project.isFav;
  Widget favIcon = noIcon
      ? SizedBox(height: 20,)
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


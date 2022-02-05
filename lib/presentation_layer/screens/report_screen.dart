import 'package:flutter/material.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';

class ReportPage extends StatelessWidget {
  static const String id = 'report_screen';
  @override
  Widget build(BuildContext context) {

    void _onTap(String prop){}

    return Scaffold(
      appBar: AppBar(
          title:Text('Report Page'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return Constant.reportProps
                  .map((selected) => PopupMenuItem(
                value: selected,
                child: Text(selected),
              ))
                  .toList();
            },
            onSelected: _onTap,
          )
        ],
      ),body: Center(child: Text("reports"),)
    //BlocBuilder<ReportsBloc, ReportsState>(
      //   // ignore: missing_return
      //   buildWhen: (prevState,state){
      //     if(state is ReportsLoading||state is ReportsLoaded || state is ReportsErrors ){
      //       return true;
      //     }
      //     return false;
      //   },
      //   // ignore: missing_return
      //   builder: (context, state) {
      //     if (state is ReportsLoading) {
      //       return Center(child: CircularProgressIndicator());
      //     // } else if (state is ReportsLoaded) {
      //     //   return ListView.builder(
      //     //     itemCount: state.projects.length,
      //     //     itemBuilder: (context, project) =>
      //     //         customCard(projectCard(state.projects[project])),
      //     //   );
      //     // }
      //   },
      // ),
    );
  }
}
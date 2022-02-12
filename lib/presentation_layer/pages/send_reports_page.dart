import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/blocs/reports_bloc.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';
import 'package:forest_tracker/presentation_layer/pages/view_send_report_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class SendReportPage extends StatelessWidget {
  static const String id = 'send_report_page';
  final _key = GlobalKey<AnimatedListState>();


  @override
  Widget build(BuildContext context) {

    void _onView(Report report) {
      Navigator.pushNamed(context, ReportReviewPage.id,arguments: report);
    }

    void _onDelete(Report report, int index) {
      context.read<ReportsBloc>().add(DeleteSendReport(reportName: report.name));
      _key.currentState.removeItem(
        index,
            (context, animation) => customReportTile(
            index: index,
            report: report,
            animation: animation,
            onDelete: _onDelete,
            buttonText: "Review.."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Reports'),
      ),
      body: BlocConsumer<ReportsBloc, ReportsState>(
        listenWhen: (prev,current){
          if(current is SendReportsErrors){
            return true;
          }return false;
        },
        listener: (context,state){
          if(state is SendReportsErrors){
            errorPopUp(
                context,
                    (){context.read<ReportsBloc>().add(LoadSendReports());Navigator.pop(context);},
                msg: state.error
            );
          }
        },
        // ignore: missing_return
        buildWhen: (prevState, state) {
          if (state is SendReportsLoading ||
              state is SendReportsLoaded) {
            return true;
          }
          return false;
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is SendReportsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SendReportsLoaded) {
            if (state.reports.length == 0) {
              return Center(
                child: Text("No Send reports!!!"),
              );
            }
            return AnimatedList(
              key: _key,
              initialItemCount: state.reports.length,
              itemBuilder: (context, index, animation) => customCard(
                customReportTile(
                    index: index,
                    report: state.reports[index],
                    onDelete: _onDelete,
                    onEdit: _onView,
                    animation: animation,
                    buttonText: "Review.."
                ),
                color: Colors.lightGreenAccent,
                shadowColor: Colors.greenAccent,
              ),
            );
          }
        },
      ),
    );
  }

}

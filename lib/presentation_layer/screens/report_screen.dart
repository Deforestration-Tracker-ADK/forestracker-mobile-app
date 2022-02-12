import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/blocs/reports_bloc.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';
import 'package:forest_tracker/presentation_layer/pages/report_creation/report_creation_page.dart';
import 'package:forest_tracker/presentation_layer/pages/send_reports_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/constants.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class ReportPage extends StatefulWidget {
  static const String id = 'report_screen';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with AutomaticKeepAliveClientMixin {
  final _key = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    context.read<ReportsBloc>().add(LoadDraftReports());
    super.initState();
  }

  void _onDelete(Report report, int index) {
    context.read<ReportsBloc>().add(DeleteDraftReport(reportName: report.name));
    _key.currentState.removeItem(
      index,
      (context, animation) => customReportTile(
          index: index,
          report: report,
          animation: animation,
          onDelete: _onDelete,
          onEdit: _onEdit,
        buttonText: "Edit.."
      ),
    );
  }

  void _onEdit(Report report) {
    Navigator.pushNamed(context, ReportCreationPage.id,arguments: {'isCreated': false, 'report': report});
  }

  void _onSelect(String prop) {
    context.read<ReportsBloc>().add(LoadSendReports());
    Navigator.pushNamed(context, SendReportPage.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Page'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return Constant.REPORT_PROPS
                  .map((selected) => PopupMenuItem(
                        value: selected,
                        child: Text(selected),
                      ))
                  .toList();
            },
            onSelected: _onSelect,
          )
        ],
      ),
      body: BlocConsumer<ReportsBloc, ReportsState>(
        listenWhen: (prev,current){
          if(current is ReportsErrors){
            return true;
          }return false;
        },
        listener: (context,state){
          if(state is ReportsErrors){
            errorPopUp(
                context,
                    (){context.read<ReportsBloc>().add(LoadDraftReports());Navigator.pop(context);},
                msg: state.error
            );
          }
        },
        // ignore: missing_return
        buildWhen: (prevState, state) {
          if (state is ReportsLoading ||
              state is ReportsLoaded ) {
            return true;
          }
          return false;
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is ReportsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            if (state.reports.length == 0) {
              return Center(
                child: Text("No draft reports!!!"),
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
                    onEdit: _onEdit,
                    animation: animation,
                    buttonText: "Edit.."
                ),
                color: Colors.limeAccent,
                shadowColor: Colors.orangeAccent,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

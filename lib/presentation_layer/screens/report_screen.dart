import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/blocs/reports_bloc.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';
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
    context.read<ReportsBloc>().add(LoadReports());
    super.initState();
  }
  void _onDelete(Report report,int index){
    context.read<ReportsBloc>().add(DeleteReport(reportName: report.name));
    _key.currentState.removeItem(
          index,
          (context, animation) => customReportTile(index:index,report: report, animation: animation, onDelete: _onDelete,onEdit: _onEdit),
    );
  }

  void _onEdit(String prop){}
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            onSelected: _onEdit,
          )
        ],
      ),body: BlocBuilder<ReportsBloc, ReportsState>(
        // ignore: missing_return
        buildWhen: (prevState,state){
          if(state is ReportsLoading||state is ReportsLoaded || state is ReportsErrors ){
            return true;
          }
          return false;
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is ReportsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ReportsLoaded) {
            if(state.reports.length==0){
              return Center(child: Text("No draft reports!!!"),);
            }
            return AnimatedList(
              key: _key,
              initialItemCount: state.reports.length,
              itemBuilder: (context, index,animation) =>
                  customCard(
                      customReportTile(
                          index: index,
                          report: state.reports[index],
                          onDelete: _onDelete,
                          onEdit: _onEdit,
                          animation: animation),
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
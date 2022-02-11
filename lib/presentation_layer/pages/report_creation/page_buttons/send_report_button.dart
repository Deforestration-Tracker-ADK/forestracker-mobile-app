import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/reports_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/screens/main_screen.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';
import 'package:intl/intl.dart';

class SendReportButton extends StatelessWidget {
  final Color color;
  final double borderRadius;
  final double minWidth;
  final double height;
  final String text;
  final TextStyle style;
  SendReportButton({
    this.color,
    this.borderRadius = 30,
    this.minWidth = 200.0,
    this.height = 42.0,
    this.text,
    this.style,
  });

  Future sendReport(BuildContext context, double lat, double lng) async {
    String date = DateFormat("yyyy.MM.dd ':' hh:mm aaa").format(DateTime.now());
    context.read<ReportBloc>().add(ReportSendingEvent(lat: lat, lng: lng, date: date));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is ReportSend) {
          //to pop up notification
          Navigator.pop(context);
          //to pop up report page
          Navigator.pop(context);
          context.read<ReportsBloc>().add(LoadDraftReports());
          MainPage.changePage(3, context);
        }
      },
      child: customButton(
        color: color,
        borderRadius: borderRadius,
        text: text,
        style: style,
        minWidth: minWidth,
        height: height,
        onPressed: () async {
          final locationCubit = BlocProvider.of<SelectLocationCubit>(context,listen: false);
          await sendReport(context, locationCubit.state.lat, locationCubit.state.lon);
        },
      ),
    );
  }
}
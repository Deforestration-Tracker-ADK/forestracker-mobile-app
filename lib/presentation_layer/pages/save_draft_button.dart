import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/report_bloc.dart';
import 'package:forest_tracker/logic_layer/cubits/select_location_cubit.dart';
import 'package:forest_tracker/logic_layer/events/report_event.dart';
import 'package:forest_tracker/logic_layer/states/report_state.dart';
import 'package:forest_tracker/presentation_layer/screens/main_screen.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class SaveDraftButton extends StatelessWidget {
  final Color color;
  final double borderRadius;
  final double minWidth;
  final double height;
  final String text;
  final TextStyle style;
  SaveDraftButton(
      {this.color,
        this.borderRadius = 30,
        this.minWidth = 200.0,
        this.height = 42.0,
        this.text,
        this.style});

  Future saveDraft(BuildContext context,String location) async{

    context.read<ReportBloc>().add(DraftSavingEvent(location: location));

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportBloc,ReportState>(
        listener:(context,state){
          if(state is DraftSaving){
            dialogMsg(context, "Draft Saving!!");
          }
          else if(state is DraftSaved){
            //to pop up notification
            Navigator.pop(context);
            //to pop up report page
            Navigator.pop(context);
            MainPage.changePage(3, context);
          }
          else if(state is InvalidReportName){
            dialogMsg(context, state.warning,fontSize:13,isNotify: true);
          }

        } ,
        buildWhen: (prevState,state){
          if(state is DraftSaved ||state is DraftSaving ){return true;}
          return false;
        },
        builder: (context,state) {
          final locationCubit = context.watch<SelectLocationCubit>().state;
        return customButton(
          color: color,
          borderRadius: borderRadius,
          text: text,
          style: style,
          minWidth: minWidth,
          height: height,
          onPressed: () async{
            await saveDraft(context,locationCubit.place);
          },
        );
      }
    );
  }


}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/events/reports_event.dart';
import 'package:forest_tracker/logic_layer/states/reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent,ReportsState>{
  ReportsBloc(ReportsState initialState) : super(ReportsLoading());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) {
    throw UnimplementedError();
  }

}
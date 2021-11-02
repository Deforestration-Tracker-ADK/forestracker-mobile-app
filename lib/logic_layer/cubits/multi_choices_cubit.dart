import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/logic_layer/states/multi_choices_state.dart';

class MultiChoicesCubit extends Cubit<MultiChoicesState> {
  final MultipleChoices multipleChoices;
  MultiChoicesCubit({this.multipleChoices}) : super(TappedChoice(choices: multipleChoices.choices));

  void onTap(int index, bool tapped) {
    emit(Initial());
    multipleChoices.updateValue(index, tapped);
    emit(TappedChoice(choices: multipleChoices.choices));
  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/logic_layer/events/project_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent,ProjectState>{
  ProjectAPI projectAPI;
  ProjectBloc({this.projectAPI}) : super(LoadingState());

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async*{
    if(event is ApplyProject){
      yield* _applyProject(event);
    }else if (event is FavProject) {
      yield* _makeFavourite(event);
    }
    else if(event is CancelProject){
      yield* _cancelProject(event);
    }
  }

  Stream<ProjectState> _makeFavourite(FavProject event) async* {
    try {
      if (event.isFavourite) {
        //await projectAPI.makeProjectFave(event.projectId);
        Project.favProjects.add(event.projectId);
      } else if (!event.isFavourite) {
        //await projectAPI.removeFaveProject(event.projectId);
        Project.favProjects.remove(event.projectId);
      }
      yield ProjectFav(isFav: event.isFavourite, id: event.projectId);
    } catch (e) {
      yield ProjectError(error: e.toString());
    }
  }

  Stream<ProjectState> _applyProject(ProjectEvent event) async*{
    yield LoadingState();
    try{
      //await projectAPI.applyProject(event.projectId,event.userId.toString());
      await Future.delayed(Duration(seconds: 2));
      Project.appliedProjects.add(event.projectId);
      yield AppliedState();
    }
    catch(e){
      yield ProjectError(error: e.toString());
    }

  }

  Stream<ProjectState> _cancelProject(ProjectEvent event) async*{
    yield LoadingState();
    try{
      //await projectAPI.cancelProject(event.projectId,event.userId.toString());
      await Future.delayed(Duration(seconds: 2));
      Project.appliedProjects.remove(event.projectId);
      yield CanceledState();
    }
    catch(e){
      yield ProjectError(error: e.toString());
    }

  }

}
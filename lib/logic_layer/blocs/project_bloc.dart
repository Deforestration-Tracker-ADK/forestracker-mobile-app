import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/logic_layer/events/project_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(LoadingState());

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is ApplyProject) {
      yield* _applyProject(event);
    } else if (event is FavProject) {
      yield* _makeFavourite(event);
    } else if (event is CancelProject) {
      yield* _cancelProject(event);
    }
  }

  Stream<ProjectState> _makeFavourite(FavProject event) async* {
    // try {
    //   var response;
    //   final token = await Authentication.getToken("token");
    //   final userId = await Authentication.getToken("id");
    //   final String projectId = event.projectId.toString();
    //   if (event.isFavourite) {
    //     response = await ProjectAPI.makeProjectFave(projectId, userId, token);
    //   } else if (!event.isFavourite) {
    //     response = await ProjectAPI.removeFaveProject(projectId, userId, token);
    //   }
    //   if (response == "201") {
    //     yield ProjectFav(isFav: event.isFavourite, id: event.projectId);
    //   } else {
    //     yield ProjectError(error: response);
    //   }
    // } catch (e) {
    //   yield ProjectError(error: e.toString());
    // }

    try {
      if (event.isFavourite) {
        Project.favProjects.add(event.projectId);
      } else if (!event.isFavourite) {
        Project.favProjects.remove(event.projectId);
      }
      yield ProjectFav(isFav: event.isFavourite, id: event.projectId);
    } catch (e) {
      yield ProjectError(error: e.toString());
    }
  }

  Stream<ProjectState> _applyProject(ProjectEvent event) async* {
    yield LoadingState();
    // try {
    //   final token = await Authentication.getToken("token");
    //   final userId = await Authentication.getToken("id");
    //   final String projectId = event.projectId.toString();
    //   final response = await ProjectAPI.applyProject(projectId, userId, token);
    //   if (response == "201") {
    //     yield AppliedState();
    //   } else {
    //     yield ProjectError(error: response);
    //   }
    // } catch (e) {
    //   yield ProjectError(error: e.toString());
    // }
    try {
      await Future.delayed(Duration(seconds: 2));
      Project.appliedProjects.add(event.projectId);
      yield AppliedState();
    } catch (e) {
      yield ProjectError(error: e.toString());
    }
  }

  Stream<ProjectState> _cancelProject(ProjectEvent event) async* {
    yield LoadingState();

    // try {
    //   final token = await Authentication.getToken("token");
    //   final userId = await Authentication.getToken("id");
    //   final String projectId = event.projectId.toString();
    //   final response = await ProjectAPI.cancelProject(projectId.toString(), userId.toString(), token.toString());
    //   if (response == "201") {
    //     yield CanceledState();
    //   } else {
    //     yield ProjectError(error: response);
    //   }
    // } catch (e) {
    //   yield ProjectError(error: e.toString());
    // }

    try {
      await Future.delayed(Duration(seconds: 2));
      Project.appliedProjects.remove(event.projectId);
      yield CanceledState();
    } catch (e) {
      yield ProjectError(error: e.toString());
    }
  }
}

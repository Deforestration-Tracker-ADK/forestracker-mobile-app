import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/roughData.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/events/projects_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvents, ProjectsStates> {
  final ProjectBloc projectBloc;

  StreamSubscription streamSubscription;

  List<Project> allProjects = [];
  List<Project> appliedProjects = [];

  ProjectsBloc({this.projectBloc}) : super(ProjectsLoading()) {
    streamSubscription = projectBloc.stream.listen((projectState) {
      if(projectState is CanceledState){
        appliedProjects = allProjects.where((project)=>Project.appliedProjects.contains(project.projectID)).toList();
        emit(AppliedProjectsLoaded().copyWith(projects: appliedProjects));
      }
    });
  }


  @override
  Stream<ProjectsStates> mapEventToState(ProjectsEvents event) async* {
    if (event is LoadProjects) {
      yield* _loadProjects(event);
    } else if (event is ViewMore) {
      yield* _viewProjectDetails(event);
    } else if (event is GetAllFavProjects){
      yield* _getFavProjects(event);
    } else if (event is GetAllAppliedProjects){
      yield* _getAppliedProjects();
    }
  }

  Stream<ProjectsStates> _loadProjects(ProjectsEvents event) async* {
    yield ProjectsLoading();
    await Future.delayed(Duration(milliseconds: 2000));
    try {
     // allProjects = await ProjectAPI.getAllProjects();
      allProjects = projects;
      yield ProjectsLoaded().copyWith(projects: allProjects);
    } catch (e) {
      yield ProjectErrors(error: e.toString());
    }
  }

  Stream<ProjectsStates> _viewProjectDetails(ProjectsEvents event) async* {
    yield ProjectLoading();
    try {
      final token = await Authentication.getToken("token");
      final String projectId = event.projectId.toString();
      await Future.delayed(Duration(milliseconds: 2000));
      // Project project = await ProjectAPI.getProject(projectId, token);
      // yield ProjectLoaded().copyWith(project: project, applied: project.isApplied);
      Project project = allProjects[event.projectId - 1];
      if (Project.appliedProjects.contains(event.projectId)) {
        yield ProjectLoaded().copyWith(project: project, applied: true);
      } else
        yield ProjectLoaded().copyWith(project: project, applied: false);
    } catch (e) {
      yield ProjectErrors(error: e.toString());
    }
  }



  Stream<ProjectsStates> _getFavProjects(ProjectsEvents event) async*{
    yield FavProjectsLoading();
    try{
      // final token = await Authentication.getToken("token");
      // final userId = await Authentication.getToken("id");
      // List<Project> favProjects = await ProjectAPI.getFavProjects(userId, token);
      List<Project> favProjects = allProjects.where((project)=>Project.favProjects.contains(project.projectID)).toList();
      yield FavProjectsLoaded(projects: favProjects);
    }catch (e) {
      yield ProjectErrors(error: e.toString());
    }

  }

  Stream<ProjectsStates> _getAppliedProjects() async*{
    yield AppliedProjectsLoading();
    try{
      // final token = await Authentication.getToken("token");
      // final userId = await Authentication.getToken("id");
      // List<Project> appliedProjects = await ProjectAPI.getAppliedProjects(userId, token);
      appliedProjects = allProjects.where((project)=>Project.appliedProjects.contains(project.projectID)).toList();
      yield AppliedProjectsLoaded().copyWith(projects: appliedProjects);
    }catch (e) {
      yield ProjectErrors(error: e.toString());
    }

  }
  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

}

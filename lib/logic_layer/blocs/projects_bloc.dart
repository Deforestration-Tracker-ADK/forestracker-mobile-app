import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/roughData.dart';
import 'package:forest_tracker/data_layer/services/project_services.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/events/projects_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvents, ProjectsStates> {
  final ProjectBloc projectBloc;
  final ProjectAPI projectAPI;

  StreamSubscription streamSubscription;

  List<Project> allProjects = [];
  List<Project> appliedProjects = [];

  ProjectsBloc({this.projectBloc, this.projectAPI}) : super(ProjectsLoading()) {
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
      //allProjects = await projectAPI.getAllProjects();
      allProjects = projects;
      yield ProjectsLoaded().copyWith(projects: allProjects);
    } catch (e) {
      yield ProjectErrors(error: e.toString());
    }
  }

  Stream<ProjectsStates> _viewProjectDetails(ProjectsEvents event) async* {
    yield ProjectLoading();
    try {
      await Future.delayed(Duration(milliseconds: 2000));
      //Project project = await projectAPI.getProject(event.projectId);
      Project project = allProjects[event.projectId - 1]; //until API connected
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
      //List<Project> projects = await projectAPI.getFaveProjects();
      List<Project> favProjects = allProjects.where((project)=>Project.favProjects.contains(project.projectID)).toList();
      yield FavProjectsLoaded(projects: favProjects);
    }catch (e) {
      yield ProjectErrors(error: e.toString());
    }

  }

  Stream<ProjectsStates> _getAppliedProjects() async*{
    yield AppliedProjectsLoading();
    try{
      //List<Project> projects = await projectAPI.getFaveProjects();
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

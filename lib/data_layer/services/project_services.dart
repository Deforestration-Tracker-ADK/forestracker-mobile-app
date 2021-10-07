import 'dart:convert';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ProjectAPI{
  static ProjectAPI _instance;
  int projectId;
  String projectName;
  var jsonResponse ;
  var url ;
  var response;

  ProjectAPI._();

  static getInstance(){
    if(_instance == null){
      _instance = ProjectAPI._();
    }
    return _instance;
  }
  Future getAllProjects() async{
    this.url= Uri.parse('API');
    this.response = await http.get(this.url);
    if(this.response.statusCode==200){
      this.jsonResponse = json.decode(response.body);
      if(this.jsonResponse !=null){
        List<Project> projects = jsonResponse.map((dynamic data) => Project.fromJson(data)).toList();
        return projects;
      }
      else{
        throw('No Projects;');
      }
    }
    else{
      throw('Status code error');
    }

  }

  Future getProject(int projectId) async{
    this.projectId = projectId;
    this.url= Uri.parse('API');
    this.response = await http.get(this.url,headers: {'projectID':projectId.toString(),'userID': Authentication.getToken('userID')});
    if(this.response.statusCode==200){
      this.jsonResponse = json.decode(response.body);
      if(this.jsonResponse !=null){
        Project project = Project.fromJson(jsonResponse);
        return project;
      }
      else{
        throw('Project loading error;');
      }
    }
    else{
      throw('Status code error');
    }
  }

  Future applyProject(int projectId,String userId) async{
    this.projectId = projectId;
    this.url = Uri.parse('API');
    Map body = {'projectId' : projectId,'userId':userId};
    this.response = await http.post(url,body:body );
    if(this.response.statusCode==200){
      this.jsonResponse = json.decode(response.body);
      if(this.jsonResponse !=null){
        return this.jsonResponse;
      }
      else{
        throw('Project Applying failed');
      }
    }
    else{
      throw('Status code error');
    }
  }

  Future cancelProject(int projectId,String userId) async{
    this.projectId = projectId;
    this.url = Uri.parse('API');
    Map body = {'projectId' : projectId,'userId':userId};
    this.response = await http.post(url,body:body );
    if(this.response.statusCode==200){
      this.jsonResponse = json.decode(response.body);
      if(this.jsonResponse !=null){
        return this.jsonResponse;
      }
      else{
        throw('Project Cancellation failed');
      }
    }
    else{
      throw('Status code error');
    }
  }

  Future makeProjectFave(int projectId)async {}

  Future removeFaveProject(int projectId)async {}

  Future getFaveProjects()async {}
}

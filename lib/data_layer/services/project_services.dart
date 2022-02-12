import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:forest_tracker/data_layer/models/project.dart';

import '../Constants.dart';

class ProjectAPI{

  static Future getAllProjects({@required String token}) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getAllProjectsUrl);
      return response.data.map((data)=>Project.fromJson(data)).toList();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }

  }

  static Future getProject(String projectId,String token) async{

    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getProjectUrl+projectId);
      return Project.fromJson(response.data);
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future applyProject(String projectId,String userId,String token) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.post(URLS.applyProjectUrl,data:{
        "volunteer_id": userId,
        "opportunity_id": projectId
      });
      return response.statusCode.toString();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future cancelProject(String projectId,String userId,String token) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.post(URLS.applyProjectUrl,data:{
        "volunteer_id": userId,
        "opportunity_id": projectId
      });
      return response.statusCode.toString();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future makeProjectFave(String projectId,String userId,String token) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.post(URLS.makeFavProjectUrl,data:{
        "volunteer_id": userId,
        "opportunity_id": projectId,
        "isFavourite" : "true"
      });
      return response.statusCode.toString();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future removeFaveProject(String projectId,String userId,String token) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.post(URLS.makeFavProjectUrl,data:{
        "volunteer_id": userId,
        "opportunity_id": projectId,
        "isFavourite" : "false"
      });
      return response.statusCode.toString();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future getFavProjects(String userId,String token)async {
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getAllFavProjectsUrl+userId);
      return response.data.map((data)=>Project.fromJson(data)).toList();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }
  static Future getAppliedProjects(String userId,String token)async {
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getAllAppliedProjectsUrl+userId);
      return response.data.map((data)=>Project.fromJson(data)).toList();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }
}

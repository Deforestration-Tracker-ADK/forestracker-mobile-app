import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';

class ReportAPI {
  Report report;
  DateTime date;

  //temp request using shared space
  static Future<List<Report>> getDraftReports(String action) async {
    final keys = await Authentication.getAllKeys();
    final SharedPreferences shp = await Authentication.init();
    final result = keys
        .where((key) => key.startsWith(action))//draft reports are saved with the prefix of 0
        .map<Report>((key) {
          String value = shp.getString(key) ;
          var decode = jsonDecode(value) as Map<String,dynamic>;
      return Report.fromJson(decode);
    }).toList();
    return result;
  }

  static Future<bool> saveReport(String reportName,Report report) async{
    final hasKey = await Authentication.checkKey(reportName);
    if(!hasKey){
      await Authentication.setToken(reportName, json.encode(report.toJson()));
      return true;
    }
    //already exist name
    return false;
  }

  static void deleteReport(String reportName,String action) async{
    final String key = action+ reportName;
    await Authentication.removeKey(key);
  }

  //real backend calls
  static Future getAllSendReports({@required String userId,@required String token}) async{
    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getAllSendReportsUrl+userId);
      return response.data.map((data)=>Report.fromJson(data)).toList();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }

  }

  static Future viewReport(String reportId,String token) async{

    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.get(URLS.getSendReportUrl+reportId);
      return Report.fromJson(response.data);
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

  static Future createReport(Report report,String token) async{

    var dio = Dio();

    try {
      dio.options.headers['Authorization'] = 'Token ' + token;
      var response = await dio.post(URLS.createReportUrl,data: report.toJson());
      return response.statusCode.toString();
    } on DioError catch (e) {
      return e.response.data['detail'].toString();
    }
  }

}

import 'dart:convert';

import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportAPI {
  static ReportAPI _instance;
  Report report;
  DateTime date;

  ReportAPI._();

  static getInstance() {
    if (_instance == null) {
      _instance = ReportAPI._();
    }
    return _instance;
  }

  Future<List<Report>> getDraftReports() async {
    final keys = await Authentication.getAllKeys();
    final SharedPreferences shp = await Authentication.init();
    final result = keys
        .where((key) => key != "token" && key != "userID")
        .map<Report>((key) {
          String value = shp.getString(key) ;
          var decode = jsonDecode(value) as Map<String,dynamic>;
      return Report.fromJson(decode);
    }).toList();
    return result;
  }

  Future<bool> saveDraftReport(String reportName,Report draftReport) async{
    final value = await Authentication.getToken(reportName);
    if(value==null){
      await Authentication.setToken(reportName, json.encode(draftReport.toJson()));
      return true;
    }
    //already exist name
    return false;
  }

  Future<bool> updateDraftReport(String newName,String prevName,Report draftReport) async{
    if(newName==prevName){
      await Authentication.setToken(newName, json.encode(draftReport.toJson()));
      return true;
    }
    final value = await Authentication.getToken(newName);
    if(value==null){
      await Authentication.removeKey(prevName);
      await Authentication.setToken(newName, json.encode(draftReport.toJson()));
      return true;
    }
    return false;
  }

  void deleteDraftReport(String reportName) async{
    await Authentication.removeKey(reportName);
  }



}

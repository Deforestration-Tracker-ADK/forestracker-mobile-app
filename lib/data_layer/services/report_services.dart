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

  Future<List<Report>> getDraftReports(String action) async {
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

  Future<bool> saveReport(String reportName,Report report) async{
    final hasKey = await Authentication.checkKey(reportName);
    if(!hasKey){
      await Authentication.setToken(reportName, json.encode(report.toJson()));
      return true;
    }
    //already exist name
    return false;
  }


  void deleteReport(String reportName,String action) async{
    final String key = action+ reportName;
    await Authentication.removeKey(key);
  }





}

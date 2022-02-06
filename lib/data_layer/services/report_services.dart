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

  void deleteDraftReport(String reportName) async{
    await Authentication.removeKey(reportName);
  }

}

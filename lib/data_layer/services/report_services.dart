import 'dart:convert';

import 'package:forest_tracker/data_layer/models/report.dart';
import 'package:forest_tracker/data_layer/services/auth_service.dart';

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
    final result = keys
        .where((key) => key != "token" && key != "userID")
        .map<Report>((key) {
          print(key);
          var value = Authentication.getToken(key) as String;
          print("VALUE : $value");

          var decode = json.decode as Map<String,dynamic>;

          print("DECODE: $decode");
      return Report.fromJson(decode);
    }).toList();
    print(result);
    print("ATHULEEEEEE");
    return result;
  }
}

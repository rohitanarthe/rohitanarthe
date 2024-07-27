// To parse this JSON data, do
//
//     final checkAttendanceModel = checkAttendanceModelFromJson(jsonString);

import 'dart:convert';

CheckAttendanceModel checkAttendanceModelFromJson(String str) => CheckAttendanceModel.fromJson(json.decode(str));

String checkAttendanceModelToJson(CheckAttendanceModel data) => json.encode(data.toJson());

class CheckAttendanceModel {
  List<dynamic>? empAtte;
  String? sucess;

  CheckAttendanceModel({
    this.empAtte,
    this.sucess,
  });

  factory CheckAttendanceModel.fromJson(Map<String, dynamic> json) => CheckAttendanceModel(
    empAtte: List<dynamic>.from(json["emp_atte"].map((x) => x)),
    sucess: json["Sucess"],
  );

  Map<String, dynamic> toJson() => {
    "emp_atte": List<dynamic>.from(empAtte!.map((x) => x)),
    "Sucess": sucess,
  };
}

// To parse this JSON data, do
//
//     final attendanceStatusModel = attendanceStatusModelFromJson(jsonString);

import 'dart:convert';

AttendanceStatusModel attendanceStatusModelFromJson(String str) => AttendanceStatusModel.fromJson(json.decode(str));

String attendanceStatusModelToJson(AttendanceStatusModel data) => json.encode(data.toJson());

class AttendanceStatusModel {
  List<Datum> data;
  String result;

  AttendanceStatusModel({
    required this.data,
    required this.result,
  });

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) => AttendanceStatusModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "result": result,
  };
}

class Datum {
  String directBill;
  String twoWheel;
  String fourWheel;
  String dwrTravelByVehicle;
  String dwrVisitedRoute;
  String outOfHeadQuaDa;
  String returnToHeadQuaDa;
  String exHeadQuaDa;
  String ptrStartReading;

  Datum({
    required this.directBill,
    required this.twoWheel,
    required this.fourWheel,
    required this.dwrTravelByVehicle,
    required this.dwrVisitedRoute,
    required this.outOfHeadQuaDa,
    required this.returnToHeadQuaDa,
    required this.exHeadQuaDa,
    required this.ptrStartReading,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    directBill: json["Direct_bill"],
    twoWheel: json["Two_wheel"],
    fourWheel: json["Four_wheel"],
    dwrTravelByVehicle: json["dwr_travel_by_vehicle"],
    dwrVisitedRoute: json["dwr_visited_route"],
    outOfHeadQuaDa: json["out_of_head_qua_da"],
    returnToHeadQuaDa: json["return_to_head_qua_da"],
    exHeadQuaDa: json["ex_head_qua_da"],
    ptrStartReading: json["ptr_start_reading"],
  );

  Map<String, dynamic> toJson() => {
    "Direct_bill": directBill,
    "Two_wheel": twoWheel,
    "Four_wheel": fourWheel,
    "dwr_travel_by_vehicle": dwrTravelByVehicle,
    "dwr_visited_route": dwrVisitedRoute,
    "out_of_head_qua_da": outOfHeadQuaDa,
    "return_to_head_qua_da": returnToHeadQuaDa,
    "ex_head_qua_da": exHeadQuaDa,
    "ptr_start_reading": ptrStartReading,
  };
  double calculateTotalKm(double totalKm, String vehicleType) {
    if (directBill.toLowerCase() == "no") {
      if (vehicleType.toLowerCase() == "car") {
        return totalKm * 10;
      } else if (vehicleType.toLowerCase() == "bike") {
        return totalKm * 5;
      }
    }
    return totalKm;
  }
}

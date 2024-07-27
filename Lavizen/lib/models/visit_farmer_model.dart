// To parse this JSON data, do
//
//     final farmerVisitModel = farmerVisitModelFromJson(jsonString);

import 'dart:convert';

FarmerVisitModel farmerVisitModelFromJson(String str) => FarmerVisitModel.fromJson(json.decode(str));

String farmerVisitModelToJson(FarmerVisitModel data) => json.encode(data.toJson());

class FarmerVisitModel {
  List<FarmerSearchReport> farmerSearchReport;

  FarmerVisitModel({
    required this.farmerSearchReport,
  });

  factory FarmerVisitModel.fromJson(Map<String, dynamic> json) => FarmerVisitModel(
    farmerSearchReport: List<FarmerSearchReport>.from(json["farmer_search_report"].map((x) => FarmerSearchReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "farmer_search_report": List<dynamic>.from(farmerSearchReport.map((x) => x.toJson())),
  };
}

class FarmerSearchReport {
  String farmId;
  String farmName;
  String farmMob;
  String farmAddress;
  String farmStartLat;
  String farmStartLong;
  double farmerDistance;

  FarmerSearchReport({
    required this.farmId,
    required this.farmName,
    required this.farmMob,
    required this.farmAddress,
    required this.farmStartLat,
    required this.farmStartLong,
    required this.farmerDistance,
  });

  factory FarmerSearchReport.fromJson(Map<String, dynamic> json) => FarmerSearchReport(
    farmId: json["farm_id"],
    farmName: json["farm_name"],
    farmMob: json["farm_mob"],
    farmAddress: json["farm_address"],
    farmStartLat: json["farm_start_lat"],
    farmStartLong: json["farm_start_long"],
    farmerDistance: (json["farmer_distance"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "farm_id": farmId,
    "farm_name": farmName,
    "farm_mob": farmMob,
    "farm_address": farmAddress,
    "farm_start_lat": farmStartLat,
    "farm_start_long": farmStartLong,
    "farmer_distance": farmerDistance,
  };
}


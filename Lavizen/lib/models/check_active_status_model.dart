// To parse this JSON data, do
//
//     final checkActiveStatusModel = checkActiveStatusModelFromJson(jsonString);

import 'dart:convert';

CheckActiveStatusModel checkActiveStatusModelFromJson(String str) => CheckActiveStatusModel.fromJson(json.decode(str));

String checkActiveStatusModelToJson(CheckActiveStatusModel data) => json.encode(data.toJson());

class CheckActiveStatusModel {
  List<CheckStatusData>? data;

  CheckActiveStatusModel({
    this.data,
  });

  factory CheckActiveStatusModel.fromJson(Map<String, dynamic> json) => CheckActiveStatusModel(
    data: List<CheckStatusData>.from(json["data"].map((x) => CheckStatusData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CheckStatusData {
  String? etId;
  String? etStatus;

  CheckStatusData({
    this.etId,
    this.etStatus,
  });

  factory CheckStatusData.fromJson(Map<String, dynamic> json) => CheckStatusData(
    etId: json["et_id"],
    etStatus: json["et_status"],
  );

  Map<String, dynamic> toJson() => {
    "et_id": etId,
    "et_status": etStatus,
  };
}

// To parse this JSON data, do
//
//     final farmerVisitHistoryModel = farmerVisitHistoryModelFromJson(jsonString);

import 'dart:convert';

FarmerVisitHistoryModel farmerVisitHistoryModelFromJson(String str) => FarmerVisitHistoryModel.fromJson(json.decode(str));

String farmerVisitHistoryModelToJson(FarmerVisitHistoryModel data) => json.encode(data.toJson());

class FarmerVisitHistoryModel {
  List<ViewFarmerVisitList> viewFarmerVisitList;

  FarmerVisitHistoryModel({
    required this.viewFarmerVisitList,
  });

  factory FarmerVisitHistoryModel.fromJson(Map<String, dynamic> json) => FarmerVisitHistoryModel(
    viewFarmerVisitList: List<ViewFarmerVisitList>.from(json["view_farmer_visit_list"].map((x) => ViewFarmerVisitList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "view_farmer_visit_list": List<dynamic>.from(viewFarmerVisitList.map((x) => x.toJson())),
  };
}

class ViewFarmerVisitList {
  String fkFarmId;
  String farmName;
  String etId;
  String farmMob;
  String farmAddress;
  String farmVisitedRemark;
  String farmVisitedLat;
  String farmVisitedLong;
  String farmVisitedDate;
  String farmVisitedFollowupDate;
  String farmVisitedPurpose;
  String stName;
  String farmVisitedImg;
  String layerCapacity;
  String breaderCapacity;
  String broilerCapacity;

  ViewFarmerVisitList({
    required this.fkFarmId,
    required this.farmName,
    required this.etId,
    required this.farmMob,
    required this.farmAddress,
    required this.farmVisitedRemark,
    required this.farmVisitedLat,
    required this.farmVisitedLong,
    required this.farmVisitedDate,
    required this.farmVisitedFollowupDate,
    required this.farmVisitedPurpose,
    required this.stName,
    required this.farmVisitedImg,
    required this.layerCapacity,
    required this.breaderCapacity,
    required this.broilerCapacity,
  });

  factory ViewFarmerVisitList.fromJson(Map<String, dynamic> json) => ViewFarmerVisitList(
    fkFarmId: json["fk_farm_id"],
    farmName: json["farm_name"],
    etId: json["et_id"],
    farmMob: json["farm_mob"],
    farmAddress: json["farm_address"],
    farmVisitedRemark: json["farm_visited_remark"],
    farmVisitedLat: json["farm_visited_lat"],
    farmVisitedLong: json["farm_visited_long"],
    farmVisitedDate: json["farm_visited_date"],
    farmVisitedFollowupDate: json["farm_visited_followup_date"],
    farmVisitedPurpose: json["farm_visited_purpose"],
    stName: json["st_name"],
    farmVisitedImg: json["farm_visited_img"],
    layerCapacity: json["layer_capacity"],
    breaderCapacity: json["breader_capacity"],
    broilerCapacity: json["broiler_capacity"],
  );

  Map<String, dynamic> toJson() => {
    "fk_farm_id": fkFarmId,
    "farm_name": farmName,
    "et_id": etId,
    "farm_mob": farmMob,
    "farm_address": farmAddress,
    "farm_visited_remark": farmVisitedRemark,
    "farm_visited_lat": farmVisitedLat,
    "farm_visited_long": farmVisitedLong,
    "farm_visited_date": farmVisitedDate,
    "farm_visited_followup_date": farmVisitedFollowupDate,
    "farm_visited_purpose": farmVisitedPurpose,
    "st_name": stName,
    "farm_visited_img": farmVisitedImg,
    "layer_capacity": layerCapacity,
    "breader_capacity": breaderCapacity,
    "broiler_capacity": broilerCapacity,
  };
}

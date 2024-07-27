// To parse this JSON data, do
//
//     final visitDistributorModel = visitDistributorModelFromJson(jsonString);

import 'dart:convert';

VisitDistributorModel visitDistributorModelFromJson(String str) => VisitDistributorModel.fromJson(json.decode(str));

String visitDistributorModelToJson(VisitDistributorModel data) => json.encode(data.toJson());

class VisitDistributorModel {
  List<DealerSearchReport> dealerSearchReport;

  VisitDistributorModel({
    required this.dealerSearchReport,
  });

  factory VisitDistributorModel.fromJson(Map<String, dynamic> json) => VisitDistributorModel(
    dealerSearchReport: List<DealerSearchReport>.from(json["dealer_search_report"].map((x) => DealerSearchReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dealer_search_report": List<dynamic>.from(dealerSearchReport.map((x) => x.toJson())),
  };
}

class DealerSearchReport {
  String custId;
  String firmName;
  String custName;
  String custAddr;
  String custLat;
  String custLong;
  double custDistance;

  DealerSearchReport({
    required this.custId,
    required this.firmName,
    required this.custName,
    required this.custAddr,
    required this.custLat,
    required this.custLong,
    required this.custDistance,
  });

  factory DealerSearchReport.fromJson(Map<String, dynamic> json) => DealerSearchReport(
    custId: json["cust_id"],
    firmName: json["firm_name"],
    custName: json["cust_name"],
    custAddr: json["cust_addr"],
    custLat: json["cust_lat"],
    custLong: json["cust_long"],
    custDistance: json["cust_distance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "cust_id": custId,
    "firm_name": firmName,
    "cust_name": custName,
    "cust_addr": custAddr,
    "cust_lat": custLat,
    "cust_long": custLong,
    "cust_distance": custDistance,
  };
}

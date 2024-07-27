// To parse this JSON data, do
//
//     final dealerVisitHistory = dealerVisitHistoryFromJson(jsonString);

import 'dart:convert';

DealerVisitHistoryModel dealerVisitHistoryFromJson(String str) => DealerVisitHistoryModel.fromJson(json.decode(str));

String dealerVisitHistoryToJson(DealerVisitHistoryModel data) => json.encode(data.toJson());

class DealerVisitHistoryModel {
  List<ViewDealerVisitList> viewDealerVisitList;

  DealerVisitHistoryModel({
    required this.viewDealerVisitList,
  });

  factory DealerVisitHistoryModel.fromJson(Map<String, dynamic> json) => DealerVisitHistoryModel(
    viewDealerVisitList: List<ViewDealerVisitList>.from(json["view_dealer_visit_list"].map((x) => ViewDealerVisitList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "view_dealer_visit_list": List<dynamic>.from(viewDealerVisitList.map((x) => x.toJson())),
  };
}

class ViewDealerVisitList {
  String fkCustId;
  String etId;
  String custName;
  String firmName;
  String custAddr;
  String custMobNo;
  String custVisitedDate;
  String custVisitedPurpose;
  String custVisitedRemark;
  String custFollowUpDate;
  String custImg;

  ViewDealerVisitList({
    required this.fkCustId,
    required this.etId,
    required this.custName,
    required this.firmName,
    required this.custAddr,
    required this.custMobNo,
    required this.custVisitedDate,
    required this.custVisitedPurpose,
    required this.custVisitedRemark,
    required this.custFollowUpDate,
    required this.custImg,
  });

  factory ViewDealerVisitList.fromJson(Map<String, dynamic> json) => ViewDealerVisitList(
    fkCustId: json["fk_cust_id"],
    etId: json["et_id"],
    custName: json["cust_name"],
    firmName: json["firm_name"],
    custAddr: json["cust_addr"],
    custMobNo: json["cust_mob_no"],
    custVisitedDate: json["cust_visited_date"],
    custVisitedPurpose: json["cust_visited_purpose"],
    custVisitedRemark: json["cust_visited_remark"],
    custFollowUpDate: json["cust_follow_up_date"],
    custImg: json["cust_img"],
  );

  Map<String, dynamic> toJson() => {
    "fk_cust_id": fkCustId,
    "et_id": etId,
    "cust_name": custName,
    "firm_name": firmName,
    "cust_addr": custAddr,
    "cust_mob_no": custMobNo,
    "cust_visited_date": custVisitedDate,
    "cust_visited_purpose": custVisitedPurpose,
    "cust_visited_remark": custVisitedRemark,
    "cust_follow_up_date": custFollowUpDate,
    "cust_img": custImg,
  };
}

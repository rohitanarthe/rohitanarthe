
import 'dart:convert';

LoginDataModel loginDataModelFromJson(String str) => LoginDataModel.fromJson(json.decode(str));

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  List<LoginData>? data;
  String? result;

  LoginDataModel({
    this.data,
    this.result,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
    data: List<LoginData>.from(json["data"].map((x) => LoginData.fromJson(x))),
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "result": result,
  };
}

class LoginData {
  String? etId;
  String? etName;
  String? etAdd;
  String? etEmail;
  String? etContact;
  String? etStatus;
  String? etDesignation;
  String? msetingId;

  LoginData({
    this.etId,
    this.etName,
    this.etAdd,
    this.etEmail,
    this.etContact,
    this.etStatus,
    this.etDesignation,
    this.msetingId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    etId: json["et_id"],
    etName: json["et_name"],
    etAdd: json["et_add"],
    etEmail: json["et_email"],
    etContact: json["et_contact"],
    etStatus: json["et_status"],
    etDesignation: json["et_designation"],
    msetingId: json["mseting_id"],
  );

  Map<String, dynamic> toJson() => {
    "et_id": etId,
    "et_name": etName,
    "et_add": etAdd,
    "et_email": etEmail,
    "et_contact": etContact,
    "et_status": etStatus,
    "et_designation": etDesignation,
    "mseting_id": msetingId,
  };
}

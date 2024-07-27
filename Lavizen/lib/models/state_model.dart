// To parse this JSON data, do
//
//     final stateOfModel = stateOfModelFromJson(jsonString);

import 'dart:convert';

StateOfModel stateOfModelFromJson(String str) => StateOfModel.fromJson(json.decode(str));

String stateOfModelToJson(StateOfModel data) => json.encode(data.toJson());

class StateOfModel {
  List<StateTable> stateTable;

  StateOfModel({
    required this.stateTable,
  });

  factory StateOfModel.fromJson(Map<String, dynamic> json) => StateOfModel(
    stateTable: List<StateTable>.from(json["state_table"].map((x) => StateTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state_table": List<dynamic>.from(stateTable.map((x) => x.toJson())),
  };
}

class StateTable {
  String stId;
  String stName;

  StateTable({
    required this.stId,
    required this.stName,
  });

  factory StateTable.fromJson(Map<String, dynamic> json) => StateTable(
    stId: json["st_id"],
    stName: json["st_name"],
  );

  Map<String, dynamic> toJson() => {
    "st_id": stId,
    "st_name": stName,
  };
}

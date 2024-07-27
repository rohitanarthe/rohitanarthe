import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/state_model.dart';

class StateController extends GetxController {
  var stateList = <StateTable>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchStateList();
    super.onInit();
  }

  void fetchStateList() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/state_list.php'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print('state----${response.body.toString()}');
        var states = StateOfModel.fromJson(jsonData);
        stateList.value = states.stateTable;
      } else {
        // Handle error
      }
    } finally {
      isLoading(false);
    }
  }
}
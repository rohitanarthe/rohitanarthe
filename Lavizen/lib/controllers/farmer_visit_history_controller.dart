import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lavizen/models/farmer_visit_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dealer_visit_history_model.dart';

class FarmerVisitHistoryController extends GetxController {
  var farmerVisitHistory = FarmerVisitHistoryModel(viewFarmerVisitList: []).obs;
  var isLoading = true.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDealerVisitHistory(selectedDate.value);
  }

  void fetchDealerVisitHistory(DateTime date) async {
    String? etId;
    SharedPreferences? pref = await SharedPreferences.getInstance();
    etId = pref.getString('et_id');

    try {
      isLoading(true);
      var formattedDate = DateFormat('yyyy/MM/dd').format(date);
      var response = await http.get(Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/view_farmer_visit_list.php?visited_date=$formattedDate&et_id=$etId'));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var jsonData = json.decode(response.body);
          farmerVisitHistory.value = FarmerVisitHistoryModel.fromJson(jsonData);
        } else {
          // Handle empty response body
          farmerVisitHistory.value = FarmerVisitHistoryModel(viewFarmerVisitList: []);
          print('Response body is empty');
        }
      } else {
        // Handle HTTP error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle the exception
      print('Exception: $e');
      farmerVisitHistory.value = FarmerVisitHistoryModel(viewFarmerVisitList: []);
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchDealerVisitHistory(date);
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}

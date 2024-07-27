import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dealer_visit_history_model.dart';

class DealerVisitController extends GetxController {
  var dealerVisitHistory = DealerVisitHistoryModel(viewDealerVisitList: []).obs;
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
      var response = await http.get(Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/view_dealer_visit_list.php?visited_date=$formattedDate&et_id=$etId'));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var jsonData = json.decode(response.body);
          dealerVisitHistory.value = DealerVisitHistoryModel.fromJson(jsonData);
        } else {
          // Handle empty response body
          dealerVisitHistory.value = DealerVisitHistoryModel(viewDealerVisitList: []);
          print('Response body is empty');
        }
      } else {
        // Handle HTTP error response
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle the exception
      print('Exception: $e');
      dealerVisitHistory.value = DealerVisitHistoryModel(viewDealerVisitList: []);
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

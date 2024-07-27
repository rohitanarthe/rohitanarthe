

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:lavizen/models/check_attendance_status_model.dart';

class CheckAttendenceEntryController extends GetxController {
  var attendanceData = <Datum>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAttendanceData(String fkEtId, String exTdate) async {
    try {
      isLoading(true);
      final response = await http.get(
          Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/check_attendence_entry_new_for_img.php?fk_et_id=$fkEtId&ex_tdate=$exTdate'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['result'] == 'punch') {
          var data = jsonData['data'] as List;
          attendanceData.value =
              data.map((item) => Datum.fromJson(item)).toList();
        } else {
          // Handle no data or error case
          attendanceData.clear();
        }
      } else {
        // Handle HTTP error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle other errors
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);;
  }
  }

/*
void updateSelectedDate(DateTime date) {
  selectedDate.value = date;
  fetchDealerVisitHistory(date);
}

String getFormattedDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);

  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDealerVisitHistory(selectedDate.value);
  }

}*/

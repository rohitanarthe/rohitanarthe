import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/check_in_model.dart';

class CheckAttendanceController extends GetxController {
  var checkAttendanceModel = CheckAttendanceModel(empAtte: [], sucess: '').obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAttendance();
    super.onInit();
  }

  Future<void> fetchAttendance() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(''));
      if (response.statusCode == 200) {
        checkAttendanceModel.value = checkAttendanceModelFromJson(response.body);
      } else {
        // Handle error response
        print('Failed to load data');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}

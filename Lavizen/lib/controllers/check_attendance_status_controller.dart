import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceController extends GetxController {
  var isLoading = false.obs;
  var attendanceStatus = ''.obs;
  var checkInTime = ''.obs;
  var checkOutTime = ''.obs;

  var totalTimeWork = ''.obs;
  var workDay = ''.obs;
  void fetchAttendanceStatus() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? et_id = pref.getString('et_id');
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://krushiapp.co.in/Lavizen/new_webservices/check_employee_attendence_new.php?ex_tdate=$formattedDate&fk_et_id=$et_id'));
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        print(response.body);
        var status = responseJson['Sucess'];
        if (status == 'You are already Check In .') {
          attendanceStatus.value = 'not_checked_in';
          var checkInDetails = responseJson['emp_atte'][0];
          checkInTime.value = checkInDetails['dwr_start_time'];
          totalTimeWork.value = checkInDetails['total_time_work'] ?? '';
          workDay.value = checkInDetails['work_day'] ?? '';
          attendanceStatus.value = checkInDetails['work_day'] == 'done' ? 'done' : 'not_checked_in';



      } else if(status == 'Please Start Your Working Day .') {
          attendanceStatus.value = 'check_in';
        }

      } else {
        Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading(false);
    }
  }
}

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddAttendanceController extends GetxController {
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  // Fetch data from the API
  Future<void> fetchPostApi({
    required String odometerImg,
    required String exTdate,
    required String fkEtId,
    required String startDate,
    required String startTime,
    required String startLat,
    required String startLong,
    required String travelByVehicle,
    required String visitedRoute,
    required String startReadingKm,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/dwr_add_new.php'),
        body: {
          'dwr_start_odometer_img': odometerImg,
          'ex_tdate': exTdate,
          'fk_et_id': fkEtId,
          'dwr_start_date': startDate,
          'dwr_start_time': startTime,
          'dwr_start_lat': startLat,
          'dwr_start_long': startLong,
          'dwr_travel_by_vehicle': travelByVehicle,
          'dwr_visited_route': visitedRoute,
          'dwr_start_reading_km': startReadingKm,
        },
      );

      if (response.statusCode == 200) {
        responseMessage.value = 'Success: ${response.body}';
        print('addAttendance${response.body}');
      } else {
        responseMessage.value = 'Failed to send post request: ${response.statusCode}';
      }
    } catch (e) {
      responseMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

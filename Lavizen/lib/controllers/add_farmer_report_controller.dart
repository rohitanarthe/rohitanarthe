import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AddFarmerReportController extends GetxController{
  var isLoading = false.obs;
  var responseMessage = ''.obs;


  Future<void> addFarmerReport({
    required String custVisitImg,
    required String fkEtId,
    required String custVisitedLat,
    required String custVisitedLong,
    required String custVisitedPurpose,
    required String custFollowupDate,
    required String custVisitedRemark,
    required String fkCustId,
    required String layer_capacity,
    required String broiler_capacity,
    required String breader_capacity,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/add_farmer_visit.php?'),
        body: {
          'farm_visited_img': 'img',
          'fk_et_id': fkEtId,
          'farm_visited_lat': custVisitedLat,
          'farm_visited_long': custVisitedLong,
          'farm_visited_purpose': custVisitedPurpose,
          'farm_visited_followup_date': custFollowupDate,
          'farm_visited_remark': custVisitedRemark,
          'fk_farm_id': fkCustId,
          'layer_capacity': layer_capacity,
          'broiler_capacity': broiler_capacity,
          'breader_capacity': breader_capacity,

        },
      );

      if (response.statusCode == 200) {
        responseMessage.value = 'Success: ${response.body}';
        print('addAttendance${response.body.toString()}');

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

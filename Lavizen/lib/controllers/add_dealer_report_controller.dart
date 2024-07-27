import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AddDealerReportController extends GetxController{
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  Future<void> addDealerReport({
    required String custVisitImg,
    required String fkEtId,
    required String custVisitedLat,
    required String custVisitedLong,
    required String custVisitedPurpose,
    required String custFollowupDate,
    required String custVisitedRemark,
    required String fkCustId,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/add_dealer_visit.php?'),
        body: {
          'cust_visit_img': 'img',
          'fk_et_id': fkEtId,
          'cust_visited_lat': custVisitedLat,
          'cust_visited_long': custVisitedLong,
          'cust_visited_purpose': custVisitedPurpose,
          'cust_followup_date': custFollowupDate,
          'cust_visited_remark': custVisitedRemark,
          'fk_cust_id': fkCustId,
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

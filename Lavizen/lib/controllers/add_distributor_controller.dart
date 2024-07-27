import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class DealerController extends GetxController{
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  Future<void> addDealerWithVisited({
    required String custImg,
    required String custVisitImg,
    required String fkEtId,
    required String firmName,
    required String stateName,
    required String custAddr,
    required String custLat,
    required String custVisitedLat,
    required String custLong,
    required String custVisitedLong,
    required String custMobNo,
    required String custName,
    required String custVisitedPurpose,
    required String custFollowupDate,
    required String custVisitedRemark,
  }) async {
    isLoading.value = true;
    try {
    final response = await http.post(
      Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/add_dealer_with_visited.php'),
      body: {
        'cust_img': custImg,
        'cust_visit_img': custVisitImg,
        'fk_et_id': fkEtId,
        'firm_name': firmName,
        'state_name': stateName,
        'cust_addr': custAddr,
        'cust_lat': custLat,
        'cust_visited_lat': custVisitedLat,
        'cust_long': custLong,
        'cust_visited_long': custVisitedLong,
        'cust_mob_no': custMobNo,
        'cust_name': custName,
        'cust_visited_perpose': custVisitedPurpose,
        'cust_followup_date': custFollowupDate,
        'cust_visited_remark': custVisitedRemark,
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

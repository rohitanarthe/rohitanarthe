import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFarmerController extends GetxController {
  // Add a property to hold the response data
  var responseData = {}.obs;
  var isLoading = true.obs;
  var responseMessage = ''.obs;

  // Define the method to fetch data
  Future<void> addFarmer({
    required String farmImg,
    required String farmVisitedImg,
    required String fkEtId,
    required String farmName,
    required String farmMob,
    required String fkStateId,
    required String farmAddress,
    required String farmStartLat,
    required String farmVisitedLat,
    required String farmStartLong,
    required String farmVisitedLong,
    required String farmVisitedPurpose,
    required String farmVisitedRemark,
    required String farmVisitedFollowupDate,
    required String layerCapacity,
    required String broilerCapacity,
    required String breaderCapacity,
    required String purchaseMgrMobNo,
    required String purchaseMgrName,
  }) async {
    try {
      isLoading(true);

      // Construct the URL and parameters
      final url = Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/add_farmer_with_visited.php');
      final response = await http.post(
        url,
        body: {
          'farm_img': farmImg,
          'farm_visited_img': farmVisitedImg,
          'fk_et_id': fkEtId.toString(),
          'farm_name': farmName,
          'farm_mob': farmMob,
          'fk_state_id': fkStateId.toString(),
          'farm_address': farmAddress,
          'farm_start_lat': farmStartLat.toString(),
          'farm_visited_lat': farmVisitedLat.toString(),
          'farm_start_long': farmStartLong.toString(),
          'farm_visited_long': farmVisitedLong.toString(),
          'farm_visited_purpose': farmVisitedPurpose,
          'farm_visited_remark': farmVisitedRemark,
          'farm_visited_followup_date': farmVisitedFollowupDate,
          'layer_capacity': layerCapacity.toString(),
          'broiler_capacity': broilerCapacity.toString(),
          'breader_capacity': breaderCapacity.toString(),
          'purchase_mgr_mob_no': purchaseMgrMobNo,
          'purchase_mgr_name': purchaseMgrName,
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        responseData.value = jsonDecode(response.body);
        responseMessage.value = 'Success: ${response.body}';
        print('addAttendance${response.body.toString()}');

      } else {
        // Handle the error if needed
        print('Failed to add farmer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}

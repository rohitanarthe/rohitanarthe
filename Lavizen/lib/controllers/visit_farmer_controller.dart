// Controller
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lavizen/models/visit_farmer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VisitFarmerController extends GetxController {
  var isLoading = true.obs;
  var visitFarmerModel = FarmerVisitModel(farmerSearchReport: []).obs;

  @override
  void onInit() {
    super.onInit();
    fetchVisitDistributorData();
  }

  Future<void> fetchVisitDistributorData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? etId = pref.getString('et_id');
    final url = 'https://krushiapp.co.in/Lavizen/new_webservices/farmer_search_visit.php?fk_et_id=${etId}&farm_visited_lat=20.0121875&farm_visited_long=73.7583089';

    try {
      isLoading(true);
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var jsonData = json.decode(response.body);
          visitFarmerModel.value = FarmerVisitModel.fromJson(jsonData);
        } else {
          Get.snackbar('Error', 'Response body is empty');
          print('Error: Response body is empty');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch data: ${response.statusCode}');
        print('Error: Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
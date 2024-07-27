import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/visit_distributor_model.dart';

class VisitDistributorController extends GetxController {
  var isLoading = true.obs;
  var visitDistributorModel = VisitDistributorModel(dealerSearchReport: []).obs;
  var latitude = ''.obs;
  var longitude = ''.obs;
  var _locationMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation().then((_) {
      fetchVisitDistributorData();
    });
  }

  Future<void> fetchVisitDistributorData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? etId = pref.getString('et_id');
    final url = 'https://krushiapp.co.in/Lavizen/new_webservices/dealer_search_visit.php?fk_et_id=${etId}&cust_visited_lat=${latitude.value}&cust_visited_long=${longitude.value}';
print('url -------${url}');
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.toString()}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var jsonData = json.decode(response.body);
          print('${response.body.toString()}');
          visitDistributorModel.value = VisitDistributorModel.fromJson(jsonData);
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    _locationMessage.value = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    latitude.value = "${position.latitude}";
    longitude.value = "${position.longitude}";
    print('locationvisitMessage: ${_locationMessage.value}');
    print('latitude visit: ${latitude.value}');
    print('longitude visit: ${longitude.value}');
  }
}

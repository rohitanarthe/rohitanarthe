import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lavizen/constant/custom_toast/flutter_show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../database_helper/login_database_helper.dart';
import '../models/check_active_status_model.dart';
import '../models/login_model.dart';
import '../view/home_page/home_screen.dart';
import '../view/home_page/home_screen.dart';
import '../view/login/login_screen.dart';
import '../web_services/dio_service.dart';
import 'auth_controller.dart';


class LoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool obscureText = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late BuildContext context;
  final FocusNode passwordFocusNode = FocusNode();
  final AuthController _authController = Get.put(AuthController());
  SharedPreferences? pref;
  List<LoginData>? loginData;
  LoginDataModel? loginDataModel;
  final ApiService _apiService = ApiService();
  String? empFullName;
  String? empId;
  String? solaceId;
  String? empDesg;
  String? managerNm;
  String? center;
  String? managerId;
  String? isManager;
  String? jwt;
  var loginStatus = ''.obs;
  List<Map<String, dynamic>> _userData = [];

  Future<void> fetchLogin(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/login.php'),
      body: {'user': username, 'pass': password},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data.toString());
      loginStatus.value = data['result'];

      final List<dynamic> userDataList = data['data'];
      if (userDataList.isNotEmpty) {
        final Map<String, dynamic> userData = userDataList[0];
        loginStatus.value = data['result'];
        Get.defaultDialog(
          title: '${data['result']}',
          titleStyle: TextStyle(fontSize: 14),
          titlePadding: EdgeInsets.only(top: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.offAll(() => HomeScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text('OK'),
                ),
              ),
            ],
          ),
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
        );
        await DatabaseHelper().insertUserData(userData);
        loginDataModel = LoginDataModel.fromJson(data);
        String? empFullName = loginDataModel?.data?.first.etName;
        String? empId = loginDataModel?.data?.first.etId;
        String? mSettingId = loginDataModel?.data?.first.msetingId;
        SharedPreferences? pref = await SharedPreferences.getInstance();
        pref.setString('login_data', jsonEncode(loginDataModel!.data!.first));
        pref.setString("empFullName", empFullName!);
        pref.setString("et_id", empId!);
        pref.setString("mseting_id", mSettingId!);
        flutterShowToast('User Data save succesfully');
        _authController.setLoggedIn(true);
      }
    } else {
      loginStatus.value = 'Failed to login';
    }
    }

  Future<CheckActiveStatusModel> fetchData() async {
    String? et_id= pref?.getString('et_id').toString();
    final response = await http.get(Uri.parse('https://krushiapp.co.in/Lavizen/new_webservices/employee_live_status.php?$et_id'));
    if (response.statusCode == 200) {
      print("checkActive${response.toString()}");
      return checkActiveStatusModelFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<void> logout() async {
    pref?.remove('isLoggedIn');
    pref?.remove('empFullName');
    pref?.remove('empID');
    pref?.remove('solaceId');
    pref?.remove('empDesg');
    pref?.remove('empMangerNm');
    pref?.remove('center');
    pref?.remove('managerId');
    pref?.remove('jwt');
    emailController.clear();
    passwordController.clear();
    _authController.setLoggedIn(false);
    Get.back();
    Get.offAll(() => const LoginPage());
  }

  Future<void> submitLoginData(Map<String, dynamic> formData) async {
    try {
      isLoading.value = true;
      print('rrrrr');
      final response = await _apiService.postDataWithForm(formData);
      debugPrint("Response: $response");
      String jsonString = response.data;
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      String message = jsonMap['msg'];
      debugPrint("MESSSAGE:$message");
      if (jsonMap['success'] == true) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        loginDataModel = LoginDataModel.fromJson(jsonMap);
        String etName = loginDataModel?.data?.first.etName ??'';
        String etId = loginDataModel?.data?.first.etId ?? '';
        String etContact = loginDataModel?.data?.first.etContact??'';
        String etDesignation = loginDataModel?.data?.first.etDesignation ?? '';
        String etEmail = loginDataModel?.data?.first.etEmail?? '';
        String etStatus = loginDataModel?.data?.first.etStatus?? '';
        String etAdd = loginDataModel?.data?.first.etAdd?? '';

        SharedPreferences? pref = await SharedPreferences.getInstance();

        pref.setString('login_data', jsonEncode(loginDataModel!.data!.first));
        pref.setString("etName", etName);
        pref.setString("etId", etId);
        pref.setString('etDesignation', etDesignation);
        pref.setString("etAdd", etAdd);
        pref.setString("etContact", etContact);
        pref.setString("etEmail", etEmail);
        pref.setString("etStatus", etStatus);

        _authController.setLoggedIn(true);

        Get.to(() => HomeScreen());
        isLoading.value = true;
      } else {
        // Show the SnackBar using GetX
        Get.snackbar(
          'OOPS...!!',
          message,
          backgroundColor: Colors.white, // Customize the background color
          colorText: Colors.black, // Customize the text color
          snackPosition: SnackPosition.BOTTOM, // Position of the SnackBar
          duration: const Duration(seconds: 3), // Duration for which SnackBar is visible
          // You can also add more customization like borderRadius, margin, padding, etc.
        );
        isLoading.value = false;
      }
    } catch (error) {
      // Handle the error
      debugPrint('Error occurred: ${error.toString()} ');
      isLoading.value = false;
    }
  }

  Future<void> generateData(Map<String, dynamic> formData) async {
    try {
      isLoading.value = true;
      final response = await _apiService.postDataWithForm(formData);
      String jsonString = response.data;
      Map<dynamic, dynamic> jsonMap = jsonDecode(jsonString);
      String message = jsonMap['msg'];
      if (jsonMap['success'] == true) {
        Get.snackbar(
          'Success',
          message,
          backgroundColor: Colors.white, // Customize the background color
          colorText: Colors.black, // Customize the text color
          snackPosition: SnackPosition.BOTTOM, // Position of the SnackBar
          duration: const Duration(seconds: 3), // Duration for which SnackBar is visible
        );
        Get.to(() => const LoginPage());
        // Get.to(HomeScreen());
        isLoading.value = false;
      } else {
        // Show the SnackBar using GetX
        Get.snackbar(
          'OOPS...!!',
          message,
          backgroundColor: Colors.white, // Customize the background color
          colorText: Colors.black, // Customize the text color
          snackPosition: SnackPosition.BOTTOM, // Position of the SnackBar
          duration: const Duration(seconds: 3), // Duration for which SnackBar is visible
          // You can also add more customization like borderRadius, margin, padding, etc.
        );
        isLoading.value = false;
      }
    } catch (error) {
      // Handle the error
      print('Error occurred: $error');
      isLoading.value = false;
    }
  }
}

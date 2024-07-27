import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database_helper/login_database_helper.dart';
import 'login_controller.dart';

 LoginController loginController = Get.put(LoginController());

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;


  Future<void> checkLoginStatus() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("LOGGEDIN VALUE: ${ isLoggedIn.value}");
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }



  void setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    isLoggedIn.value = value;
  }
}

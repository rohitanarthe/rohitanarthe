import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';
import 'package:lavizen/controllers/login_controller.dart';

import '../../database_helper/login_database_helper.dart';
import '../home_page/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  LoginController controller = LoginController();
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, _checkDataAvailability);
  }

  void navigationPage() {
    Get.offAll(() => const LoginPage());
  }


  Future<void> _checkDataAvailability() async {
    try {
      final dbHelper = DatabaseHelper();
      final hasData = await dbHelper.hasData();
      if (mounted) {
      if (hasData) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }}
    } catch (e) {
      print('Error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1,backgroundColor: AppColors.primaryColor,),
      body: Center(
        child: Container(
            height: 300,
            width: double.infinity,
            child: Image.asset('assets/images/lavizen_splash_logo.png'),
        )
      ),
    );
  }
}

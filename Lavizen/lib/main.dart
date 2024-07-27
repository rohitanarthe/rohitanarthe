import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:lavizen/view/home_page/home_screen.dart';
import 'package:lavizen/view/splash_screen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp( MyApp());
}
//008dd2
//33008DD2
//21a73f
//a62727

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = Get.put(AuthController());

  // This widget is the root of your application.
  Future<void> _requestPermissions() async {
    // Request camera and photo library permissions
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    var photoStatus = await Permission.photos.status;
    if (!photoStatus.isGranted) {
      await Permission.photos.request();
    }
  }
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return GetMaterialApp(
        home: SplashScreen()
    );
  }
}

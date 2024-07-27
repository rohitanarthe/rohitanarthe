import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';

import '../../controllers/check_attendance_status_controller.dart';

class CheckinCheckoutWidgets extends StatelessWidget {
  final String  title;
  final String  text;
  final VoidCallback? onPressed;

  CheckinCheckoutWidgets({ required this.title,  required this.text,   this.onPressed,});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color cardColor;
    double? titleTextSize;
    FontWeight titleFontWeight;
    final AttendanceController attendanceController =
    Get.put(AttendanceController());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formatterTime = DateFormat('hh:mm').format(now);

    if (title.contains('CHECK IN')) {
      cardColor = Colors.green;
      titleTextSize= 18;
      titleFontWeight= FontWeight.normal;
    }
    else if (title.contains('CHECK OUT')) {
      cardColor = Colors.red;
      titleTextSize = 18.0;// Color for non-empty text
    }
    else if (title.contains(attendanceController.totalTimeWork.value)) {
      cardColor = Colors.white;
      titleTextSize = 18.0;// Color for non-empty text
    }

    else {
      cardColor = Colors.white; // Default color
    }
    String checkInTime = attendanceController.checkInTime.value.isEmpty
        ? "00:00:00"
        : attendanceController.checkInTime.value;



    Color titleTextColor;
    if (title.contains(formattedDate)) {
      titleTextColor = Colors.blue[900]!;
      titleTextSize=14.0;
    } else if (title.contains(checkInTime)){
      titleTextColor = Colors.red ; // Default text color
    }else if (title.contains('CHECK IN')){
      titleTextColor = Colors.white ; // Default text color
    }else if (title.contains('CHECK OUT')){
      titleTextColor = Colors.white ; // Default text color
    }
    else if (title.contains(attendanceController.totalTimeWork.value)) {
      titleTextColor = Colors.red ; // Default text color
    }
    else{
      titleTextColor = Colors.white;
    }
    Color textColor;
    double? textSize;
    if (text.contains('Working Date')) {
      textColor = Colors.green; // Color for text containing 'important'
    }else if(text.contains('Check In Time')){
      textColor = Colors.green;
      titleTextSize=14.0;
    }
    else if(text.contains('Work Time')){
      textColor = Colors.green;
      titleTextSize=14.0;
    }

    else {
      textColor = Colors.black; // Default text color
    }

    return Container(
      width: screenWidth * 0.33, // Adjust the width to 33% of the screen width
      height: 80,
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.0), // Optional: Add border radius
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    title??'', // Handle null title
                    style: TextStyle(
                      color: titleTextColor,
                      fontSize: titleTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (title.isNotEmpty)
                const SizedBox(height: 6.0),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    text??'', // Handle null text
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        )
      ),
    );
  }
}

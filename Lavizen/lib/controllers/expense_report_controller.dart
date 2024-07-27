import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/check_attendance_status_model.dart';

class AttendanceStatusController extends GetxController {
  var attendanceStatus = AttendanceStatusModel(data: [], result: '').obs;
  var isLoading = true.obs;
  var exTdate = ''.obs;
  var selectedDate = DateTime.now().obs;
  var directBill = ''.obs;
  var vehicle = ''.obs;
  var visitedRoute = ''.obs;
  var ptrReading = ''.obs;
  var fourWheel = ''.obs;
  var twoWheel = ''.obs;

  var fourWheelKmValue = 0.0.obs;
  var twoWheelKmValue = 0.0.obs;

  var vehicleKmValue=0.0.obs;

  var totalKm = 0.0.obs;
  var vehicleExpense = 0.0.obs;
  var calculatedTotalKm = 0.0.obs;


  var totalKmCalculated = 0.0.obs;
  var calculatedValue = 0.0.obs;
  var closingReading = 0.0.obs;

  var hqDA = ''.obs;
  var exHqDA = ''.obs;
  var osDA= ''.obs;

  String get formattedDate {
    // Define your desired format here
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(selectedDate.value);
  }

  void openReading(String openingReading) {
    ptrReading.value = openingReading;
  }



  @override
  void onInit() {
    exTdate.value = DateFormat('yyyy-MM-dd').format(selectedDate.value);

    fetchAttendanceStatus();
    super.onInit();
  }

  void calculateTotalKm() {
    print('calculate');
    if (attendanceStatus.value.data.isNotEmpty) {
      var firstDatum = attendanceStatus.value.data.first;
      totalKmCalculated.value = closingReading.value - double.parse(firstDatum.ptrStartReading);
      print('-------${totalKmCalculated.value}');
      if (firstDatum.directBill== "no") {
        if (firstDatum.dwrTravelByVehicle== "Car") {
          vehicleKmValue.value =  double.parse(firstDatum.fourWheel);
          print('=-vehcile value----${vehicleKmValue.value.toString()}');
          calculatedValue.value = totalKmCalculated.value * double.parse(firstDatum.fourWheel);
        } else if (firstDatum.dwrTravelByVehicle == "Bike") {
          twoWheel.value.toString();
          calculatedValue.value = totalKmCalculated.value * double.parse(firstDatum.twoWheel);
          vehicleKmValue.value =  double.parse(firstDatum.twoWheel);
          print('-------${twoWheelKmValue.value.toString()}');
          print('Bikee'+calculatedValue.value.toString());
          String valueToSend='';
          if (vehicle.value == "Car") {
            valueToSend = fourWheel.value.toString();
          } else if (vehicle.value == "Bike") {
            valueToSend = twoWheel.value.toString();
          } else {
            // Handle cases where the vehicle type is neither Car nor Bike
            valueToSend = "0"; // Or any default value as needed
          }
          print('valueto send${valueToSend}');
        } else {
          calculatedValue.value = 0;
        }
      } else {
        calculatedValue.value = 0;
      }
    }
  }

  void fetchAttendanceStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? et_id = pref.getString('et_id');

    final url = Uri.parse(
        'https://krushiapp.co.in/Lavizen/new_webservices/check_attendence_entry_new_for_img.php?fk_et_id=$et_id&ex_tdate=${exTdate.value}');
    print(url);

    try {
      isLoading(true);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print(response.body.toString());

        attendanceStatus.value = AttendanceStatusModel.fromJson(jsonResponse);

        // Extract values from the parsed AttendanceStatusModel
        if (attendanceStatus.value.data.isNotEmpty) {
          var firstDatum = attendanceStatus.value.data.first;
          vehicle.value = firstDatum.dwrTravelByVehicle;
          fourWheel.value=firstDatum.fourWheel;
          twoWheel.value=firstDatum.twoWheel;
          visitedRoute.value = firstDatum.dwrVisitedRoute;
          directBill.value=firstDatum.directBill;
          hqDA.value = firstDatum.returnToHeadQuaDa;
          exHqDA.value = firstDatum.exHeadQuaDa;
          osDA.value = firstDatum.outOfHeadQuaDa;
          directBill.value = firstDatum.directBill;

          if (firstDatum.dwrTravelByVehicle == "Car") {
            fourWheel.value = firstDatum.fourWheel;
          } else if (firstDatum.dwrTravelByVehicle == "Bike") {
            twoWheel.value = firstDatum.twoWheel;
          }

        } else {
          // Handle the case where the data list is empty
          vehicle.value = 'N/A';
          visitedRoute.value = 'N/A';
          hqDA.value = 'N/A';
          exHqDA.value = 'N/A';
          osDA.value = 'N/A';
          directBill.value = 'N/A';
        }

        print('visited route: ${visitedRoute.value}');
        print('vehicle: ${vehicle.value}');
      } else {
        Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }



  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    exTdate.value = DateFormat('yyyy-MM-dd').format(date);
    fetchAttendanceStatus();
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

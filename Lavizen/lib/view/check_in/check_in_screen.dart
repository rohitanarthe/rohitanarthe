import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/view/home_page/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/colors_string_constant/color_string_constant.dart';
import '../../constant/custom_toast/flutter_show_toast.dart';
import '../../controllers/add_attendance_controller.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller_vehicle_type = TextEditingController();
  TextEditingController _controller_km_reading = TextEditingController();
  TextEditingController _controller_bike_route = TextEditingController();
  final AddAttendanceController attendanceController =
      Get.put(AddAttendanceController());

  File? _image;
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
   //   await _sendImage(_image!);

    }else if(pickedFile == null){
      flutterShowToast('Capture Opening Reading');
    }
  }
   Future<void> _sendImage(File imageBytes) async {
    // Convert image to base64 string
    final bytes = await imageBytes.readAsBytes();
    final base64Image = base64Encode(bytes);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formatterTime = DateFormat('hh:mm').format(now);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? et_id = pref.getString('et_id');

    await attendanceController.fetchPostApi(
      odometerImg: base64Image,
      exTdate: formattedDate,
      fkEtId: et_id.toString(),
      startDate: formattedDate,
      startTime: formatterTime,
      startLat: '12.345678',
      startLong: '98.765432',
      travelByVehicle: _controller_vehicle_type.text,
      visitedRoute: _controller_bike_route.text,
      startReadingKm: _controller_km_reading.text,
    );
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          title: const Center(
              child: Text(
            'Select Vehicle Type',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          )),
          content: Container(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                height: 200,
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: vehicleTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(vehicleTypes[index]),
                      onTap: () {
                        setState(() {
                          _controller_vehicle_type.text = vehicleTypes[index];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.blue, // Divider color
                      thickness: 2,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formatterTime = DateFormat('hh:mm').format(now);
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          toolbarHeight: 1,
          backgroundColor: AppColors.primaryColor,
        ),
        body: Obx(() {
          if (attendanceController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, right: 10, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                        border: Border.all(color: Colors.red, width: 3)),
                    height: 600,
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          color: AppColors
                              .checkInBgDate, // Background color for the text
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .start, // Center the text within the container
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    formatterTime,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign
                                        .end, // Center the text within the container
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _showPopup,
                                  child: AbsorbPointer(
                                    child: Container(
                                      height: 40,
                                      child: TextFormField(
                                        controller: _controller_vehicle_type,
                                        decoration: InputDecoration(
                                          labelText: 'Travelled By',
                                          border: const OutlineInputBorder(),
                                          hintStyle: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  0.2)), // Set hint text opacity
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            flutterShowToast(
                                                'please select travelled by');
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  children: [
                                    // Optional: Add some space between the asterisk and the text
                                    Text(
                                      "Enter start km reading",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _controller_km_reading,
                                    decoration: InputDecoration(
                                      labelText: 'Opening km reading',
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(
                                              0.2)), // Set hint text opacity
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        flutterShowToast(
                                            'please enter km reading');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  children: [
                                    // Optional: Add some space between the asterisk and the text
                                    Text(
                                      "Toaday's Route",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  child: TextFormField(
                                    controller: _controller_bike_route,
                                    decoration: InputDecoration(
                                      labelText: 'Route',
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(
                                              0.2)), // Set hint text opacity
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        flutterShowToast('please enter route');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  children: [
                                    // Optional: Add some space between the asterisk and the text
                                    Text(
                                      "Capture Start km Meter Reading",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _image == null
                                        ? Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 2)),
                                            child: const Center(
                                                child: Text(
                                              'No image selected.',
                                              textAlign: TextAlign.center,
                                            )))
                                        : Image.file(_image!),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 200,
                                      height: 30, // Adjust the width as needed
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _openCamera();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.amber,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0)),
                                          ),
                                        ),
                                        child: const Center(
                                            child: Text(
                                          'CAPTURE IMAGE',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: SizedBox(
                                    width: 120,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        SharedPreferences? pref =
                                            await SharedPreferences
                                                .getInstance();
                                        String? etId = pref.getString('et_id');
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _showConfirmationDialog();

                                          // if (_image == null) {
                                          //   flutterShowToast('Please Capture Image');
                                          // }
                                        } else {
                                          _sendImage(_image!);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      'Note: All(*) fields are mandatory',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width ,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Submit Opening km Meter Reading ?',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        SharedPreferences? pref = await SharedPreferences.getInstance();
                        String? etId = pref.getString('et_id');
                        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                        String formatterTime = DateFormat('hh:mm').format(now);

                        await attendanceController.fetchPostApi(
                          odometerImg: 'img',
                          exTdate: formattedDate,
                          fkEtId: etId.toString(),
                          startDate: formattedDate,
                          startTime: formatterTime,
                          startLat: '20.0968089',
                          startLong: '73.2901243',
                          travelByVehicle: _controller_vehicle_type.text,
                          visitedRoute: _controller_bike_route.text,
                          startReadingKm: _controller_km_reading.text,
                        );
                        Get.to(HomeScreen());
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _controller_vehicle_type.dispose();
    super.dispose();
  }

  final List<String> vehicleTypes = [
    'Bike',
    'Car',
    'Office Vehicle',
    'No Vehicle',
  ];
}

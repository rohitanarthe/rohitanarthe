import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/font_style/font_style.dart';
import 'package:lavizen/view/check_in/check_in_screen.dart';
import 'package:lavizen/view/dwr_report/distributor/add_distributor/add_distributor_screen.dart';
import 'package:lavizen/view/dwr_report/dwr_report_screen.dart';
import 'package:lavizen/view/dwr_report/expense_report/expense_report.dart';
import 'package:lavizen/view/dwr_report/expense_report/expense_report_screen.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/colors_string_constant/color_string_constant.dart';
import '../../constant/image_string/image_strings.dart';
import '../../controllers/check_attendance_status_controller.dart';
import '../../controllers/login_controller.dart';
import '../../database_helper/login_database_helper.dart';
import '../../models/check_in_model.dart';
import '../../widgets/card_widgets/card_widgets.dart';
import '../../widgets/card_widgets/checkin_checkout_widgets.dart';
import '../login/login_screen.dart';
import '../new_order/new_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var size, height, width;
  Rx<bool> isCheckIn = false.obs;
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _userData = [];
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  bool isCheckedIn = false;
  String? et_name;
  String _locationMessage = "";
  String latitude = "";
  String longitude = "";

  Future<void> _deleteRecord(String etId) async {
    final result = await dbHelper.deleteData(etId);
    if (result > 0) {
      print('Record deleted successfully');
    } else {
      print('Record not found');
    }
  }

  late Future<CheckAttendanceModel?> futureAttendance;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkStatus();
    attendanceController.fetchAttendanceStatus();

    _getCurrentLocation();
  }

  void navigateBasedOnTitle(String title) {
    if (title.contains('CHECK OUT')) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DwrReportScreen()));
    }
  }

  void _showLocationServicesDisabledPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    geo.LocationPermission permission;
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServicesDisabledPopup();
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
    setState(() {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      latitude="Latitude: ${position.latitude}";
      longitude="Longitude: ${position.longitude}";
      print('locationMessgae${_locationMessage}');
      print('locationMessgae${latitude}');
      print('locationMessgae${longitude}');
    });
  }

  Future<void> _checkStatus() async {
    try {
      final data = await loginController.fetchData();
      if (data.data!.isNotEmpty) {
        final status = data.data![0].etStatus;
        if (status == '1') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _fetchData() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    et_name = pref.getString('empFullName').toString();
    String? mSettingId = pref.getString('mseting_id');
    print('mmmmmm${mSettingId}');
    try {
      final data = await DatabaseHelper().getUserData();
      setState(() {
        _userData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget _buildFutureBuilder() {
    return FutureBuilder<CheckAttendanceModel?>(
      future: futureAttendance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final title = snapshot.data?.sucess;
          Color cardColor;
          double? titleTextSize;
          FontWeight titleFontWeight = FontWeight.normal;
          if (title != null && title.contains('CHECK IN')) {
            cardColor = Colors.green;
            titleTextSize = 18;
          } else if (title != null && title.contains('CHECK OUT')) {
            cardColor = Colors.red;
            titleTextSize = 18.0;
          } else {
            cardColor = Colors.white;
          }
          return Center(
            child: Container(
              color: cardColor,
              child: Text(
                title ?? 'No Title',
                style: TextStyle(
                    fontSize: titleTextSize, fontWeight: titleFontWeight),
              ),
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formatterTime = DateFormat('hh:mm').format(now);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: SizedBox(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/sidemenu.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          title: Center(
            child: const Text(
              'Lavizen',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          // Center align the title
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    child: Image.asset('assets/images/followupcnt.png'),
                  ),
                  const Positioned(
                    top: 10,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 8, // Adjust the radius as needed for your design
                      child: Text(
                        '10', // Replace with your dynamic number count
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        drawer: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 18, color: Colors.amber),
                      ),
                      Text(
                        "$et_name",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text(' My Profile '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text(' My Course '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium),
                  title: const Text(' Go Premium '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.video_label),
                  title: const Text(' Saved Videos '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text(' Edit Profile '),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('LogOut'),
                  onTap: () async {
                    SharedPreferences? pref =
                        await SharedPreferences.getInstance();
                    String? et_id = pref.getString('et_id').toString();
                    _deleteRecord(et_id.toString());
                    loginController.logout();
                  },
                ),
              ],
            ),
          ),
        ), //Drawer
        body: Obx(() {
          if (attendanceController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    thickness: 2,
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              0), // Adjust the border radius as needed
                        ),
                        child: Center(
                          child: Text(
                            "TODAY'S WORK",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Wrap(
                              spacing: 0.0, // Horizontal space between children
                              runSpacing: 0.0, // Vertical space between rows
                              alignment: WrapAlignment
                                  .start, // Align the widgets horizontally
                              children: [
                                CheckinCheckoutWidgets(
                                  title: '$formattedDate',
                                  text:
                                      'Working Date', // Replace with your actual image asset path
                                ),
                                CheckinCheckoutWidgets(
                                  title: attendanceController
                                          .checkInTime.value.isEmpty
                                      ? "00:00:00"
                                      : attendanceController.checkInTime.value,
                                  text:
                                      'Check In Time', // Replace with your actual image asset path
                                ),
                                // Add the dynamic button based on attendance status
                      Obx(() {
                        if (attendanceController.attendanceStatus.value == 'not_checked_in') {
                          return GestureDetector(
                            onTap: () {
                              Get.to(ExpenseReport());
                            },
                            child: CheckinCheckoutWidgets(
                              title: 'CHECK OUT',
                              text: '',
                              onPressed: () {},
                            ),
                          );
                        } else if (attendanceController.attendanceStatus.value == 'check_in') {
                          return GestureDetector(
                            onTap: () {
                              print('object');
                              Get.to(CheckInScreen());
                            },
                            child: CheckinCheckoutWidgets(
                              title: 'CHECK IN',
                              text: '',
                              onPressed: () {},
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                            },
                            child: CheckinCheckoutWidgets(
                              title: attendanceController
                                  .totalTimeWork.value.isEmpty
                                  ? "00:00:00"
                                  : attendanceController.totalTimeWork.value,
                              text: 'Work Time',
                              onPressed: () {},
                            ),
                          );
                        }
                      }),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width *
                        MediaQuery.of(context).size.height /
                        2,
                    child: Card(
                      color: AppColors.orderBg,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            0), // Adjust the border radius as needed
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Order",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewOrderScreen()));
                                },
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.all(0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(takeOrder,
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: 80),
                                        const SizedBox(height: 10.0),
                                        const Text('New Order',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.all(0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(orderhistory,
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: 80),
                                        const SizedBox(height: 10.0),
                                        const Text(
                                          'Order History',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text("Payment", style: AppTextStyles.bodyText1),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the radius here
                              child: Card(
                                color: AppColors.primaryColor,
                                margin: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(addpayment,
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60),
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      'Add Payment',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Set the radius here
                              child: Card(
                                color: AppColors.primaryColor,
                                margin: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(paymenthistory,
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60),
                                    const SizedBox(height: 10.0),
                                    const Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          'Payment History',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: AppColors.primaryColor,
                    ),
                    Text("Information", style: AppTextStyles.bodyText1),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Wrap(
                        spacing: 1.0, // Horizontal space between children
                        runSpacing: 2.0, // Vertical space between rows
                        alignment: WrapAlignment
                            .start, // Center the widgets horizontally
                        children: [
                          CardWidget(
                            title: 'Company Profile',
                            imagePath:
                                'assets/images/companyprofile1.png', // Replace with your actual image asset path
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CardWidget(
                            title: 'Product Price',
                            imagePath:
                                'assets/images/products.png', // Replace with your actual image asset path
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CardWidget(
                            title: 'Price List',
                            imagePath:
                                'assets/images/productspricelist.png', // Replace with your actual image asset path
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CardWidget(
                            title: 'Report',
                            imagePath:
                                'assets/images/mis_report_icon.png', // Replace with your actual image asset path
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Activity", style: AppTextStyles.bodyText1),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    spacing: 0.0, // Horizontal space between children
                    runSpacing: 0.0,
                    children: [
                      Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width *
                            MediaQuery.of(context).size.height /
                            2,
                        child: Card(
                          color: AppColors.orderBg,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Adjust the border radius as needed
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DwrReportScreen()));
                                    },
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(report1,
                                                fit: BoxFit.cover,
                                                height: 80,
                                                width: 80),
                                            const SizedBox(height: 6.0),
                                            const Text('D.W.R.',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(leave,
                                                fit: BoxFit.cover,
                                                height: 80,
                                                width: 80),
                                            const SizedBox(height: 6.0),
                                            const Text(
                                              'Leave',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(),
                ],
              ),
            ); /*
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomAppBar(
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );*/
          }
        }));
  }
}

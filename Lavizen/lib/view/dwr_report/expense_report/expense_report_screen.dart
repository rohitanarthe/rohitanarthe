import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lavizen/controllers/checkOut_report_add_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/expense_report_controller.dart';

class ExpenseReportScreen extends StatefulWidget {
  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final AttendanceStatusController attendanceStatusController =
      Get.put(AttendanceStatusController());
  final CheckoutReportAddController recordController = Get.put(CheckoutReportAddController());

  TextEditingController _dateController = TextEditingController();
  TextEditingController closingController = TextEditingController();
  TextEditingController busController = TextEditingController();
  TextEditingController railController = TextEditingController();
  TextEditingController lodgingBillController = TextEditingController();
  TextEditingController otherExpController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController vehicleExpController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final resultController = TextEditingController();
  final totalResultController = TextEditingController();

  final String returnToHeadQuaDa = '100';
  final String outOfHeadQuaDa = '200';
  final String exHeadQuaDa = '0';

  double totalKm = 0.0;
  double vehicleExp = 0.0;
  String vehicleType = '';
  int _selectedValue = 0;



  double daValue = 0.0;
  double totalExpense = 0.0;


  @override
  void initState() {
    super.initState();
    closingController = TextEditingController(text: '0');
    busController = TextEditingController(text: '0');
    railController = TextEditingController(text: '0');
    lodgingBillController = TextEditingController(text: '0');
    otherExpController = TextEditingController(text: '0');
    closingController.addListener(_updateTotalKm);
    vehicleExpController.addListener(_updateTotalKm);
    _textController.addListener(_updateTextField);
    _textController.addListener(_updateTotalExpField);
    busController.addListener(_updateTotalExpField);
    railController.addListener(_updateTotalExpField);
    lodgingBillController.addListener(_updateTotalExpField);


  }


  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _textController.dispose();
    closingController.dispose();
    super.dispose();
  }

  void _updateTextField() {
    switch (_selectedValue) {
      case 0:
        _textController.text = attendanceStatusController.hqDA.value.toString();
        break;
      case 1:
        _textController.text = attendanceStatusController.exHqDA.value.toString();
        break;
      case 2:
        _textController.text = attendanceStatusController.osDA.value.toString();
        break;
      default:
        _textController.text = '';
        break;
    }
  }

  /* void _updateTotalExpField() {
    daValue = double.tryParse(_textController.text) ?? 0.0;
     totalExpense = attendanceStatusController
         .calculatedValue
         .value + daValue;
     print('---toatal expe${totalExpense}');
    totalResultController.text = totalExpense.toStringAsFixed(2); // Format to 2 decimal places
  }*/

  void _updateTotalExpField() {
    print('total exp');
    double busFare = double.tryParse(busController.text) ?? 0.0;
    double railFare = double.tryParse(railController.text) ?? 0.0;
    double lodgingBill = double.tryParse(lodgingBillController.text) ?? 0.0;
    double otherExp = double.tryParse(otherExpController.text) ?? 0.0;
    double daValue = double.tryParse(_textController.text) ?? 0.0;

print("-------calcu${attendanceStatusController.calculatedValue.value}");
    totalExpense = attendanceStatusController.calculatedValue.value +
        daValue +
        busFare +
        railFare +
        otherExp +
        lodgingBill;

    print('---total expense: $totalExpense');
    totalResultController.text =
        totalExpense.toStringAsFixed(2); // Format to 2 decimal places
  }

  void _updateTotalKm() {
    final closingReading = double.tryParse(closingController.text);
    if (closingReading != null && closingReading != 0.0) {
      final openingReadingDouble =
          double.tryParse(attendanceStatusController.ptrReading.value) ?? 0.0;
      if (openingReadingDouble >= 0.0) {
        setState(() {
          totalKm = closingReading - openingReadingDouble;
        /*  print('-ttttttt${totalKm.toString()}');
          print('-----'+attendanceStatusController.directBill.value);
          print('---four--'+attendanceStatusController.fourWheel.toString());

          if (attendanceStatusController.directBill.value == "no" &&
              attendanceStatusController.vehicle.value == "Car") {
            vehicleExp = totalKm * fourWheel;
            print('---veh--${vehicleExp.toString()}');
            print('totalKm $totalKm');

        } else if (attendanceStatusController.directBill.value == "no" &&
              attendanceStatusController.vehicle.value == "Bike") {
              vehicleExp = totalKm * twoWheel;
          }*/

        /*  resultController.text =
              vehicleExp.toStringAsFixed(2);*/
          print('------udate--${totalKm.toString()}');
        });
      }
    }
  }

 /* void _updateTotalVehicleExp() {
    print('vehicle exp');
    final vehicle = double.tryParse(vehicleExpController.text);

    if (totalKm >= 0.0) {
      setState(() {
        vehicleExp = totalKm * 10;
        vehicleExp = vehicle!;
        print('-------$vehicleExp');
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        return GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  attendanceStatusController.selectedDate.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                          },
                          child: Container(
                            width: double.maxFinite,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(strokeAlign: 0.1, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () async {},
                                  child: Text(
                                    attendanceStatusController.getFormattedDate(
                                        attendanceStatusController
                                            .selectedDate.value),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(Icons.calendar_month),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: double.maxFinite,
                        child: Obx(() {
                          if (attendanceStatusController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: attendanceStatusController
                                    .attendanceStatus.value.data.length,
                                itemBuilder: (context, index) {
                                  var datum = attendanceStatusController
                                      .attendanceStatus.value.data[index];
                                  attendanceStatusController
                                      .openReading(datum.ptrStartReading);

                                  final double twoWheelValue =
                                      double.tryParse(datum.twoWheel) ?? 0.0;
                                  final double fourWheelValue =
                                      double.tryParse(datum.twoWheel) ?? 0.0;


                                  return Column(
                                    children: [
                                      datum.dwrTravelByVehicle.isNotEmpty?
                                        Container(
                                          width: double.maxFinite,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                strokeAlign: 0.1, width: 0.5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 5),
                                            child: Text(
                                              '${attendanceStatusController.vehicle.toString()}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ):
                                      Container(
                                      width: double.maxFinite,
                                      height: 30,
                                      decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(
                                      Radius.circular(10)),
                                      border: Border.all(
                                      strokeAlign: 0.1, width: 0.5),
                                      ),
                                      child: Padding(
                                      padding: const EdgeInsets.only(
                                      top: 5, left: 5),
                                      child: Text(
                                      '${'Travelled by'}',
                                      style:
                                      const TextStyle(fontSize: 16),
                                      ),
                                      ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (datum.dwrVisitedRoute.isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Opacity(
                                              opacity: 0.8,
                                              child: Text(
                                                'Route Visited: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  2,
                                              height: 30,
                                              child: TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: datum
                                                            .dwrVisitedRoute),
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 5, left: 10),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (datum.ptrStartReading.isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Opacity(
                                              opacity: 0.8,
                                              child: Text(
                                                'Opening Reading',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  2,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                    strokeAlign: 0.1,
                                                    width: 0.5),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 5),
                                                child: Text(
                                                  '${datum.ptrStartReading}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Closing Reading: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              onChanged: (value) {
                                                attendanceStatusController
                                                        .closingReading.value =
                                                    double.tryParse(value) ??
                                                        0.0;
                                                attendanceStatusController
                                                    .calculateTotalKm();
                                              },
                                              controller: closingController,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2.5,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  strokeAlign: 0.1, width: 1),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Capture Image',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons
                                                        .photo_camera, // or any other photo-related icon
                                                    size:
                                                        24, // Adjust size as needed
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'View Closing Image',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Total Km :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  strokeAlign: 0.1, width: 0.5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Text(
                                                totalKm == 0
                                                    ? '0'
                                                    : totalKm.toStringAsFixed(
                                                        1), // Conditional formatting
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Bus Fair :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              controller: busController,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              onChanged: (value) =>
                                                  _updateTotalExpField(), // Call update method on change

                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Rail Fair :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              controller: railController,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              onChanged: (value) =>
                                                  _updateTotalExpField(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2.5,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  strokeAlign: 0.1, width: 1),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Ticket Image',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons
                                                        .photo_camera, // or any other photo-related icon
                                                    size:
                                                        24, // Adjust size as needed
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'View Ticket Image',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.grey[300],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Vehicle Exp: ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        2,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          strokeAlign: 0.1,
                                                          width: 0.5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 10,
                                                              bottom: 5),
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        controller:
                                                            TextEditingController(
                                                          text: attendanceStatusController.calculatedValue.value.toStringAsFixed(2)
                                                        ),
                                                        readOnly: true,
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        2.5,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[200],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          strokeAlign: 0.1,
                                                          width: 1),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5, left: 5),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Capture Image',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Icon(
                                                            Icons
                                                                .photo_camera, // or any other photo-related icon
                                                            size:
                                                                24, // Adjust size as needed
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'View Car Bill Image',
                                                    style: TextStyle(
                                                        decoration:
                                                        TextDecoration.underline,
                                                        decorationColor: Colors.red,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Lodging Bill :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              controller: lodgingBillController,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              onChanged: (value) =>
                                                  _updateTotalExpField(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  2.5,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[200],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                    strokeAlign: 0.1, width: 1),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, left: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Capture Image',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons
                                                          .photo_camera, // or any other photo-related icon
                                                      size:
                                                          24, // Adjust size as needed
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'View Closing Image',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.grey[300],
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Radio<int>(
                                                    value: 0,
                                                    groupValue: _selectedValue,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _selectedValue = value!;
                                                        _updateTextField();
                                                      });
                                                    },
                                                  ),
                                                  const Text('Base\nLocation',style: TextStyle(fontWeight: FontWeight.bold)),
                                                  Radio<int>(
                                                    value: 1,
                                                    groupValue: _selectedValue,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _selectedValue = value!;
                                                        _updateTextField();
                                                      });
                                                    },
                                                  ),
                                                  const Text('Outstation',style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Radio<int>(
                                                    value: 2,
                                                    groupValue: _selectedValue,
                                                    onChanged: (int? value) {
                                                      setState(() {
                                                        _selectedValue = value!;
                                                        _updateTextField();
                                                      });
                                                    },
                                                  ),
                                                  const Text('Ex.HQ',style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'D.A.Amount: ',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width /
                                                          2,
                                                      height: 30,
                                                      child: TextField(
                                                        controller:
                                                            _textController,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 10),
                                                          hintText: '0',
                                                          hintStyle: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Other Exp :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              controller: otherExpController,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              onChanged: (value) =>
                                                  _updateTotalExpField(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Opacity(
                                            opacity: 0.8,
                                            child: Text(
                                              'Remark :',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            height: 30,
                                            child: TextField(
                                              controller: remarkController,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Remark',
                                                contentPadding: EdgeInsets.only(
                                                    top: 5, left: 10),
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                        thickness: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Total:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                4,
                                            child: TextField(
                                              controller: totalResultController,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          }
                        }),
                      ),
                    ])),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences? pref = await SharedPreferences.getInstance();
                String? etId = pref.getString('et_id');
    print('Odometer Image: img');
    print('date -${attendanceStatusController.formattedDate.toString()}');
    print('Employee ID: $etId');
    print('Bus Fair: ${busController.text}');
    print('Rail Fair: ${railController.text}');
    print('Lodging Bill:${lodgingBillController.text}');
    print('DA: ${_textController.text}');
    print('Other Expenses: ${otherExpController.text}');
    print('Visited Route: ${attendanceStatusController.visitedRoute.value.toString()}');
    print('Start Reading KM: ${attendanceStatusController.ptrReading.value.toString()}');
    print('End Reading KM: ${closingController.text}');
    print('Total KM: $totalKm');
    print('VehicleExp: ${attendanceStatusController.calculatedValue.value.toStringAsFixed(2)}');
    print('Other Remark: ${remarkController.text}');
    print('Travel by Vehicle: ${attendanceStatusController.vehicle.toString()}');
    print('End Latitude: 888');
    print('End Longitude: 9999');
    print('kmValue--${attendanceStatusController.vehicleKmValue.toString()}');
    print('Total Expenses: ${totalResultController.text}');
                _showConfirmationDialog();
/*

                recordController.fetchPostApi(
                  odometerImg: 'img',
                  exTdate: attendanceStatusController.formattedDate.toString(),
                  fkEtId: etId.toString(),
                  dwrBusFair: busController.text,
                  dwrRailFair: railController.text,
                  dwrLodgingBill: lodgingBillController.text,
                  dwrDa: _textController.text,
                  dwrOtherExpenses: otherExpController.text,
                  dwrVisitedRoute: attendanceStatusController.visitedRoute.value.toString(),
                  dwrStartReadingKm: attendanceStatusController.ptrReading.value.toString(),
                  dwrEndReadingKm:  closingController.text,
                  dwrTotalKm: totalKm.toString(),
                  dwrOtherRemark: remarkController.text,
                  dwrTravelByVehicle: vehicleType.toString(),
                  dwrEndLat: '20.01208v71',
                  dwrEndLong: '73.7608862',
                  dwrTotalExpenses: totalResultController.text,
                  exFuel: '',
                  dwrRatePerKm: '',
                  lodgingImg: 'lodingimg',
                  fuelImg: 'fuelImg',
                  ticketImg: 'ticketImg',
                );*/
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
              child: const Text('SUBMIT'),
            ),
          ),
        ),
      ]),
    );
  }
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: MediaQuery.sizeOf(context).height/5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all( 10),
                  child:  Text(
                    'Total Expenses : Rs.${totalExpense.toString()}/-',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          SharedPreferences? pref = await SharedPreferences.getInstance();
                          String? etId = pref.getString('et_id');
                          recordController.fetchPostApi(
                            odometerImg: 'img',
                            exTdate: attendanceStatusController.formattedDate.toString(),
                            fkEtId: etId.toString(),
                            dwrBusFair: busController.text,
                            dwrRailFair: railController.text,
                            dwrLodgingBill: lodgingBillController.text,
                            dwrDa: _textController.text,
                            dwrOtherExpenses: otherExpController.text,
                            dwrVisitedRoute: attendanceStatusController.visitedRoute.value.toString(),
                            dwrStartReadingKm: attendanceStatusController.ptrReading.value.toString(),
                            dwrEndReadingKm:  closingController.text,
                            dwrTotalKm: totalKm.toString(),
                            dwrOtherRemark: remarkController.text,
                            dwrTravelByVehicle: attendanceStatusController.vehicle.toString(),
                            dwrEndLat: '20.01208v71',
                            dwrEndLong: '73.7608862',
                            dwrTotalExpenses: totalExpense.toString(),
                            exFuel: attendanceStatusController.calculatedValue.value.toStringAsFixed(2),
                            dwrRatePerKm: '5',
                            lodgingImg: 'lodingimg',
                            fuelImg: 'fuelImg',
                            ticketImg: 'ticketImg',
                          );

                        },
                        child: const Text('YES',style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('NO',style: TextStyle(fontSize: 22),),
                      ),
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

}

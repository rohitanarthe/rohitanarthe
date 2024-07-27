import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/controllers/add_dealer_report_controller.dart';
import 'package:lavizen/view/dwr_report/distributor/distributor_report_main_screen/visit_distributor_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/colors_string_constant/color_string_constant.dart';
import '../../../../constant/custom_toast/flutter_show_toast.dart';
import '../distributor_report_main_screen/dwr_report_screen.dart';
import '../distributor_report_main_screen/visit_distributor_report.dart';

class AddDistributorReport extends StatelessWidget {
  final String custId;

  const AddDistributorReport({super.key, required this.custId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddDistributorForm(
        custId: custId,
      ),
    );
  }
}

class AddDistributorForm extends StatefulWidget {
  final String custId;

  const AddDistributorForm({super.key, required this.custId});
  @override
  _AddDistributorFormState createState() => _AddDistributorFormState();
}

class _AddDistributorFormState extends State<AddDistributorForm> {
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _purposeOfVisitController =
      TextEditingController();
  final TextEditingController _otherRemarkController = TextEditingController();
  final AddDealerReportController _addDealerReportController =
      Get.put(AddDealerReportController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getId();
  }

  String? etId;
  void getId() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    setState(() {
      etId = pref.getString('et_id');
    });
  }

  File? _image;
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ), // Back arrow icon
            onPressed: () {
              Get.back();
            }),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Flyct Sofftech',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(
                            width:
                                8), // Add some spacing between the icon and text
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.2,
                    child: const Divider(
                      color: Colors.grey,
                      thickness: 5,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showPurposeOfVisitPopup,
                    child: AbsorbPointer(
                      child: Container(
                        height: 40,
                        child: TextFormField(
                          controller: _purposeOfVisitController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            hintText: 'Select Purpose Of Visit',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Select Followup Date',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                          suffixIcon: const Icon(Icons.calendar_month,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: _otherRemarkController,
                      decoration: InputDecoration(
                        labelText: 'Other Remark',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                        )),
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
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
                                      color: Colors.green, width: 2)),
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
                            backgroundColor: AppColors.primaryColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                          child: const Center(
                              child: Text(
                            'CAPTURE IMAGE',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 30, // Adjust the width as needed
                      child: ElevatedButton(
                        onPressed: () {
                          print('Purpose of Visit: ${_purposeOfVisitController.text}');
                          print('Followup Date: ${_dateController.text}');
                          print('Other Remark: ${_otherRemarkController.text}');
                          print('Image Path: ${_image != null ? _image!.path : 'No image selected'}');

                          if (_formKey.currentState?.validate() ?? false) {
                            if (_validateFields()) {
                              _addDealerReportController.addDealerReport(
                                  custVisitImg: 'custVisitImg',
                                  fkEtId: etId.toString(),
                                  custVisitedLat: '20.0121164',
                                  custVisitedLong: '73.7608828',
                                  custVisitedPurpose:_purposeOfVisitController.text,
                                  custFollowupDate: _dateController.text,
                                  custVisitedRemark:
                                      _otherRemarkController.text,
                                  fkCustId: widget.custId);
                              _showConfirmationDialog();

                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.amber,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        child: const Text('ADD REPORT'),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
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
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width ,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Thank you!! Your record successfully added.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
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

                        Get.offAll((DistributorScreen()));
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

  final List<String> purposeOfVisit = [
    'Order',
    'Payment',
    'Production Information',
    'New Scheme',
    'Other'
  ];

  void _showPurposeOfVisitPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Padding around the title
                  child: Text(
                    'Select Purpose Of Visit',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: double
                      .infinity, // Ensures the ListView matches the dialog's width
                  height: MediaQuery.of(context).size.height / 4,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: purposeOfVisit.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(purposeOfVisit[index]),
                        onTap: () {
                          setState(() {
                            _purposeOfVisitController.text =
                                purposeOfVisit[index];
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double
                            .infinity, // Ensures the Divider matches the width of the ListView
                        child: const Divider(
                          color: Colors.blue, // Divider color
                          thickness: 2,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _validateFields() {
    if (_purposeOfVisitController.text.isEmpty) {
      flutterShowToast('Please select purpose of visit');
      return false;
    }
    if (_dateController.text.isEmpty) {
      flutterShowToast('Please select date');
      return false;
    }
    if (_otherRemarkController.text.isEmpty) {
      flutterShowToast('Please enter remark');
      return false;
    }

    return true;
  }
}

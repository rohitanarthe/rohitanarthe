import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/custom_toast/flutter_show_toast.dart';
import 'package:lavizen/view/dwr_report/distributor/distributor_report_main_screen/dwr_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/colors_string_constant/color_string_constant.dart';
import '../../../../controllers/add_distributor_controller.dart';
import '../../../../controllers/state_controller.dart';
import '../../../../models/state_model.dart';

class AddDistributorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddDistributorForm(),
    );
  }
}

class AddDistributorForm extends StatefulWidget {
  @override
  _AddDistributorFormState createState() => _AddDistributorFormState();
}
class _AddDistributorFormState extends State<AddDistributorForm> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _purposeOfVisitController =
      TextEditingController();
  final TextEditingController _otherRemarkController = TextEditingController();
  final DealerController dealerController = Get.put(DealerController());

  final StateController stateController = Get.put(StateController());

  File? _image;
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _sendImage(_image!);

    }else if(pickedFile == null){
      flutterShowToast('Capture Opening Reading');
    }
  }
  Future<void> _sendImage(File imageFile) async {
    // Convert image to base64 string
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formatterTime = DateFormat('hh:mm').format(now);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? et_id = pref.getString('et_id');
  }
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
      print('----${etId}');
    });
  }

  void clearAll(){
    _otherRemarkController.clear();
    _firmNameController.clear();
    _dateController.clear();
    _purposeOfVisitController.clear();
    _addressController.clear();
    _stateController.clear();
    _contactController.clear();
    _ownerNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Distributor',
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
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _firmNameController,
                    decoration: InputDecoration(
                      hintText: 'Firm Name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _ownerNameController,
                    decoration: InputDecoration(
                      hintText: 'Name of Owner',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _contactController,
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _showPopup(context);
                  },
                  child: AbsorbPointer(
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: 'Select State',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          )),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            flutterShowToast('please select state');
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  child: GestureDetector(
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
                          hintText: 'Select Followup Date',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _otherRemarkController,
                    decoration: InputDecoration(
                      hintText: 'Other Remark',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                      )),
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
                                border:
                                    Border.all(color: Colors.green, width: 2)),
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
                            borderRadius: BorderRadius.all(Radius.circular(0)),
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
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_validateFields()) {
                            if (_formKey.currentState?.validate() ?? false) {
                              await dealerController.addDealerWithVisited(
                                custImg: 'image',
                                custVisitImg: 'img',
                                fkEtId: etId.toString(),
                                firmName: _firmNameController.text,
                                stateName: _stateController.text,
                                custAddr: _addressController.text,
                                custLat: '20.0121875',
                                custVisitedLat: '20.0121875',
                                custLong: '73.7583089',
                                custVisitedLong: '73.7583089',
                                custMobNo: _contactController.text,
                                custName: _ownerNameController.text,
                                custVisitedPurpose:
                                    _purposeOfVisitController.text,
                                custFollowupDate: _dateController.text,
                                custVisitedRemark: _otherRemarkController.text,
                              );

                              _showSuccessDialog(context);
                              clearAll();
                            }
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
                      child: Text('SUBMIT'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> purposeOfVisit = [
    'Order',
    'Payment',
    'Production Information',
    'New Scheme',
    'Other'
  ];

  void _showPopup(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final RxList<StateTable> _filteredStateList =
    RxList<StateTable>(stateController.stateList);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredStateList.value = stateController.stateList;
      } else {
        _filteredStateList.value = stateController.stateList.where((state) {
          return state.stName.toLowerCase().contains(query);
        }).toList();
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a State',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    width: double.maxFinite,
                    child: Obx(() {
                      if (stateController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (_filteredStateList.isEmpty) {
                        return Center(child: Text('No states available.'));
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filteredStateList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_filteredStateList[index].stName),
                              onTap: () {
                                // Perform action on state selection
                                _stateController.text =
                                    _filteredStateList[index].stName;
                                Navigator.pop(context);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              color: Colors.blue,
                              thickness: 2,
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Record Successfully Inserted.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.off(DistributorScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            'Ok',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  bool _validateFields() {
    if (_firmNameController.text.isEmpty) {
      flutterShowToast('Please enter firm name');
      return false;
    }
    if (_ownerNameController.text.isEmpty) {
      flutterShowToast('Please enter name of owner');
      return false;
    }
    if (_contactController.text.isEmpty) {
      flutterShowToast('Please enter contact number');
      return false;
    }
    if (_stateController.text.isEmpty) {
      flutterShowToast('Please select state');
      return false;
    }
    if (_addressController.text.isEmpty) {
      flutterShowToast('Please enter address');
      return false;
    }
    if (_purposeOfVisitController.text.isEmpty) {
      flutterShowToast('Please select purpose of visit');
      return false;
    }
    if (_dateController.text.isEmpty) {
      flutterShowToast('Please select followup date');
      return false;
    }
    if (_otherRemarkController.text.isEmpty) {
      flutterShowToast('Please enter other remark');
      return false;
    }
    return true;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
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
                        SharedPreferences? pref =
                            await SharedPreferences.getInstance();
                        String? etId = pref.getString('et_id');
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(now);
                        String formatterTime = DateFormat('hh:mm').format(now);

                        await dealerController.addDealerWithVisited(
                          custImg: 'image',
                          custVisitImg: 'img',
                          fkEtId: etId.toString(),
                          firmName: _firmNameController.text,
                          stateName: _stateController.text,
                          custAddr: _addressController.text,
                          custLat: '20.0121875',
                          custVisitedLat: '20.0121875',
                          custLong: '73.7583089',
                          custVisitedLong: '73.7583089',
                          custMobNo: _contactController.text,
                          custName: _ownerNameController.text,
                          custVisitedPurpose: _purposeOfVisitController.text,
                          custFollowupDate: _dateController.text,
                          custVisitedRemark: _otherRemarkController.text,
                        );

                        Get.to(DistributorScreen());
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
}

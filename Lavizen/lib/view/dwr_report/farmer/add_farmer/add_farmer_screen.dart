import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constant/colors_string_constant/color_string_constant.dart';
import '../../../../constant/custom_toast/flutter_show_toast.dart';
import '../../../../controllers/add_farmer_controller.dart';
import '../../../../controllers/state_controller.dart';
import '../../../../models/state_model.dart';
import '../farmer_report_main_screen/farmer_report_main_screen.dart';

class AddNewFarmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddNewFarmerForm(),
    );
  }
}

class AddNewFarmerForm extends StatefulWidget {
  @override
  _AddDistributorFormState createState() => _AddDistributorFormState();
}

class _AddDistributorFormState extends State<AddNewFarmerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _purchaseMgrController = TextEditingController();
  final TextEditingController _purMgrContactController =
      TextEditingController();
  final TextEditingController _layerController = TextEditingController();
  final TextEditingController _broilerController = TextEditingController();
  final TextEditingController _breedersController = TextEditingController();
  final TextEditingController _purposeOfVisitController =
      TextEditingController();
  final TextEditingController _otherRemarkController = TextEditingController();
  final AddFarmerController farmerController = Get.put(AddFarmerController());
  final StateController stateController = Get.put(StateController());
  String? etId;
  String? stateId;

  void getId() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    setState(() {
      etId = pref.getString('et_id');
      print('----${etId}');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Farmer',
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
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _farmNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Farm/Poultry/Shed Name',
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(
                                      0.2)), // Set hint text opacity
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _farmerNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Farmer Name',
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(
                                      0.2)), // Set hint text opacity
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
                              labelText: 'Contact Number',
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(
                                      0.2)), // Set hint text opacity
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _showPopup(context),
                          child: AbsorbPointer(
                            child: Container(
                              height: 40,
                              child: TextFormField(
                                controller: _stateController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  labelText: 'Select State',
                                  border: const OutlineInputBorder(),
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(
                                          0.2)), // Set hint text opacity
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
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              alignLabelWithHint: true,
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _purchaseMgrController,
                            decoration: InputDecoration(
                              labelText: 'Purchase Manager Name',
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(
                                      0.2)), // Set hint text opacity
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _purMgrContactController,
                            decoration: InputDecoration(
                              labelText: 'Purchase Manager Contact Number',
                              border: const OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(
                                      0.2)), // Set hint text opacity
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Capacity :',
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          width: double
                              .infinity, // Ensure it takes the full width of its parent
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Distribute space evenly
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _layerController,
                                    decoration: InputDecoration(
                                      labelText: 'Layers',
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: TextFormField(
                                    controller: _broilerController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Broilers',
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: TextFormField(
                                    controller: _breedersController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Breeders',
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                        SizedBox(height: 10),
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
                              width: MediaQuery.sizeOf(context).width/2,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,)
                      ]),
                ),
              ),
            ),
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
                if (_formKey.currentState?.validate() ?? false) {
                  if (_validateFields()) {
                    if (_formKey.currentState?.validate() ?? false) {
                      farmerController.addFarmer(
                        farmImg: 'img',
                        farmVisitedImg: 'img',
                        fkEtId: etId.toString(),
                        farmName: _farmNameController.text,
                        farmMob: _contactController.text,
                        fkStateId: stateId.toString(),
                        farmAddress: _addressController.text,
                        farmStartLat: '20.0121875',
                        farmVisitedLat: '20.0121875',
                        farmStartLong: '73.7583089',
                        farmVisitedLong: '73.7583089',
                        farmVisitedPurpose: _purposeOfVisitController.text,
                        farmVisitedRemark: _otherRemarkController.text,
                        farmVisitedFollowupDate: _dateController.text,
                        layerCapacity: _layerController.text,
                        broilerCapacity: _broilerController.text,
                        breaderCapacity: _breedersController.text,
                        purchaseMgrMobNo: _purMgrContactController.text,
                        purchaseMgrName: _purchaseMgrController.text,
                      );
                      _showSuccessDialog(context);
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
      ]),
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

  final List<String> purposeOfVisit = [
    'Order',
    'Payment',
    'Production Information',
    'New Scheme',
    'Other'
  ];
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
                      Get.off(() => FarmerReportMainScreen);
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
    if (_farmNameController.text.isEmpty) {
      flutterShowToast('Please enter firm name');
      return false;
    }
    if (_farmerNameController.text.isEmpty) {
      flutterShowToast('Please enter farmer name');
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
    if (_layerController.text.isEmpty) {
      flutterShowToast('Please enter layers capacity');
      return false;
    }
    if (_breedersController.text.isEmpty) {
      flutterShowToast('Please enter breeders capacity');
      return false;
    }
    if (_broilerController.text.isEmpty) {
      flutterShowToast('Please enter broiler capacity');
      return false;
    }
    if (_purchaseMgrController.text.isEmpty) {
      flutterShowToast('Please enter purchase manager name');
      return false;
    }
    if (_purMgrContactController.text.isEmpty) {
      flutterShowToast('Please enter purchase manager contact number');
      return false;
    }
    return true;
  }

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
                                _stateController.text =
                                    _filteredStateList[index].stName;
                                Navigator.pop(context);
                                setState(() {
                                  stateId =_filteredStateList[index].stId;
                                  print('stateidd${stateId.toString()}');
                                });
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lavizen/widgets/card_widgets/farmer_card_widget.dart';
import '../../../../controllers/visit_distributor_controller.dart';
import '../../../../controllers/visit_farmer_controller.dart';
import '../../../../widgets/card_widgets/distributor_card_widget.dart';


class VisitFarmerScreen extends StatefulWidget {
  final String visitedDate;
  final String etId;

  VisitFarmerScreen({required this.visitedDate, required this.etId});

  @override
  _VisitFarmerScreenState createState() => _VisitFarmerScreenState();
}

class _VisitFarmerScreenState extends State<VisitFarmerScreen> {
  final VisitFarmerController _controller = Get.put(VisitFarmerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: _controller.visitFarmerModel.value.farmerSearchReport?.length ?? 0,
            itemBuilder: (context, index) {
              final farmer = _controller.visitFarmerModel.value.farmerSearchReport?[index];
              return FarmerCardWidget(
                number: index + 1,
                name: farmer?.farmName,
                owner: farmer?.farmMob,
                address: farmer?.farmAddress,
                farmId: farmer?.farmId,
              );
            },
          );
        }
      }),
    );
  }
}

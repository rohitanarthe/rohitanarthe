import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/visit_distributor_controller.dart';
import '../../../../widgets/card_widgets/distributor_card_widget.dart';


class VisitDistributorScreen extends StatefulWidget {
  final String visitedDate;
  final String etId;

  VisitDistributorScreen({required this.visitedDate, required this.etId});

  @override
  _VisitDistributorScreenState createState() => _VisitDistributorScreenState();
}

class _VisitDistributorScreenState extends State<VisitDistributorScreen> {
  final VisitDistributorController _controller = Get.put(VisitDistributorController());

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
            itemCount: _controller.visitDistributorModel.value.dealerSearchReport?.length ?? 0,
            itemBuilder: (context, index) {
              final distributor = _controller.visitDistributorModel.value.dealerSearchReport?[index];
              return DistributorCard(
                number: index + 1,
                name: distributor?.firmName,
                owner: distributor?.custName,
                address: distributor?.custAddr,
                custId: distributor?.custId,
              );
            },
          );
        }
      }),
    );
  }
}

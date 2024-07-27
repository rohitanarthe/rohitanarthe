import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lavizen/controllers/farmer_visit_history_controller.dart';
import 'package:lavizen/widgets/card_widgets/farmer_history_card_widget.dart';
import '../../../../controllers/dealer_visit_history_controller.dart';
import '../../../../widgets/card_widgets/dealer_history_card_widget.dart';
class VisitFarmerHistory extends StatelessWidget {
  final FarmerVisitHistoryController controller = Get.put(FarmerVisitHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  return Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null &&
                            pickedDate != controller.selectedDate.value) {
                          controller.updateSelectedDate(pickedDate);
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            controller.getFormattedDate(
                                controller.selectedDate.value),
                          ),
                          Spacer(),
                          Icon(Icons.calendar_month)
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller
                  .farmerVisitHistory.value.viewFarmerVisitList.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                return FarmerHistoryCardWidget(
                  visits: controller.farmerVisitHistory.value.viewFarmerVisitList,
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}


// return DealerHistoryCardWidget(
// number: index + 1,
// firmName: visit.firmName,
// contactNumber: visit.custMobNo,
// address: visit.custFollowUpDate,
// );
/*

Obx(() {
return Container(
width: double.maxFinite,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
foregroundColor: Colors.black,
backgroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all(Radius.circular(0)),
),
),
onPressed: () async {
DateTime? pickedDate = await showDatePicker(
context: context,
initialDate: controller.selectedDate.value,
firstDate: DateTime(2000),
lastDate: DateTime(2101),
);
if (pickedDate != null && pickedDate != controller.selectedDate.value) {
controller.updateSelectedDate(pickedDate);
}
},
child: Row(
children: [
Text(controller.getFormattedDate(controller.selectedDate.value),),
Spacer(),
Icon(Icons.calendar_month)
],
),
),
);}*/

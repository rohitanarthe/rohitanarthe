import 'package:flutter/material.dart';
import '../../models/dealer_visit_history_model.dart';
import '../../models/farmer_visit_history_model.dart';

class FarmerHistoryCardWidget extends StatelessWidget {
  final List<ViewFarmerVisitList> visits;

  FarmerHistoryCardWidget({required this.visits});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen width is small (e.g., mobile) or large (e.g., tablet/desktop)
        bool isSmallScreen = constraints.maxWidth < 500;

        return Container(
          padding: EdgeInsets.all(8.0),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all<Color>(Colors.grey.shade200),
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 14),
            columnSpacing: isSmallScreen ? 13 : 20,
            columns: [
              DataColumn(label: Flexible(child: Text('No.',textAlign: TextAlign.center,))),
              DataColumn(label: Flexible(child: Text('Firm Name',textAlign: TextAlign.center,))),
              DataColumn(label: Flexible(child: Text('Contact Number',textAlign: TextAlign.center,))),
              DataColumn(label: Flexible(child: Text('Date', style: TextStyle(color: Colors.blue,),textAlign: TextAlign.center,))),
            ],
            rows: visits.asMap().entries.map((entry) {
              int index = entry.key;
              ViewFarmerVisitList visit = entry.value;

              return DataRow(cells: [
                DataCell(Text((index + 1).toString(), style: TextStyle(fontSize: isSmallScreen ? 10 : 10))),
                DataCell(Text(visit.farmName ?? '', style: TextStyle(fontSize: isSmallScreen ? 10 : 12))),
                DataCell(Text(visit.farmMob ?? '', style: TextStyle(fontSize: isSmallScreen ? 10 : 12))),
                DataCell(Text(visit.farmVisitedDate ?? '', style: TextStyle(fontSize: isSmallScreen ? 10 : 12))),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}









/*
import 'package:flutter/material.dart';

class DealerHistoryCardWidget extends StatelessWidget {
  final int? number;
  final String? firmName;
  final String? contactNumber;
  final String? cust_follow_up_date;
  final String? custId;

  DealerHistoryCardWidget(
      {this.number,
        this.firmName,
        this.contactNumber,
        this.cust_follow_up_date,
        this.custId});

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
                children: [
                  Expanded(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      firmName ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(
                      contactNumber ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Text(
                      cust_follow_up_date ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                    flex: 2,
                  ),
                ],

          ),
          Divider()
        ],
      ),
    );
  }
}*/

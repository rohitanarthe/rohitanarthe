import 'package:flutter/material.dart';
import 'package:lavizen/view/dwr_report/distributor/add_distributor/add_distributor_screen.dart';
import 'package:lavizen/view/dwr_report/farmer/add_farmer_report/add_farmer_report.dart';

class FarmerCardWidget extends StatelessWidget {
  final int? number;
  final String? name;
  final String? owner;
  final String? address;
  final String? farmId;


  FarmerCardWidget({this.number, this.name, this.owner, this.address, this.farmId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number . $name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: 'Name Of Owner: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: owner,
                    style: TextStyle(color: Color(0xFF00AEEF)),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Address: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: address,
                    style: TextStyle(color: Color(0xFF00AEEF)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    print(farmId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFarmerReport(farmId: farmId!)));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFE4B128),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  child: Center(child: Text('ADD REPORT')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

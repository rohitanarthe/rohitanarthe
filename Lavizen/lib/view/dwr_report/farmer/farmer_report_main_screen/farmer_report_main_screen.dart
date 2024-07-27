import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';
import 'package:lavizen/view/dwr_report/farmer/add_farmer/add_farmer_screen.dart';
import 'package:lavizen/view/dwr_report/farmer/farmer_report_main_screen/visit_farmer_history.dart';
import 'package:lavizen/view/dwr_report/farmer/farmer_report_main_screen/visit_farmer_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerReportMainScreen extends StatefulWidget {
  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<FarmerReportMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Trigger a rebuild when the tab changes
    });
  }
  String? et_id;
  void getId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (mounted) {
    setState(() {
      et_id= pref.getString('et_id');
      print(et_id);
    });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    getId();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))
        ),
        backgroundColor:
        AppColors.primaryColor, // Set the background color of AppBar
        title: Text(
          'Farmer Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ), // Back arrow icon
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewFarmer()));
              },
              child: Icon(
                Icons.group_add,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: _tabController.index == 1
                  ? Color(0xFF00AEEF).withOpacity(0.5)
                  : Color(0xFF00AEEF),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white, // Active tab color
                unselectedLabelColor: Colors.black54, // Inactive tab color
                indicatorColor: Colors.white, // Indicator color
                tabs: [
                  Tab(text: 'Visit Farmer'),
                  Tab(text: 'Visit History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  VisitFarmerScreen(visitedDate: formattedDate, etId: et_id.toString(),),
                  VisitFarmerHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DistributorCard extends StatelessWidget {
  final int? number;
  final String? name;
  final String? owner;
  final String? address;

  DistributorCard({this.number, this.name, this.owner, this.address});

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
                  onPressed: () {},
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
            )


          ],
        ),
      ),
    );
  }
}

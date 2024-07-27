import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';
import 'package:lavizen/view/dwr_report/distributor/distributor_report_main_screen/visit_distributor_history.dart';
import 'package:lavizen/view/dwr_report/distributor/distributor_report_main_screen/visit_distributor_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../add_distributor/add_distributor_screen.dart';

class DistributorScreen extends StatefulWidget {
  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<DistributorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? et_id;
  void getId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
   setState(() {
     et_id= pref.getString('et_id');
     print(et_id);
   });
  }

  @override
  void initState() {
    super.initState();
    getId();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Trigger a rebuild when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
        backgroundColor:
            AppColors.primaryColor, // Set the background color of AppBar
        title: Text(
          'Distributor Report',
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
                        builder: (context) => AddDistributorScreen()));
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
                  Tab(text: 'Visit Distributor'),
                  Tab(text: 'Visit History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  VisitDistributorScreen(visitedDate: formattedDate, etId:et_id.toString() ),
                  DealerVisitView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';
import 'package:lavizen/view/dwr_report/distributor/distributor_report_main_screen/visit_distributor_history.dart';
import 'package:lavizen/view/dwr_report/expense_report/expense_report_history.dart';
import 'package:lavizen/view/dwr_report/expense_report/expense_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseReport extends StatefulWidget {
  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<ExpenseReport>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? et_id;
  void getId()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      et_id= pref.getString('et_id');
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
        title: const Text(
          'Expense Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ), // Back arrow icon
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
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
                  Tab(text: 'Expenses'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ExpenseReportScreen(),
                  DailyReportPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





import 'package:flutter/material.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';
import 'package:lavizen/view/dwr_report/expense_report/expense_report.dart';
import 'package:lavizen/view/dwr_report/farmer/farmer_report_main_screen/farmer_report_main_screen.dart';
import '../../constant/image_string/image_strings.dart';
import '../../widgets/card_widgets/dwr_report_card.dart';
import 'distributor/distributor_report_main_screen/dwr_report_screen.dart';
import 'expense_report/expense_report_screen.dart';

class DwrReportScreen extends StatefulWidget {
  const DwrReportScreen({super.key});
  @override
  State<DwrReportScreen> createState() => _DwrReportScreenState();
}

class _DwrReportScreenState extends State<DwrReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Report',
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExpenseReport()));
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(addExpense,
                            color: Colors.red,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Expense \nReport',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppColors.primaryColor,
            ),
            const Center(
              child: Text(
                'Add Report',
                style: TextStyle(color: AppColors.primaryColor,fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                spacing: 5.0, // Horizontal space between children
                runSpacing: 5.0, // Vertical space between rows
                alignment: WrapAlignment.start, // Center the widgets horizontally
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DistributorScreen()));
                    },
                    child: DWRCardWidget(
                      title: 'Distributor',
                      imagePath: 'assets/images/add_dealer_report.png', // Replace with your actual image asset path
                    ),
                  ),
                  SizedBox(width: 20,),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FarmerReportMainScreen()));
                    },
                    child: DWRCardWidget(
                      title: 'Farmer',
                      imagePath: 'assets/images/add_farmer_report.png', // Replace with your actual image asset path
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

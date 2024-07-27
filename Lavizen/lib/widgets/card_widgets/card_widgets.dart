import 'package:flutter/material.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  CardWidget({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      child: Card(
        color: AppColors.primaryColor,
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Optional: Add border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

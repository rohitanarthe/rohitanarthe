import 'package:flutter/material.dart';
import 'package:lavizen/constant/colors_string_constant/color_string_constant.dart';

class DWRCardWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  DWRCardWidget({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 140,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0), // Optional: Add border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 80,
              width: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
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

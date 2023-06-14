import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final String title;
  final bool isSelected;
  const Categories(this.title, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 6,
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   "images/$number.png",
          //   width: 40,
          //   height: 40,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: isSelected ? white : blackColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

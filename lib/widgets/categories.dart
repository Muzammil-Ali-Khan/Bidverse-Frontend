import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final String title;
  final int number;
  const Categories(this.title, this.number, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "images/$number.png",
            width: 40,
            height: 40,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: blackColor,
            ),
          )
        ],
      ),
    );
  }
}

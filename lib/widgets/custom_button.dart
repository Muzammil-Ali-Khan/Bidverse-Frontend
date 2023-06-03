import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.width,
  }) : super(key: key);

  String title;
  Function() onPressed;
  double? width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: primaryColor,
      minWidth: width ?? double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        title,
        style: const TextStyle(color: white, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

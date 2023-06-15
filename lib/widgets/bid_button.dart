import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class BidButton extends StatelessWidget {
  BidButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  String title;
  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: greyBackground,

      minWidth: 30,
      // padding: const EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        title,
        style: const TextStyle(color: blackColor, fontSize: 16.0),
      ),
    );
  }
}

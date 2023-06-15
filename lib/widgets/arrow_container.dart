import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class ArrowContainer extends StatelessWidget {
  const ArrowContainer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: greyBackground, borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 17.0,
            ),
          ],
        ),
      ),
    );
  }
}

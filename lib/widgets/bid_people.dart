import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class BidPeople extends StatelessWidget {
  final String ownernamer;
  final String price;
  const BidPeople(this.ownernamer, this.price, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 330,
      color: white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              ownernamer,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 10), child: Text(price)),
        ],
      ),
    );
  }
}

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class ProductAppBar extends StatefulWidget {
  const ProductAppBar({super.key});

  @override
  State<ProductAppBar> createState() => _ProductAppBarState();
}

class _ProductAppBarState extends State<ProductAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: white,
      centerTitle: true,
      leading: const Icon(
        Icons.arrow_back_outlined,
        size: 25,
        color: blackColor,
      ),
      title: Text(
        "Product",
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: const Text(
                'TZ',
                style: TextStyle(
                  color: white,
                  // fontWeight: FontWeight.bol,
                ),
              ),
              radius: 20.0,
            ))
      ],
    );
    ;
  }
}

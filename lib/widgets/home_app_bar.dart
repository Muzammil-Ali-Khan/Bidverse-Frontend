import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: white,
      centerTitle: true,
      // leading: const Icon(
      //   Icons.arrow_back_outlined,
      //   size: 25,
      //   color: blackColor,
      // ),
      title: const Text(
        'Home',
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

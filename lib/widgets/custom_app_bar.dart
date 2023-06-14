import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  bool backArrow = false;

  CustomAppBar({required this.title, this.backArrow = false, super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserProvider userProvider = UserProvider();

  String getInitials(String name) {
    return name.split(" ")[0][0].toUpperCase() + name.split(" ")[1][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return AppBar(
      backgroundColor: white,
      // centerTitle: true,
      leading: widget.backArrow
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 25,
                color: blackColor,
              ),
            )
          : null,
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 20.0,
            child: Text(
              getInitials(userProvider.user!.name),
              style: const TextStyle(
                color: white,
                // fontWeight: FontWeight.bol,
              ),
            ),
          ),
        )
      ],
    );
    ;
  }
}

// import 'package:bidverse_frontend/widgets/home_app_bar.dart';
import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/screens/home_screen.dart';
import 'package:bidverse_frontend/screens/product_upload_screen.dart';
import 'package:bidverse_frontend/widgets/categories.dart';
import 'package:bidverse_frontend/widgets/home_app_bar.dart';
import 'package:bidverse_frontend/widgets/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageIndex == 0 ? HomeScreen() : ProductUploadScreen(),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          color: primaryColor,
          height: 70,
          items: [
            Icon(Icons.home, size: 30, color: white),
            Icon(CupertinoIcons.person, size: 30, color: white),
            Icon(Icons.upload_outlined, size: 30, color: white),
            Icon(Icons.favorite_border, size: 30, color: white),
          ]),
    );
  }
}

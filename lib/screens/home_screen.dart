import 'package:bidverse_frontend/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/categories.dart';
import '../widgets/items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      HomeAppBar(),
      Container(
        // height: 500,
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Color(0xFFEDECF2),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular((35)),
          //   topRight: Radius.circular(35),
          // ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here...",
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.camera_alt,
                  size: 27,
                ),
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Categories("Sandals", 1),
                  Categories("Watch", 2),
                  Categories("Bag", 3),
                  Categories("Hand Carrier", 4),
                  Categories("Bag", 5),
                  Categories("Sandals", 6),
                  Categories("Watch", 7),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: const Text(
                "Top Auctions",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            GridView.count(childAspectRatio: 0.68, physics: NeverScrollableScrollPhysics(), crossAxisCount: 2, shrinkWrap: true, children: [
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 1, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 2, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 3, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 4, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 5, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 6, "-30%"),
              ItemsWidget("FT-350", "High heels black colored sandals", "Rs.4395", 7, "-30%"),
            ])
          ],
        ),
      )
    ]);
  }
}

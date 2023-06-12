import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  final String title;
  final String detail;
  final String price;
  final int number;
  final String off;
  const ItemsWidget(this.title, this.detail, this.price, this.number, this.off, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   padding: EdgeInsets.all(5),
              //   decoration: BoxDecoration(color: Color(0xFF4C53A5)),
              //   child: Text(
              //     off,
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: white,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                "images/$number.png",
                height: 100,
                width: 100,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 2),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(fontSize: 18, color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Text(
              detail,
              style: TextStyle(fontSize: 15, color: blackColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

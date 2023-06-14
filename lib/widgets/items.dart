import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsWidget extends StatefulWidget {
  final String title;
  final String detail;
  final int price;
  final String image;
  final String id;
  final void Function(String) handleFavourite;
  const ItemsWidget(this.title, this.detail, this.price, this.image, this.id, this.handleFavourite, {super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              GestureDetector(
                onTap: () {
                  widget.handleFavourite(widget.id);
                },
                child: Icon(
                  userProvider.user!.favourites.contains(widget.id) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.network(
                widget.image,
                height: 100,
                width: 100,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Text(
              widget.detail,
              style: const TextStyle(fontSize: 15, color: blackColor),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rs. ${widget.price}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

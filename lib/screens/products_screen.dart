import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/widgets/bid_button.dart';
import 'package:bidverse_frontend/widgets/bid_people.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/home_app_bar.dart';
import 'package:bidverse_frontend/widgets/product_appbar.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDECF2),
        body: ListView(
          children: [
            ProductAppBar(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Image.asset(
                "images/1.png",
                height: 330,
              ),
            ),
            Arc(
              height: 20,
              edge: Edge.TOP,
              arcType: ArcType.CONVEY,
              child: Container(
                width: double.infinity,
                color: white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                        child: Row(children: [
                          Text(
                            "Product Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // height: 500,
              // padding: EdgeInsets.only(top: 15),
              height: 200,

              decoration: BoxDecoration(
                color: white,
                // color: Colors.blueAccent,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular((35)),
                //   topRight: Radius.circular(35),
                // ),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                // height: 500,

                height: 200,
                decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular((20)),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Minda Peterson",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: white,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Description",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "This is the description of first product. its a pair of blue colored sandals with high heels.",
                        style: TextStyle(
                          color: white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      child: CustomButton(
                        title: "See Bid",
                        onPressed: () {
                          showModalBottomSheet<void>(
                            // context and builder are
                            // required properties in this widget
                            context: context,
                            builder: (BuildContext context) {
                              // we set up a container inside which
                              // we create center column and display text

                              // Returning SizedBox instead of a Container
                              return SizedBox(
                                height: 700,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      // padding:
                                      // EdgeInsets.symmetric(vertical: 30),
                                      height: 100,
                                      width: 330,
                                      decoration: const BoxDecoration(
                                          color: greyBackground,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            // padding: EdgeInsets.symmetric(
                                            //     horizontal: 5),
                                            height: 90,
                                            width: 160,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Starting Price",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Rs. 5,000",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    // fontWeight:
                                                    // FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // color: primaryColor,
                                          ),
                                          VerticalDivider(
                                            width: 10,
                                            color: primaryColor,
                                          ),
                                          Container(
                                            // padding: EdgeInsets.symmetric(
                                            //     horizontal: 5),
                                            height: 90,
                                            width: 160,
                                            // color: primaryColor,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Current Bid",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Rs. 24,500",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    // fontWeight:
                                                    // FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                    vertical: 10),
                                                child: Text(
                                                  "Live Auction",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text("14 Bids Made")),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    BidPeople("Tehreem Zahid", "Rs. 24,500"),
                                    BidPeople("Tehreem Zahid", "Rs. 24,500"),
                                    BidPeople("Tehreem Zahid", "Rs. 24,500"),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      // height: 500,

                                      height: 115,
                                      decoration: BoxDecoration(
                                        color: greyBackground,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular((20)),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BidButton(
                                                  title: "10K",
                                                  onPressed: () {}),
                                              BidButton(
                                                  title: "20K",
                                                  onPressed: () {}),
                                              BidButton(
                                                  title: "30K",
                                                  onPressed: () {}),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: CustomButton(
                                              title: "Place bid",
                                              onPressed: () {},
                                              width: 320,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        width: 200,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

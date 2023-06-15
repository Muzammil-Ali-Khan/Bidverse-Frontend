import 'dart:convert';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/widgets/custom_app_bar.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';

import '../constants/urls.dart';
import '../models/ProductModel.dart';
import '../providers/user_provider.dart';
import '../services/http_service.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  TextEditingController numberController = TextEditingController();

  ProductModel? product;
  UserProvider userProvider = UserProvider();
  Map<String, dynamic> currentBid = {};
  List<Map<String, dynamic>> userPreviousBid = [];
  bool isTimeExpired = false;

  Future<bool> _fetchProduct() async {
    var response = await HttpService.get("${URLS.getSingleProduct}${widget.productId}", withAuth: true);

    if (response.success) {
      setState(() {
        print("Product: ${response.data!['product']}");
        product = ProductModel.fromJson(response.data!['product']);
        currentBid = product!.bidAmounts.isEmpty
            ? {}
            : product!.bidAmounts.reduce((value, element) => value['amount'] > element['amount'] ? value['amount'] : element['amount']);
        userPreviousBid = product!.bidAmounts.where((element) => element['userId'] == userProvider.user!.id).toList();
      });

      print(
          "Amount: ${(product?.bidAmounts ?? []).isNotEmpty ? product?.bidAmounts.reduce((value, element) => value['amount'] > element['amount'] ? value['amount'] : element['amount']) : ""}");

      return true;
    } else {
      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProduct().then((value) {
      endTime = product!.endTime.millisecondsSinceEpoch + 1000 * 30;
      controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
      isTimeExpired = endTime < DateTime.now().millisecondsSinceEpoch + 1000 * 30;

      print("End Time: ${endTime < DateTime.now().millisecondsSinceEpoch + 1000 * 30}");
    });
  }

  void onEnd() {
    print('onEnd');
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<bool> _handlePlaceBid(BuildContext context) async {
    var data = {
      "productId": product!.id,
      "bidAmount": int.parse(numberController.text),
      "userId": userProvider.user!.id,
    };

    var response = await HttpService.put(URLS.updateBidList, data: data, withAuth: true);

    if (response.success) {
      return true;
    } else {
      var errorMessage = response.error;
      var jsonError = json.decode(errorMessage!);
      var realErrorMessage = jsonError['message'];
      print('real error is $realErrorMessage');

      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(realErrorMessage));

      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomAppBar(title: 'Product', backArrow: true),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.network(
                  product?.image ?? "https://upload.wikimedia.org/wikipedia/commons/b/b1/Loading_icon.gif?20151024034921",
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: Row(children: [
                            Text(
                              product?.name ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: white,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: darkBlueColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(fontSize: 18.0, color: primaryColor),
                            ),
                            Text(
                              product?.description ?? "",
                              style: const TextStyle(color: white),
                            ),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Starting Price",
                                        style: TextStyle(fontSize: 18.0, color: primaryColor),
                                      ),
                                      Text(
                                        "Rs. ${product?.price}",
                                        style: const TextStyle(color: white),
                                      ),
                                      const SizedBox(height: 10.0),
                                      const Text(
                                        "Current Bid",
                                        style: TextStyle(fontSize: 18.0, color: primaryColor),
                                      ),
                                      Text(
                                        "Rs. ${((product?.bidAmounts ?? []).isNotEmpty ? currentBid['amount'] : "No current bid") ?? product?.price}",
                                        style: const TextStyle(color: white),
                                      )
                                    ],
                                  ),
                                  Container(width: 1.0, height: 60.0, color: white),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Remaining Time",
                                        style: TextStyle(fontSize: 18.0, color: primaryColor),
                                      ),
                                      CountdownTimer(
                                        controller: controller,
                                        onEnd: onEnd,
                                        endTime: endTime,
                                        textStyle: const TextStyle(color: white),
                                        widgetBuilder: (_, CurrentRemainingTime? time) {
                                          if (time == null) {
                                            return const Text(
                                              'This bid has ended',
                                              style: TextStyle(color: white),
                                            );
                                          }
                                          return Text(
                                            'Days: ${time.days ?? 0}, Time: ${time.hours}:${time.min}:${time.sec}',
                                            style: const TextStyle(color: white),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            userPreviousBid.isNotEmpty
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Your Previous Bid: ",
                                        style: TextStyle(fontSize: 18.0, color: primaryColor),
                                      ),
                                      Text(
                                        "Rs. ${userPreviousBid.first["amount"]}",
                                        style: const TextStyle(color: white),
                                      ),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(height: 30.0),
                            CustomButton(
                                title: 'Place a Bid',
                                onPressed: () {
                                  if (isTimeExpired) {
                                    ScaffoldMessenger.of(context).showSnackBar(customSnackBar("The bidding on this product has ended"));
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Place your Bid"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Amount',
                                                style: TextStyle(fontSize: 16.0),
                                              ),
                                              const SizedBox(height: 5.0),
                                              CustomTextField(
                                                hintText: '2648',
                                                controller: numberController,
                                                icon: Icons.monetization_on_outlined,
                                                keyboardType: TextInputType.number,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: primaryColor,
                                              child: const Text("Cancel", style: TextStyle(color: white)),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                if (product!.userId == userProvider.user!.id) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(customSnackBar("This product is uploaded by you. You cannot place a bid here"));
                                                } else {
                                                  if (userPreviousBid.isNotEmpty) {
                                                    if (userPreviousBid.first['userId'] == userProvider.user!.id) {
                                                      if (currentBid != {} && currentBid["amount"] < userPreviousBid.first["amount"]) {
                                                        if (int.parse(numberController.text) < (currentBid['amount'] ?? product!.price)) {
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(customSnackBar("Please write an amount greater than current bid"));
                                                        } else {
                                                          await _handlePlaceBid(context).then((success) {
                                                            if (success) {
                                                              Navigator.pop(context);
                                                              ScaffoldMessenger.of(context).showSnackBar(customSnackBar("Your bid has been placed"));
                                                            }
                                                          });
                                                        }
                                                      } else {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar("You have already placed a bid"));
                                                      }
                                                    }
                                                  } else {
                                                    if (int.parse(numberController.text) < (currentBid['amount'] ?? product!.price)) {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(customSnackBar("Please write an amount greater than current bid"));
                                                    } else {
                                                      await _handlePlaceBid(context).then((success) {
                                                        if (success) {
                                                          Navigator.pop(context);
                                                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar("Your bid has been placed"));
                                                        }
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                              color: primaryColor,
                                              child: const Text("Done", style: TextStyle(color: white)),
                                            ),
                                          ],
                                        );
                                      });
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

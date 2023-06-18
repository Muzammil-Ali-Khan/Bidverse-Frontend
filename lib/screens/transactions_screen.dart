import 'dart:convert';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  UserProvider userProvider = UserProvider();
  List<Map<String, dynamic>> paymentIntents = [];

  Future<void> fetchPaymentIntents() async {
    try {
      var response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
      );

      setState(() {
        paymentIntents = (json.decode(response.body)['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList()
            .where((element) => element['description'] == userProvider.user!.id)
            .toList();
      });

      print(paymentIntents.where((element) => element['description'] == userProvider.user!.id).toList());
    } catch (e) {
      // var errorMessage = e.toString();
      // var jsonError = json.decode(errorMessage);
      // var realErrorMessage = jsonError['message'];
      // print('real error is $realErrorMessage');
      //
      // ScaffoldMessenger.of(context).showSnackBar(customSnackBar(realErrorMessage));

      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(title: "Transaction History", backArrow: true),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: lightGreyBackground,
                    border: Border.symmetric(
                      horizontal: BorderSide(),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Transaction ID",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      )),
                      Expanded(
                          child: Text(
                        "Time",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      )),
                      Expanded(
                          child: Text(
                        "Status",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: paymentIntents.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0.0),
                  itemBuilder: (context, index) {
                    var currentIntent = paymentIntents[index];
                    var date = DateTime.fromMillisecondsSinceEpoch(currentIntent["created"] * 1000);

                    return Container(
                      color: index % 2 == 0 ? white : lightGreyBackground,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              Clipboard.setData(ClipboardData(text: currentIntent["id"])).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(customSnackBar("Transaction Id has been copied to clipboard"));
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child: Text(
                                    currentIntent["id"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.0),
                                    maxLines: 3,
                                  ),
                                ),
                                Icon(
                                  Icons.copy,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          )),
                          Expanded(
                              child: Text(
                            currentIntent["amount"].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0),
                          )),
                          Expanded(
                              child: Text(
                            DateFormat("hh:mm a\ndd-MM-yyyy").format(date).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0),
                          )),
                          Expanded(
                              child: Text(
                            currentIntent["status"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0),
                          )),
                        ],
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

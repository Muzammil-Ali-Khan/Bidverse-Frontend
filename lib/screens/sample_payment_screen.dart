import 'package:flutter/material.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SamplePaymentScreen extends StatelessWidget {
  SamplePaymentScreen({Key? key}) : super(key: key);

  String paymentStatus = "pending";
  // Map<String, dynamic> product = {"name": "Product 1", "price": "100"};
  ProductModel productModel = ProductModel("Product 1", "10");
  String integritySalt = "8259433b6f";
  String merchantID = "MC57882";
  String merchantPassword = "x9z0503ssy";
  String transactionUrl = "https://gaping-instrument-production.up.railway.app/api/v1/transaction";

  Future _payViaJazzCash(ProductModel element, BuildContext c) async {
    // print("clicked on Product ${element.name}");

    try {
      JazzCashFlutter jazzCashFlutter = JazzCashFlutter(
        merchantId: merchantID,
        merchantPassword: merchantPassword,
        integritySalt: integritySalt,
        isSandbox: true,
      );

      DateTime date = DateTime.now();

      JazzCashPaymentDataModelV1 paymentDataModelV1 = JazzCashPaymentDataModelV1(
        ppAmount: '${element.productPrice}',
        ppBillReference: 'refbill${date.year}${date.month}${date.day}${date.hour}${date.millisecond}',
        ppDescription: 'Product details  ${element.productName} - ${element.productPrice}',
        ppMerchantID: merchantID,
        ppPassword: merchantPassword,
        ppReturnURL: transactionUrl,
      );

      jazzCashFlutter.startPayment(paymentDataModelV1: paymentDataModelV1, context: c).then((_response) {
        print("response from jazzcash $_response");

        // _checkIfPaymentSuccessfull(_response, element, context).then((res) {
        //   // res is the response you returned from your return url;
        //   return res;
        // });

        // setState(() {});
      });
    } catch (err) {
      print("Error in payment $err");
      // CommonFunctions.CommonToast(
      //   message: "Error in payment $err",
      // );
      return false;
    }
  }

  payment() async {
    var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(Duration(days: 1)));
    String tre = "T" + dateandtime;
    String pp_Amount = "100000";
    String pp_BillReference = "billRef";
    String pp_Description = "Description";
    String pp_Language = "EN";
    String pp_MerchantID = "MC57882";
    String pp_Password = "x9z0503ssy";

    // String pp_ReturnURL = "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String pp_ReturnURL = "https://gaping-instrument-production.up.railway.app/api/v1/transaction";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MWALLET";
    String ppmpf_1 = "4456733833993";
    String IntegeritySalt = "8259433b6f";
    String and = '&';
    String superdata = IntegeritySalt +
        and +
        pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_Description +
        and +
        pp_Language +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ReturnURL +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType +
        and +
        pp_ver +
        and +
        ppmpf_1;

    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    var url = 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    // var response = await http.post(Uri.parse(url), body: {
    //   "pp_Version": pp_ver,
    //   "pp_TxnType": pp_TxnType,
    //   "pp_Language": pp_Language,
    //   "pp_MerchantID": pp_MerchantID,
    //   "pp_Password": pp_Password,
    //   "pp_TxnRefNo": tre,
    //   "pp_Amount": pp_Amount,
    //   "pp_TxnCurrency": pp_TxnCurrency,
    //   "pp_TxnDateTime": dateandtime,
    //   "pp_BillReference": pp_BillReference,
    //   "pp_Description": pp_Description,
    //   "pp_TxnExpiryDateTime": dexpiredate,
    //   "pp_ReturnURL": pp_ReturnURL,
    //   "pp_SecureHash": "",
    //   // "pp_SecureHash": sha256Result.toString(),
    //   "ppmpf_1": "03123456789"
    // });
    var response = await http.post(Uri.parse(url), body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": "EN",
      "pp_MerchantID": merchantID,
      "pp_SubMerchantID": "",
      "pp_Password": merchantPassword,
      "pp_TxnRefNo": tre,
      "pp_MobileNumber": "03411728699",
      "pp_CNIC": "345678",
      "pp_Amount": "10000",
      "pp_DiscountedAmount": "",
      "pp_TxnCurrency": "PKR",
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime": "",
      "pp_SecureHash": integritySalt,
      "ppmpf_1": "",
      "ppmpf_2": "",
      "ppmpf_3": "",
      "ppmpf_4": "",
      "ppmpf_5": "",
      "pp_ReturnURL": pp_ReturnURL,
    });

    print("response=>");
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _payViaJazzCash(productModel, context);
          // await payment();
        },
        child: const Text("Pay"),
      ),
    );
  }
}

class ProductModel {
  String? productName;
  String? productPrice;

  ProductModel(this.productName, this.productPrice);
}

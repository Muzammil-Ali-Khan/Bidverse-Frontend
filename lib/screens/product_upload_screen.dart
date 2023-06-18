import 'dart:convert';
import 'dart:io';
import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/services/storage_service.dart';
import 'package:bidverse_frontend/utils/permissions.dart';
import 'package:bidverse_frontend/utils/save_image.dart';
import 'package:bidverse_frontend/utils/upload_image.dart';
import 'package:bidverse_frontend/widgets/custom_app_bar.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:bidverse_frontend/widgets/image_selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../models/ProductModel.dart';
import 'package:http/http.dart' as http;

class ProductUploadScreen extends StatefulWidget {
  ProductUploadScreen({Key? key}) : super(key: key);

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // States
  File? image;
  String imageUrl = "";
  bool isFeatured = false;
  DateTime selectedDate = DateTime.now();
  List<String> categories = ["Fashion", "Electronics", "Furnitures", "Others"];
  String selectedCategory = 'Fashion';
  List<ProductModel> allProducts = [];
  List<ProductModel?> featuredProducts = [];
  List<ProductModel?> currentUserProducts = [];
  UserProvider userProvider = UserProvider();

  // Services
  Permissions permissions = Permissions();

  Future<bool> _fetchProducts() async {
    var response = await HttpService.get(URLS.getProducts, withAuth: true);

    if (response.success) {
      setState(() {
        allProducts = (response.data!['products'] as List).map((prod) => ProductModel.fromJson(prod)).toList();
        featuredProducts = allProducts.map((prod) {
          if (prod.isFeatured) {
            return prod;
          }
        }).toList();
        featuredProducts.removeWhere((element) => element == null);
        currentUserProducts = allProducts.where((element) => element.userId == userProvider.user!.id).toList();
      });

      return true;
    } else {
      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _handleImageSourcePress(
    BuildContext context,
    ImageSource source,
  ) {
    pickImage(source).then((value) {
      image = value;
      print("Image Selected: $image");
      uploadImageToFirebase(context, value).then((url) {
        setState(() {
          imageUrl = url;
        });
        print("Uploaded Image URL: $url");
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
      });
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<bool> _handleCreateProduct(BuildContext context) async {
    var data = {
      "name": nameController.text,
      "description": descriptionController.text,
      'price': priceController.text,
      'image': imageUrl,
      'endTime': selectedDate.toString(),
      'isFeatured': isFeatured,
      'category': selectedCategory
    };

    var response = await HttpService.post(URLS.createProduct, data: data, withAuth: true);

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

  Future<void> makePayment() async {
    try {
      //STEP 1: Create Payment Intent
      var paymentIntent = await createPaymentIntent('100', 'USD');

      print("Payment intent: $paymentIntent");

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomAppBar(title: AppLocalizations.of(context)!.createYourProduct),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Text(
                  AppLocalizations.of(context)!.title,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomTextField(
                  hintText: AppLocalizations.of(context)!.productName,
                  controller: nameController,
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Text(
                  AppLocalizations.of(context)!.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomTextField(
                  hintText: AppLocalizations.of(context)!.descriptionOfProduct,
                  controller: descriptionController,
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Text(
                  AppLocalizations.of(context)!.price,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomTextField(
                  hintText: '${AppLocalizations.of(context)!.rs} 55025',
                  controller: priceController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  AppLocalizations.of(context)!.category,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: greyBackground,
                    border: Border.all(color: greyTextFieldText),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    underline: Container(),
                    dropdownColor: primaryColor,
                    isDense: true,
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (String? cat) {
                      setState(() {
                        selectedCategory = cat!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.wantYourBidToBeFeatured),
                    RadioListTile<bool>(
                      groupValue: isFeatured,
                      value: true,
                      onChanged: (newValue) {
                        setState(() {
                          isFeatured = newValue!;
                        });
                      },
                      title: Text(
                        AppLocalizations.of(context)!.yes,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    RadioListTile<bool>(
                      groupValue: isFeatured,
                      value: false,
                      onChanged: (newValue) {
                        setState(() {
                          isFeatured = newValue!;
                        });
                      },
                      title: Text(
                        AppLocalizations.of(context)!.no,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.bidEndTime}: ',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _selectDate(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(DateFormat('yyyy/MM/dd').format(selectedDate)),
                      ),
                    ),
                  ],
                ),
              ),
              imageUrl != ''
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 200.0,
                        child: Image.network(imageUrl),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(
                  title: AppLocalizations.of(context)!.uploadImage,
                  onPressed: () async {
                    await permissions.checkCameraPermission();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ImageSelectionModal(
                          onPressedCamera: () {
                            _handleImageSourcePress(context, ImageSource.camera);
                          },
                          onPressedGallery: () {
                            _handleImageSourcePress(context, ImageSource.gallery);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(
                  title: AppLocalizations.of(context)!.create,
                  onPressed: () async {
                    if (currentUserProducts.length >= 3) {
                      if (nameController.text == '' || descriptionController.text == '' || priceController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.fillAllFieldsFirst));
                      } else if (imageUrl == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.pleaseUploadAnImage));
                      } else {
                        print(featuredProducts.length);
                        if (featuredProducts.length >= 2 && isFeatured) {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar('There is no empty slot for featured products right now'));
                        } else {
                          await makePayment().then((value) async {
                            bool result = await _handleCreateProduct(context);
                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.productCreatedSuccessfully));
                            }
                          });
                        }
                      }
                    } else {
                      if (nameController.text == '' || descriptionController.text == '' || priceController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.fillAllFieldsFirst));
                      } else if (imageUrl == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.pleaseUploadAnImage));
                      } else {
                        print(featuredProducts.length);
                        if (featuredProducts.length >= 2 && isFeatured) {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar('There is no empty slot for featured products right now'));
                        } else {
                          if (isFeatured) {
                            await makePayment().then((value) async {
                              bool result = await _handleCreateProduct(context);
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.productCreatedSuccessfully));
                              }
                            });
                          } else {
                            bool result = await _handleCreateProduct(context);
                            if (result) {
                              ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.productCreatedSuccessfully));
                            }
                          }
                        }
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'description': userProvider.user!.id,
        "automatic_payment_methods[enabled]": 'true',
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));

        var paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }
  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       //Clear paymentIntent variable after successful payment
  //       var paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
}

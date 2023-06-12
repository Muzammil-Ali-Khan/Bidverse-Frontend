import 'dart:convert';
import 'dart:io';
import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/services/storage_service.dart';
import 'package:bidverse_frontend/utils/permissions.dart';
import 'package:bidverse_frontend/utils/save_image.dart';
import 'package:bidverse_frontend/utils/upload_image.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:bidverse_frontend/widgets/image_selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  String imageUrl = '';
  bool isFeatured = false;
  DateTime selectedDate = DateTime.now();

  // Services
  Permissions permissions = Permissions();

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
      'isFeatured': isFeatured
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(
            AppLocalizations.of(context)!.createYourProduct,
          ),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  // AppLocalizations.of(context)!.email,
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
                  // AppLocalizations.of(context)!.email,
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
                      if (nameController.text == '' || descriptionController.text == '' || priceController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.fillAllFieldsFirst));
                      } else if (imageUrl == '') {
                        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.pleaseUploadAnImage));
                      } else {
                        bool result = await _handleCreateProduct(context);
                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.productCreatedSuccessfully));
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

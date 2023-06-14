import 'dart:convert';
import 'dart:io';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/models/UserModel.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/utils/permissions.dart';
import 'package:bidverse_frontend/utils/save_image.dart';
import 'package:bidverse_frontend/widgets/arrow_container.dart';
import 'package:bidverse_frontend/widgets/custom_app_bar.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:bidverse_frontend/widgets/image_selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/upload_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider userProvider = UserProvider();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  Permissions permissions = Permissions();
  File? image;
  String imageUrl = '';

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

  Future<bool> _handleUpdateProfile(BuildContext context) async {
    var data = {
      "userId": userProvider.user!.id,
      "name": nameController.text,
      "number": numberController.text,
      'image': imageUrl,
    };

    var response = await HttpService.put(URLS.updateUser, data: data, withAuth: true);

    if (response.success) {
      print(response.data);
      userProvider.setUser(UserModel.fromJson(response.data!['user'] as Map<String, dynamic>));

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar("Profile"),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
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
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl != '' ? imageUrl : userProvider.user!.image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Text(
                AppLocalizations.of(context)!.userName,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomTextField(
                hintText: 'User',
                initialValue: userProvider.user!.name,
                controller: nameController,
                icon: Icons.person_outline_outlined,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Text(
                AppLocalizations.of(context)!.phoneNumber,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomTextField(
                hintText: '0325685335',
                initialValue: userProvider.user!.number,
                controller: numberController,
                icon: Icons.phone_outlined,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                  title: 'Update',
                  onPressed: () async {
                    if (nameController.text != '' && numberController.text != '') {
                      _handleUpdateProfile(context).then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar("User Updated Successfully"));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar("Something went wrong"));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(AppLocalizations.of(context)!.fillAllFieldsFirst));
                    }
                  }),
            ),
            // const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(onTap: () {}, child: ArrowContainer(title: "Your Products")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: GestureDetector(onTap: () {}, child: ArrowContainer(title: "Your Bidded Products")),
            ),
          ],
        ),
      ),
    );
  }
}

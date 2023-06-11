import 'dart:io';
import 'package:bidverse_frontend/utils/permissions.dart';
import 'package:bidverse_frontend/utils/save_image.dart';
import 'package:bidverse_frontend/utils/upload_image.dart';
import 'package:bidverse_frontend/widgets/image_selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductUploadScreen extends StatelessWidget {
  ProductUploadScreen({Key? key}) : super(key: key);

  // States
  File? image;

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
        // setState(() {
        //   imageUrl = url;
        // });
        print("Uploaded Image URL: $url");
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
      });
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
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
              child: Text('click me'),
            ),
          ),
        ],
      ),
    );
  }
}

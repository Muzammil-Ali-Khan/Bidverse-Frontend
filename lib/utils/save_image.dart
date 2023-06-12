import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future pickImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    } else {
      final imagePermanent = await _saveImageInDevice(image.path);
      return imagePermanent;
    }
  } on PlatformException catch (e) {
    debugPrint("Error in picking image: ${e.message}");
  }
}

Future<File> _saveImageInDevice(String imagePath) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = basename(imagePath);
  final image = File('${directory.path}/$name');

  return File(imagePath).copy(image.path);
}

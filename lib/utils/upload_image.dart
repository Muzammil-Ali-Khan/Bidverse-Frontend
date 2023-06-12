import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<String> uploadImageToFirebase(BuildContext context, File image) async {
  String fileName = (image.path);
  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
  UploadTask uploadTask = firebaseStorageRef.putFile(image);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => print('IMAGE UPLOADED'));
  String imageUrl = await taskSnapshot.ref.getDownloadURL();
  return imageUrl;
}

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

SnackBar customSnackBar(String content) {
  return SnackBar(
    content: Text(content, style: const TextStyle(color: white)),
    backgroundColor: darkBlueColor,
  );
}

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);

  TextEditingController controller;
  String hintText;
  IconData icon;
  bool? obscureText;
  TextInputType? keyboardType;
  String? initialValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: blackColor,
          size: 25.0,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: greyTextFieldText,
          fontSize: 16.0,
        ),
        fillColor: greyBackground,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: greyTextFieldText),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greyTextFieldText),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: greyTextFieldText),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}

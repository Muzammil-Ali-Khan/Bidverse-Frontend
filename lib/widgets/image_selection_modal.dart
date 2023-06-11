import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ImageSelectionModal extends StatelessWidget {
  const ImageSelectionModal({
    Key? key,
    required this.onPressedCamera,
    required this.onPressedGallery,
  }) : super(key: key);

  final void Function() onPressedCamera;
  final void Function() onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Select method",
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      actions: [
        buildButton(title: "Camera", icon: Icons.camera_alt_outlined, onPressed: onPressedCamera),
        const SizedBox(
          height: 5.0,
        ),
        buildButton(title: "Gallery", icon: Icons.image, onPressed: onPressedGallery),
      ],
    );
  }

  MaterialButton buildButton({required IconData icon, required String title, required void Function() onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: primaryColor,
      child: ListTile(
        leading: Icon(
          icon,
          color: white,
        ),
        title: Text(
          title,
          style: const TextStyle(color: white),
        ),
      ),
    );
  }
}

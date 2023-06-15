import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  checkCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      debugPrint('Permissions Granted');
    } else {
      await Permission.camera.request();
    }
  }
}

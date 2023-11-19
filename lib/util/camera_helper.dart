import 'package:camera/camera.dart';
import 'package:ma_flutter/util/device.dart';

class CameraHelper {
  static List<CameraDescription> cameras = [];

  static void initCameras() async {
    if (!Device.isDesktop()) {
      cameras = await availableCameras();
    }
  }

  static bool cameraFound() {
    return cameras.isNotEmpty;
  }
}

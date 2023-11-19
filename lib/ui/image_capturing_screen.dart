import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/util/camera_helper.dart';

class ImageCapturingScreen extends StatefulWidget {
  final void Function(XFile path) progressImage;

  const ImageCapturingScreen({super.key, required this.progressImage});

  @override
  ImageCapturingScreenState createState() => ImageCapturingScreenState();
}

class ImageCapturingScreenState extends State<ImageCapturingScreen> {
  late CameraController _controller;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return _controllerInitialized ? cameraScreen() : Center(child: CircularProgressIndicator());
  }

  Future<void> initializeCamera() async {
    try {
      _controller = CameraController(
        CameraHelper.cameras.first,
        ResolutionPreset.high,
      );
      await _controller.initialize();
      setState(() {
        _controllerInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Widget cameraScreen() {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    var navigationBarHeight = MediaQuery.of(context).viewPadding.bottom;
    var actualAspectRatio = _controller.value.aspectRatio;
    var targetAspectRatio = 4 / 3;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - statusBarHeight - navigationBarHeight;
    var maxFrameWidth = screenHeight / actualAspectRatio;
    var maxFrameHeight = screenWidth * actualAspectRatio;
    var frameWidth = screenWidth;
    var frameHeight = screenHeight;
    if (maxFrameWidth < screenWidth) {
      frameWidth = maxFrameWidth;
      frameHeight = screenHeight;
    } else if (maxFrameHeight < screenHeight) {
      frameWidth = screenWidth;
      frameHeight = maxFrameHeight;
    }
    var mainCameraAreaHeight = frameWidth * targetAspectRatio;
    var transparentBarHeight = (frameHeight - mainCameraAreaHeight) / 2;
    return Container(
      color: Colors.black,
      width: screenWidth,
      height: screenHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: statusBarHeight, bottom: navigationBarHeight),
      child: SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: Stack(
          children: [
            CameraPreview(_controller),
            Column(
              children: [
                Container(
                  width: frameWidth,
                  height: transparentBarHeight,
                  color: Colors.black.withOpacity(.7),
                ),
                SizedBox(
                  width: frameWidth,
                  height: mainCameraAreaHeight,
                ),
                Container(
                  width: frameWidth,
                  height: transparentBarHeight,
                  color: Colors.black.withOpacity(.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: onCancel,
                          child: Text(
                            "Abbrechen",
                            style:
                                SkeletonState.textTheme.titleMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: transparentBarHeight * .65,
                        height: transparentBarHeight * .65,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Center(
                          child: IconButton(
                            color: Colors.black,
                            icon: CustomIcon(
                              name: "aperture",
                              size: transparentBarHeight * .4,
                            ),
                            onPressed: onShoot,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onCancel() {
    // close
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void onShoot() async {
    // take picture
    final XFile rawImage = await _controller.takePicture();
    // crop image to 3:4 and save it
    img.Image? image = img.decodeImage(File(rawImage.path).readAsBytesSync());
    if (image == null) throw Exception("Error reading image");
    int newHeight = (image.width * (4 / 3)).toInt();
    int topPadding = (image.height - newHeight) ~/ 2;
    image = img.copyCrop(image, x: 0, y: topPadding, width: image.width, height: newHeight);
    String newPath = rawImage.path.replaceAll('.jpg', '_cropped.jpg');
    File(newPath).writeAsBytesSync(img.encodeJpg(image));
    // pass image to progressing function
    widget.progressImage(XFile(newPath));
    // close
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

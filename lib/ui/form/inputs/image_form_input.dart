import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/inputs/form_input.dart';
import 'package:ma_flutter/ui/image_capturing_screen.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/util/camera_helper.dart';
import 'package:ma_flutter/util/http_helper.dart';

class ImageFormInput extends StatefulWidget {
  final GlobalKey<CustomFormState> formKey;
  final String id;
  final String? initial;
  final String buttonText;

  const ImageFormInput({
    super.key,
    required this.formKey,
    required this.id,
    this.initial,
    this.buttonText = "Bild hinzufügen",
  });

  @override
  ImageFormInputState createState() => ImageFormInputState();
}

class ImageFormInputState extends State<ImageFormInput> implements FormInput {
  String? _filename;
  bool _canTakePictures = CameraHelper.cameraFound();

  @override
  void initState() {
    super.initState();
    _filename = widget.initial;
    widget.formKey.currentState!.addFormInput(widget.id, this);
  }

  @override
  Widget build(BuildContext context) {
    if (_canTakePictures || _filename != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: _filename == null ? addImageCardContent() : showImageCardContent(),
        ),
      );
    }
    return Container();
  }

  Widget? addImageCardContent() {
    return GestureDetector(
      onTap: openCamera,
      child: SizedBox(
        width: double.infinity,
        height: 100.0,
        child: Card(
          shadowColor: Colors.transparent,
          child: Center(
            child: Text(
              widget.buttonText,
              style: SkeletonState.textTheme.labelLarge
                  ?.copyWith(color: SkeletonState.colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget showImageCardContent() {
    return Stack(
      children: [
        Image.network(
          HttpHelper.getMediaURL(_filename!),
          height: 200.0,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _filename = null;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomIcon(
                      name: "xmark",
                      color: Colors.white,
                      size: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCapturingScreen(
          progressImage: (XFile image) async {
            Map<String, dynamic> response = await HttpHelper.image("receipt", File(image.path));
            setState(() {
              _filename = response["filename"];
            });
          },
        ),
      ),
    );
  }

  @override
  get value => _filename;
}

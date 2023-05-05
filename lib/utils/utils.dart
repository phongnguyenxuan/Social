import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myblog/utils/my_color.dart';

pickImage(ImageSource source, BuildContext context, bool isPost) async {
  try {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      if (isPost == true) {
        return await file.readAsBytes();
      } else {
        CroppedFile? croppedFile = await ImageCropper()
            .cropImage(sourcePath: file.path, aspectRatioPresets: [
          CropAspectRatioPreset.square
        ], uiSettings: [
          // ignore: use_build_context_synchronously
          AndroidUiSettings(
              toolbarTitle: 'Crop your image',
              toolbarColor: backgroundColor,
              backgroundColor: backgroundColor,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
              dimmedLayerColor: backgroundColor,
              statusBarColor: backgroundColor,
              activeControlsWidgetColor: Colors.white,
              hideBottomControls: false),
          // ignore: use_build_context_synchronously
          WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              barrierColor: backgroundColor,
              boundary: const CroppieBoundary(
                width: 300,
                height: 300,
              ),
              viewPort: const CroppieViewPort(
                  width: 200, height: 200, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
              mouseWheelZoom: true),
        ]);
        if (croppedFile != null) {
          return await croppedFile.readAsBytes();
        } else {
          ByteData byteData =
              await rootBundle.load('assets/images/astronaut.png');
          return byteData.buffer.asUint8List();
        }
      }
    }
  } catch (_) {
    return null;
  }
}

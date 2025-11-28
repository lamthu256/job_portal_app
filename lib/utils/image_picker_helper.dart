import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImagePickerHelper {
  static Future<File?> pickImageWithOptions(BuildContext context) async {
    final Completer<File?> completer = Completer<File?>();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Chụp ảnh'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await _pickImageFromCamera();
                  completer.complete(image);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn từ thư viện'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await _pickImageFromGallery();
                  completer.complete(image);
                },
              ),
            ],
          ),
        );
      },
    );

    return completer.future;
  }

  static Future<File?> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (pickedFile != null) {
      // Xử lý rotation để fix ảnh bị xoay
      final correctedFile = await _correctImageRotation(File(pickedFile.path));
      return correctedFile;
    }
    return null;
  }

  static Future<File?> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  static Future<File> _correctImageRotation(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return imageFile;

      // Bake orientation vào ảnh để fix rotation
      final correctedImage = img.bakeOrientation(image);

      // Resize ảnh nếu quá lớn (max 1200px)
      final resizedImage = img.copyResize(
        correctedImage,
        width: correctedImage.width > 1200 ? 1200 : correctedImage.width,
        height: correctedImage.height > 1200
            ? (correctedImage.height * 1200 ~/ correctedImage.width)
            : correctedImage.height,
        interpolation: img.Interpolation.linear,
      );

      // Encode thành JPEG với quality thấp hơn để tối ưu
      final correctedBytes = img.encodeJpg(resizedImage, quality: 75);
      await imageFile.writeAsBytes(correctedBytes);

      return imageFile;
    } catch (e) {
      print('Error correcting image rotation: $e');
      return imageFile;
    }
  }
}

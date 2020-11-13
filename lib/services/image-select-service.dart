import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

pickImage(
    BuildContext context, ImageSource imageSource, Function callback) async {
  try {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: true,
          aspectRatioLockEnabled: false,
        ),
      );
      callback(File(croppedFile.path));
      Navigator.pop(context);
    }
  } catch (e) {
    print(e);
  }
}

imageSelect(context, Function callback) => showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () => pickImage(context, ImageSource.gallery, callback)),
            new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () => pickImage(context, ImageSource.camera, callback)),
          ],
        ),
      );
    });

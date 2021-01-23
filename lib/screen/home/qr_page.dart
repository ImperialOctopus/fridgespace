import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Page to add new foods to the fridge.
class QrPage extends StatefulWidget {
  /// Page to add new foods to the fridge.
  const QrPage();
  _QrState createState() => _QrState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('QR'));
  }
}

class _QrState extends State<QrPage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final dynamic pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

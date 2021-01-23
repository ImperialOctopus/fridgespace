import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

/// Page to add new foods to the fridge.
class QrPage extends StatefulWidget {
  /// Page to add new foods to the fridge.
  const QrPage();

  @override
  _QrState createState() => _QrState();
}

class _QrState extends State<QrPage> {
  File _image;
  final picker = ImagePicker();
  var text = '';

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);

    final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();

    final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

    for (Barcode barcode in barcodes) {

      final String rawValue = barcode.rawValue;
      final BarcodeValueType valueType = barcode.valueType;

      setState(() {
        text ="$rawValue\nType: $valueType";
        print(text);
      });

    }
    if (barcodes.length == 0) {
      setState(() {
        text ='No barcode detected';
        print(text);
      });
    }

    barcodeDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? const Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

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

    var visionImage = FirebaseVisionImage.fromFile(_image);

    final barcodeDetector = FirebaseVision.instance.barcodeDetector();

    final barcodes = await barcodeDetector.detectInImage(visionImage);

    for (var barcode in barcodes) {

      final rawValue = barcode.rawValue;
      final valueType = barcode.valueType;

      setState(() {
        text ='$rawValue\nType: $valueType';
        print(text);
        if (valueType == BarcodeValueType.product){
          getProduct(rawValue);
        }
      });

    }
    if (barcodes.isEmpty) {
      setState(() {
        text ='No barcode detected';
        print(text);
      });
    }

    await(barcodeDetector.close());
  }

  Future<Product> getProduct(String barcode) async {

    var configuration = ProductQueryConfiguration(barcode, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    var result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      print(result.product.productName);
      print(result.product.quantity);
      return result.product;
    } else {
      print('product not found, please insert data for ' + barcode);
      return null;
    }
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

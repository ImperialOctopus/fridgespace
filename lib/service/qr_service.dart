import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../model/product_lookup_result.dart';

/// Service for managing barcode scanning.
class QrService {
  /// Request an image from the user. Returns null if they cancel.
  Future<File> requestImageFile() async {
    /// Attempt to get image from camera
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } on PlatformException {
      /// Exception occurred using camera so we try the gallery.
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    }
  }

  /// Detect barcodes present in an image.
  Future<List<Barcode>> readBarcodes(File file) async {
    /// Setup vision object.
    final visionImage = FirebaseVisionImage.fromFile(file);
    final barcodeDetector = FirebaseVision.instance.barcodeDetector();

    /// Detect barcodes in image.
    final barcodes = await barcodeDetector.detectInImage(visionImage);

    /// Release barcode detector.
    await barcodeDetector.close();

    return barcodes;
  }

  /// Look up a barcode to find its food item. Returns null if no valid result.
  Future<ProductLookupResult> lookupFoodItem(Barcode barcode) async {
    /// If barcode can be looked up as a product,
    if (barcode.valueType == BarcodeValueType.product) {
      var configuration = ProductQueryConfiguration(barcode.rawValue,
          language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
      var result = await OpenFoodAPIClient.getProduct(configuration);

      if (result.status == 1) {
        return ProductLookupResult(
          name: result.product.productName,
          quantity: result.product.quantity,
        );
      } else {
        /// Food item was not found in database.
        return null;
      }
    } else {
      /// Barcode was not a product.
      return null;
    }
  }
}
